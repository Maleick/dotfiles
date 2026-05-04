#!/usr/bin/env bash

set -u

PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0
QUICK_MODE=0
OUTPUT_JSON=0
FORCE_FAIL_REQUIRED="${VERIFY_SUITE_FORCE_FAIL_REQUIRED:-0}"
QUICK_SKIP_REASON_PREFIX="Skipped in quick mode (full-only required check):"
RESULTS_FILE=""

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat <<'USAGE'
Usage: ./scripts/verify-suite.sh [--quick] [--json] [--help]

Options:
  --quick   Run quick-mode verification with locked minimum required checks
  --json    Emit deterministic machine-readable JSON output
  --help    Show this help text
USAGE
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --quick)
        QUICK_MODE=1
        ;;
      --json)
        OUTPUT_JSON=1
        ;;
      --help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown argument: $1" >&2
        usage >&2
        exit 2
        ;;
    esac
    shift
  done
}

init_results_file() {
  RESULTS_FILE="$(mktemp "${TMPDIR:-/tmp}/verify-suite-results.XXXXXX")"
  trap 'rm -f "$RESULTS_FILE"' EXIT
}

status_line() {
  local status="$1"
  local check_id="$2"
  local message="$3"
  printf '%s | %s | %s\n' "$status" "$check_id" "$message"
}

record_status() {
  local status="$1"
  local check_id="$2"
  local kind="$3"
  local message="$4"

  case "$status" in
    PASS)
      PASS_COUNT=$((PASS_COUNT + 1))
      ;;
    FAIL)
      FAIL_COUNT=$((FAIL_COUNT + 1))
      ;;
    SKIP)
      SKIP_COUNT=$((SKIP_COUNT + 1))
      ;;
  esac

  printf '%s\t%s\t%s\t%s\n' "$status" "$check_id" "$kind" "$message" >>"$RESULTS_FILE"

  if [ "$OUTPUT_JSON" != "1" ]; then
    status_line "$status" "$check_id" "$message"
  fi
}

run_required() {
  local check_id="$1"
  local description="$2"
  local cmd="$3"

  if [ "$FORCE_FAIL_REQUIRED" = "1" ] && [ "$check_id" = "req.install_syntax" ]; then
    record_status "FAIL" "$check_id" "required" "Forced required failure via VERIFY_SUITE_FORCE_FAIL_REQUIRED=1"
    return
  fi

  if eval "$cmd" >/dev/null 2>&1; then
    record_status "PASS" "$check_id" "required" "$description"
  else
    record_status "FAIL" "$check_id" "required" "$description"
  fi
}

run_required_pattern() {
  local check_id="$1"
  local description="$2"
  local file="$3"
  local pattern="$4"

  if command -v rg >/dev/null 2>&1; then
    if rg -n "$pattern" "$file" >/dev/null 2>&1; then
      record_status "PASS" "$check_id" "required" "$description"
    else
      record_status "FAIL" "$check_id" "required" "$description"
    fi
  else
    if grep -E "$pattern" "$file" >/dev/null 2>&1; then
      record_status "PASS" "$check_id" "required" "$description"
    else
      record_status "FAIL" "$check_id" "required" "$description"
    fi
  fi
}

run_required_absent_pattern() {
  local check_id="$1"
  local description="$2"
  local file="$3"
  local pattern="$4"

  if command -v rg >/dev/null 2>&1; then
    if rg -n "$pattern" "$file" >/dev/null 2>&1; then
      record_status "FAIL" "$check_id" "required" "$description"
    else
      record_status "PASS" "$check_id" "required" "$description"
    fi
  else
    if grep -E "$pattern" "$file" >/dev/null 2>&1; then
      record_status "FAIL" "$check_id" "required" "$description"
    else
      record_status "PASS" "$check_id" "required" "$description"
    fi
  fi
}

run_optional() {
  local check_id="$1"
  local description="$2"
  local cmd="$3"
  local guidance="$4"

  if eval "$cmd" >/dev/null 2>&1; then
    record_status "PASS" "$check_id" "optional" "$description"
  else
    record_status "SKIP" "$check_id" "optional" "$guidance"
  fi
}

run_quick_skip() {
  local check_id="$1"
  local description="$2"
  record_status "SKIP" "$check_id" "required" "$QUICK_SKIP_REASON_PREFIX $description"
}

ensure_repo_root() {
  if [ "$(pwd)" != "$REPO_ROOT" ]; then
    status_line "FAIL" "env.repo_root" "Run this command from repo root: $REPO_ROOT"
    exit 2
  fi
}

