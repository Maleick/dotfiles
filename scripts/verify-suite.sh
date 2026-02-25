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

  # Required checks added in task execution steps.

  printf 'SUMMARY | PASS=%s FAIL=%s SKIP=%s\n' "$PASS_COUNT" "$FAIL_COUNT" "$SKIP_COUNT"
  [ "$FAIL_COUNT" -eq 0 ]
}

main "$@"
