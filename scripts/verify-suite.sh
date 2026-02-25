#!/usr/bin/env bash

set -u

PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0
QUICK_MODE=0
FORCE_FAIL_REQUIRED="${VERIFY_SUITE_FORCE_FAIL_REQUIRED:-0}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat <<'USAGE'
Usage: ./scripts/verify-suite.sh [--quick] [--help]

Options:
  --quick   Run quick-mode verification with locked minimum required checks
  --help    Show this help text
USAGE
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --quick)
        QUICK_MODE=1
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

status_line() {
  local status="$1"
  local check_id="$2"
  local message="$3"
  printf '%s | %s | %s\n' "$status" "$check_id" "$message"
}

record_status() {
  local status="$1"
  local check_id="$2"
  local message="$3"

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

  status_line "$status" "$check_id" "$message"
}

run_required() {
  local check_id="$1"
  local description="$2"
  local cmd="$3"

  if [ "$FORCE_FAIL_REQUIRED" = "1" ] && [ "$check_id" = "req.install_syntax" ]; then
    record_status "FAIL" "$check_id" "Forced required failure via VERIFY_SUITE_FORCE_FAIL_REQUIRED=1"
    return
  fi

  if eval "$cmd" >/dev/null 2>&1; then
    record_status "PASS" "$check_id" "$description"
  else
    record_status "FAIL" "$check_id" "$description"
  fi
}

run_required_pattern() {
  local check_id="$1"
  local description="$2"
  local file="$3"
  local pattern="$4"

  if command -v rg >/dev/null 2>&1; then
    if rg -n "$pattern" "$file" >/dev/null 2>&1; then
      record_status "PASS" "$check_id" "$description"
    else
      record_status "FAIL" "$check_id" "$description"
    fi
  else
    if grep -E "$pattern" "$file" >/dev/null 2>&1; then
      record_status "PASS" "$check_id" "$description"
    else
      record_status "FAIL" "$check_id" "$description"
    fi
  fi
}

run_optional() {
  local check_id="$1"
  local description="$2"
  local cmd="$3"
  local guidance="$4"

  if eval "$cmd" >/dev/null 2>&1; then
    record_status "PASS" "$check_id" "$description"
  else
    record_status "SKIP" "$check_id" "$guidance"
  fi
}

run_quick_skip() {
  local check_id="$1"
  local description="$2"
  record_status "SKIP" "$check_id" "Skipped in quick mode: $description"
}

ensure_repo_root() {
  if [ "$(pwd)" != "$REPO_ROOT" ]; then
    status_line "FAIL" "env.repo_root" "Run this command from repo root: $REPO_ROOT"
    exit 2
  fi
}

run_minimum_required_checks() {
  run_required "req.install_syntax" "install.sh parses cleanly" "bash -n install.sh"
  run_required "req.zsh_syntax" "zsh config parses cleanly" "zsh -n zsh/.zshrc"
  run_required "req.tmux_config" "tmux config loads without parse errors" "tmux -f tmux/.tmux.conf -L gsd-verify-suite start-server \\; kill-server"
  run_required "req.vim_startup" "vim starts headless with repo vimrc" "vim -Nu vim/.vimrc -n -es -c 'qa!'"
}

run_full_only_required_checks() {
  if [ "$QUICK_MODE" = "1" ]; then
    run_quick_skip "req.vim_temp_home" "vim starts with temporary HOME context"
    run_quick_skip "req.readme_verify_section" "README keeps verification checklist section"
    run_quick_skip "req.agents_tmux_contract" "AGENTS keeps tmux contract notes"
    return
  fi

  run_required "req.vim_temp_home" "vim starts with temporary HOME context" "TMP_HOME=\"\$(mktemp -d)\" && HOME=\"\$TMP_HOME\" vim -Nu vim/.vimrc -n -es -c 'qa!' && rm -rf \"\$TMP_HOME\""
  run_required_pattern "req.readme_verify_section" "README keeps verification checklist section" "README.md" "Documentation & Release Verification Checklist"
  run_required_pattern "req.agents_tmux_contract" "AGENTS keeps tmux contract notes" "AGENTS.md" "Prefix \\+ P|Prefix \\+ U|Prefix \\+ K|~/Logs"
}

run_optional_checks() {
  run_optional "opt.asciinema" "asciinema is available for recording flow checks" "command -v asciinema >/dev/null 2>&1 && asciinema --version >/dev/null 2>&1" "Install asciinema to enable recording dependency checks"
  run_optional "opt.fzf" "fzf is available for session-switch helper checks" "command -v fzf >/dev/null 2>&1 && fzf --version >/dev/null 2>&1" "Install fzf to enable session-switch dependency checks"
}

main() {
  parse_args "$@"
  ensure_repo_root

  run_minimum_required_checks
  run_full_only_required_checks
  run_optional_checks

  printf 'SUMMARY | PASS=%s FAIL=%s SKIP=%s\n' "$PASS_COUNT" "$FAIL_COUNT" "$SKIP_COUNT"
  [ "$FAIL_COUNT" -eq 0 ]
}

main "$@"
