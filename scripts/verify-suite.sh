#!/usr/bin/env bash

set -u

PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

status_line() {
  local status="$1"
  local check_id="$2"
  local message="$3"
  printf '%s | %s | %s\n' "$status" "$check_id" "$message"
}

run_required() {
  local check_id="$1"
  local description="$2"
  local cmd="$3"

  if eval "$cmd" >/dev/null 2>&1; then
    PASS_COUNT=$((PASS_COUNT + 1))
    status_line "PASS" "$check_id" "$description"
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    status_line "FAIL" "$check_id" "$description"
  fi
}

run_required_pattern() {
  local check_id="$1"
  local description="$2"
  local file="$3"
  local pattern="$4"

  if command -v rg >/dev/null 2>&1; then
    if rg -n "$pattern" "$file" >/dev/null 2>&1; then
      PASS_COUNT=$((PASS_COUNT + 1))
      status_line "PASS" "$check_id" "$description"
    else
      FAIL_COUNT=$((FAIL_COUNT + 1))
      status_line "FAIL" "$check_id" "$description"
    fi
  else
    if grep -E "$pattern" "$file" >/dev/null 2>&1; then
      PASS_COUNT=$((PASS_COUNT + 1))
      status_line "PASS" "$check_id" "$description"
    else
      FAIL_COUNT=$((FAIL_COUNT + 1))
      status_line "FAIL" "$check_id" "$description"
    fi
  fi
}

run_optional() {
  local check_id="$1"
  local description="$2"
  local cmd="$3"
  local guidance="$4"

  if eval "$cmd" >/dev/null 2>&1; then
    PASS_COUNT=$((PASS_COUNT + 1))
    status_line "PASS" "$check_id" "$description"
  else
    SKIP_COUNT=$((SKIP_COUNT + 1))
    status_line "SKIP" "$check_id" "$guidance"
  fi
}

ensure_repo_root() {
  if [ "$(pwd)" != "$REPO_ROOT" ]; then
    status_line "FAIL" "env.repo_root" "Run this command from repo root: $REPO_ROOT"
    exit 2
  fi
}

main() {
  ensure_repo_root

  run_required "req.install_syntax" "install.sh parses cleanly" "bash -n install.sh"
  run_required "req.zsh_syntax" "zsh config parses cleanly" "zsh -n zsh/.zshrc"
  run_required "req.tmux_config" "tmux config loads without parse errors" "tmux -f tmux/.tmux.conf -L gsd-verify-suite start-server \\; kill-server"
  run_required "req.vim_startup" "vim starts headless with repo vimrc" "vim -Nu vim/.vimrc -n -es -c 'qa!'"
  run_required "req.vim_temp_home" "vim starts with temporary HOME context" "TMP_HOME=\"\$(mktemp -d)\" && HOME=\"\$TMP_HOME\" vim -Nu vim/.vimrc -n -es -c 'qa!' && rm -rf \"\$TMP_HOME\""
  run_required_pattern "req.readme_verify_section" "README keeps verification checklist section" "README.md" "Documentation & Release Verification Checklist"
  run_required_pattern "req.agents_tmux_contract" "AGENTS keeps tmux contract notes" "AGENTS.md" "Prefix \\+ P|Prefix \\+ U|Prefix \\+ K|~/Logs"

  printf 'SUMMARY | PASS=%s FAIL=%s SKIP=%s\n' "$PASS_COUNT" "$FAIL_COUNT" "$SKIP_COUNT"
  [ "$FAIL_COUNT" -eq 0 ]
}

main "$@"