run_minimum_required_checks() {
  run_required "req.install_syntax" "install.sh parses cleanly" "bash -n install.sh"
  run_required_pattern "req.install_script_dir" "install.sh resolves repo root from script location" "install.sh" 'BASH_SOURCE\[0\]'
  run_required "req.zsh_syntax" "zsh config parses cleanly" "zsh -n zsh/.zshrc"
  run_required_absent_pattern "req.zsh_no_host_specific_tail" "zsh config keeps host-specific loaders in ~/.zshrc.local" "zsh/.zshrc" 'VanguardForge|PNPM_HOME|claude-mem|iterm2_shell_integration|rtk-wrapper'
  run_required "req.tmux_config" "tmux config loads without parse errors" "tmux -f tmux/.tmux.conf -L gsd-verify-suite start-server \\; kill-server"
  run_required_pattern "req.tmux_clipboard_fallback" "tmux copy binding includes portable clipboard fallback" "tmux/.tmux.conf" 'pbcopy.*(wl-copy|xclip|clip\.exe|tmux load-buffer)|(wl-copy|xclip|clip\.exe|tmux load-buffer).*pbcopy'
  run_required_absent_pattern "req.tmux_no_asciinema_fzf" "tmux config has no asciinema or fzf dependency" "tmux/.tmux.conf" 'asciinema|fzf'
  run_required_absent_pattern "req.vim_no_fzf" "vim config has no fzf plugin dependency" "vim/.vimrc" 'junegunn/fzf|fzf#install|fzf\.vim|g:fzf'
  run_required "req.vim_startup" "vim starts headless with repo vimrc" "vim -Nu vim/.vimrc -n -es -c 'qa!'"
  run_required "req.operator_docs_surface" "operator field kit docs, wiki, and Pages surfaces exist" "test -f assets/dotfiles-banner.svg && test -f docs/index.html && test -f docs/CNAME && test -f wiki/Home.md && test -f wiki/Installation.md && test -f wiki/Verification.md && test -f wiki/Customization.md && test -f wiki/Tmux.md && test -f wiki/Vim.md && grep -qx 'dotfiles.teamoperator.red' docs/CNAME"
}

run_full_only_required_checks() {
  if [ "$QUICK_MODE" = "1" ]; then
    run_quick_skip "req.vim_temp_home" "vim starts with temporary HOME context"
    run_quick_skip "req.readme_verify_section" "README keeps verification checklist section"
    run_quick_skip "req.readme_operator_field_kit" "README presents Operator Field Kit identity and Pages link"
    run_quick_skip "req.docs_no_asciinema_fzf" "current operator docs do not reference asciinema or fzf"
    run_quick_skip "req.agents_tmux_contract" "AGENTS keeps tmux contract notes"
    run_quick_skip "req.agents_no_asciinema_fzf" "AGENTS does not require asciinema or fzf workflows"
    return
  fi

  run_required "req.vim_temp_home" "vim starts with temporary HOME context" "TMP_HOME=\"\$(mktemp -d)\" && HOME=\"\$TMP_HOME\" vim -Nu vim/.vimrc -n -es -c 'qa!' && rm -rf \"\$TMP_HOME\""
  run_required_pattern "req.readme_verify_section" "README keeps verification checklist section" "README.md" "Documentation & Release Verification Checklist"
  run_required_pattern "req.readme_operator_field_kit" "README presents Operator Field Kit identity and Pages link" "README.md" "Operator Field Kit|dotfiles.teamoperator.red|assets/dotfiles-banner.svg"
  run_required_absent_pattern "req.docs_no_asciinema_fzf" "current operator docs do not reference asciinema or fzf" "README.md" 'asciinema|fzf|Prefix \+ P'
  run_required_pattern "req.agents_tmux_contract" "AGENTS keeps tmux contract notes" "AGENTS.md" "Prefix \\+ S|Prefix \\+ U|Prefix \\+ K|~/Logs"
  run_required_absent_pattern "req.agents_no_asciinema_fzf" "AGENTS does not require asciinema or fzf workflows" "AGENTS.md" 'asciinema|fzf|Prefix \+ P'
}

run_optional_checks() {
  return 0
}

emit_summary() {
  if [ "$OUTPUT_JSON" = "1" ]; then
    python3 - "$RESULTS_FILE" "$QUICK_MODE" <<'PY'
import json
import sys

results_file = sys.argv[1]
quick_mode = sys.argv[2] == "1"
checks = []

with open(results_file, "r", encoding="utf-8") as fh:
    for raw in fh:
        status, check_id, kind, message = raw.rstrip("\n").split("\t", 3)
        checks.append(
            {
                "status": status,
                "id": check_id,
                "kind": kind,
                "message": message,
            }
        )

summary = {
    "pass": sum(1 for c in checks if c["status"] == "PASS"),
    "fail": sum(1 for c in checks if c["status"] == "FAIL"),
    "skip": sum(1 for c in checks if c["status"] == "SKIP"),
}
summary["required_fail"] = any(c["status"] == "FAIL" and c["kind"] == "required" for c in checks)

payload = {
    "mode": "quick" if quick_mode else "full",
    "format": "json",
    "checks": checks,
    "summary": summary,
}
print(json.dumps(payload, separators=(",", ":"), ensure_ascii=True))
PY
  else
    printf 'SUMMARY | PASS=%s FAIL=%s SKIP=%s\n' "$PASS_COUNT" "$FAIL_COUNT" "$SKIP_COUNT"
  fi
}

main() {
  parse_args "$@"
  ensure_repo_root
  init_results_file

  run_minimum_required_checks
  run_full_only_required_checks
  run_optional_checks

  emit_summary
  [ "$FAIL_COUNT" -eq 0 ]
}

main "$@"
