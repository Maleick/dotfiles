---
phase: 07-verification-wrapper-modes-and-output-contracts
plan: 01
subsystem: verification
tags: [wrapper, quick-mode, deterministic-output]
requires:
  - phase: 05-validation-wrapper-baseline
    provides: Baseline wrapper contract and deterministic status semantics
provides:
  - `--quick` mode support on `./scripts/verify-suite.sh`
  - Locked minimum required-check subset execution in quick mode
  - Explicit quick-mode skip visibility for full-only required checks
affects: [phase-07-02, operator-verification-flow]
tech-stack:
  added: []
  patterns: [mode-aware check selection, deterministic quick/full parity]
key-files:
  created: []
  modified:
    - scripts/verify-suite.sh
key-decisions:
  - "Keep no-flag default path behaviorally equivalent to full baseline run"
  - "Surface full-only required checks as explicit quick-mode SKIP entries"
patterns-established:
  - "Quick mode is deterministic and non-interactive"
  - "Quick-mode required failure remains non-zero via existing required-failure contract"
requirements-completed: [AUTO-04]
duration: 3 min
completed: 2026-02-25
---

# Phase 7 Plan 01: Verification Wrapper Modes and Output Contracts Summary

**Implemented quick-mode wrapper behavior with preserved default/full compatibility.**

## Performance

- **Duration:** 3 min
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Added CLI argument handling for `--quick` while preserving existing no-flag wrapper behavior.
- Added deterministic quick-mode execution path using a locked minimum required-check subset.
- Added explicit `SKIP` entries for full-only required checks so quick-mode scope remains visible to operators.
- Preserved non-zero required-failure semantics in quick mode.

## Task Commits

1. **Task 1: Add wrapper mode parser and quick-mode check selection** - `255a17a` (feat)
2. **Task 2: Lock quick-mode subset semantics and preserve default/full compatibility** - `97f1a00` (feat)

## Files Created/Modified
- `scripts/verify-suite.sh` - Adds `--quick` mode parsing, deterministic quick subset routing, and explicit quick-mode skip messages for full-only required checks.

## Decisions Made
- Quick mode keeps optional checks fail-soft behavior while reducing required-check workload.
- Full-only required checks are surfaced as deterministic quick-mode skips rather than silently omitted.

## Deviations from Plan

None - plan executed as written.

## Issues Encountered
None.

## Next Phase Readiness
- `AUTO-04` quick-mode contract is in place.
- Script is ready for Phase 7 Plan 02 JSON/combined mode extension.

---
*Phase: 07-verification-wrapper-modes-and-output-contracts*
*Completed: 2026-02-25*
