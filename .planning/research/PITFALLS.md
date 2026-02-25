# Pitfalls Research

**Domain:** Wrapper mode expansion and compatibility evidence automation
**Researched:** 2026-02-25
**Confidence:** HIGH

## Critical Pitfalls

### Pitfall 1: Quick Mode Becomes a Weak Signal

**What goes wrong:**
Quick mode skips too many required checks and reports green status that does not represent runtime stability.

**Why it happens:**
Speed optimization is prioritized without defining non-negotiable required check coverage.

**How to avoid:**
Lock a minimum required-check set for quick mode and verify it explicitly in plan-level smoke checks.

**Warning signs:**
Operators stop running full mode because quick mode appears sufficient but misses regressions.

**Phase to address:**
Phase 7 (wrapper mode implementation).

---

### Pitfall 2: Machine Output Contract Drifts from Human Output

**What goes wrong:**
Human output and machine output disagree on counts, statuses, or check IDs.

**Why it happens:**
Separate formatting paths evolve independently.

**How to avoid:**
Generate both outputs from one shared result model and include consistency checks in verification.

**Warning signs:**
`PASS` counts differ between text summary and machine payload for the same run.

**Phase to address:**
Phase 7 (output contract hardening).

---

### Pitfall 3: Matrix Generation Writes Inferred Results

**What goes wrong:**
Generated matrix rows include PASS/FAIL claims without observed evidence artifacts.

**Why it happens:**
Automation script favors convenience over provenance rules.

**How to avoid:**
Require explicit command reference and validation date per row; reject writes when evidence fields are missing.

**Warning signs:**
Rows appear with status but no command reference or caveat.

**Phase to address:**
Phase 8 (matrix generation automation).

---

### Pitfall 4: Matrix Schema Diverges Across Updates

**What goes wrong:**
New rows use inconsistent columns or status vocabulary (`OK`, `WARN`, etc.).

**Why it happens:**
No schema validation gate in update flow.

**How to avoid:**
Enforce canonical columns and allowed status set (`PASS`/`SKIP`/`FAIL`) in update helper and verification checks.

**Warning signs:**
Review diffs show ad hoc headers or alternate status labels.

**Phase to address:**
Phase 8 (schema guardrails and docs linkage).

## Technical Debt Watchlist

| Debt Item | Impact | Mitigation |
|-----------|--------|------------|
| Wrapper script complexity increases without structure | Harder reviews, higher regression risk | Introduce helper functions/files with clear ownership boundaries |
| Optional dependency handling duplicated across modes | Inconsistent behavior and messaging | Centralize optional check handling and guidance strings |
| No output versioning for machine mode | Breaking downstream tooling silently | Define and document a stable output schema version |

## Verification Traps

### Trap 1: Syntax-Only Verification

**Risk:**
`bash -n` passes while behavior contracts still fail.

**Prevention:**
Require behavioral smoke checks for quick/full mode execution and failure semantics.

### Trap 2: Host-Specific Assumptions Hidden in Matrix

**Risk:**
macOS observations are generalized to Linux.

**Prevention:**
Keep environment-profile/caveat fields mandatory and mark unobserved hosts as `SKIP`.

### Trap 3: Docs Drift from New Mode Flags

**Risk:**
README/AGENTS miss mode semantics, leading to operator confusion.

**Prevention:**
Treat docs updates as required tasks in the same phase that introduces new flags.

## Prevention Checklist

- Keep quick mode and full mode check definitions explicit and testable.
- Validate machine output structure with deterministic fixtures/smoke checks.
- Reject matrix updates that lack evidence provenance fields.
- Preserve status vocabulary and canonical matrix columns.
- Update README and AGENTS in lockstep with wrapper/matrix behavior changes.

## Sources

- `.planning/milestones/v1.1-REQUIREMENTS.md`
- `.planning/compatibility/v1.1-matrix.md`
- `scripts/verify-suite.sh`
- `README.md`
- `AGENTS.md`

---
*Pitfalls research for: v1.2 automation expansion*
*Researched: 2026-02-25*
