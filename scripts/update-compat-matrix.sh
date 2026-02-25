#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PYTHON_BIN="${PYTHON_BIN:-python3}"

usage() {
  cat <<'USAGE'
Usage: ./scripts/update-compat-matrix.sh --evidence <json-file> --env-profile <text> --check-scope <text> --caveat <text> --command-ref <text> --date YYYY-MM-DD [--matrix <path>] [--status PASS|SKIP|FAIL]

Updates the canonical compatibility matrix using observed wrapper JSON evidence.

Required:
  --evidence      Path to JSON produced by ./scripts/verify-suite.sh --json
  --env-profile   Matrix Environment Profile key
  --check-scope   Matrix Check Scope key
  --caveat        Caveat text for this row
  --command-ref   Command/provenance reference
  --date          Last validated date (YYYY-MM-DD)

Optional:
  --matrix        Matrix file path (default: .planning/compatibility/v1.1-matrix.md)
  --status        Explicit status override (validated against evidence)
  --help          Show this help text
USAGE
}

if [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$(pwd)" != "$REPO_ROOT" ]; then
  echo "ERROR: run this command from repo root: $REPO_ROOT" >&2
  exit 2
fi

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "ERROR: python3 is required for matrix update automation" >&2
  exit 2
fi

"$PYTHON_BIN" scripts/update_compat_matrix.py "$@"
