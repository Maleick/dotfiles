---
phase: "07"
name: "verification-wrapper-modes-and-output-contracts"
created: 2026-02-25
verified: 2026-02-25
status: passed
score: "2/2"
---

# Phase 7: verification-wrapper-modes-and-output-contracts — Verification

## Goal-Backward Verification

**Phase Goal:** `./scripts/verify-suite.sh` supports quick mode and machine-readable output while preserving existing deterministic default behavior.

## Checks

| # | Requirement / Goal Truth | Status | Evidence |
|---|--------------------------|--------|----------|
| 1 | `AUTO-04`: quick-mode invocation exists, uses locked subset behavior, and preserves required-failure semantics | PASS | `./scripts/verify-suite.sh --quick` succeeds with deterministic output and explicit quick-mode `SKIP` visibility for full-only required checks (`req.vim_temp_home`, `req.readme_verify_section`, `req.agents_tmux_contract`) while keeping required baseline checks active. Forced required failure in quick-capable path remains non-zero (`VERIFY_SUITE_FORCE_FAIL_REQUIRED=1` yields `rc=1`). |
| 2 | `AUTO-05`: machine-readable output and combined mode are deterministic and contract-preserving | PASS | `./scripts/verify-suite.sh --json` and `./scripts/verify-suite.sh --quick --json` produce parseable deterministic JSON payloads with per-check records and summary counts, including mode indicators (`full`/`quick`). Forced required failure in JSON mode returns non-zero and sets `required_fail=true` in summary. README and AGENTS now document mode flags (`default`, `--quick`, `--json`, `--quick --json`) and backward-compatibility expectations. |

## Result

Phase 7 verification passed. Wrapper modes and output contracts are implemented for quick, JSON, and combined runs while preserving deterministic default behavior and required-failure exit semantics.
