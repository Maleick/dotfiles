# Roadmap: Red Team Dotfiles Reliability Sprint

## Milestones

- ✅ **v1.0 milestone** — Phases 1-4 shipped on 2026-02-25. Archive: `.planning/milestones/v1.0-ROADMAP.md`.
- ✅ **v1.1 automation** — Phases 5-6 shipped on 2026-02-25. Archive: `.planning/milestones/v1.1-ROADMAP.md`.
- 🟡 **v1.2 automation expansion** — Phases 7-8 planned.

## Active Roadmap: v1.2 automation expansion

**Milestone goal:** Extend verification automation contracts and compatibility evidence workflows without runtime feature-family expansion.

**Requirements in scope:** `AUTO-04`, `AUTO-05`, `COMP-03`

**Plan:** 2 phases, ordered for dependency safety.

| # | Phase | Goal | Requirements | Success Criteria |
|---|-------|------|--------------|------------------|
| 7 | ✅ Verification Wrapper Modes and Output Contracts | Add quick mode and machine-readable output while preserving default behavior contracts | `AUTO-04`, `AUTO-05` | 4 (completed 2026-02-25) |
| 8 | ✅ Compatibility Matrix Evidence Automation | Generate and maintain matrix rows from observed verification evidence with schema/provenance guardrails | `COMP-03` | 4 (completed 2026-02-25) |

### Phase 7: Verification Wrapper Modes and Output Contracts

**Status:** Complete (2026-02-25)

**Goal:** `./scripts/verify-suite.sh` supports quick mode and machine-readable output while preserving existing deterministic default behavior.

**Requirements:** `AUTO-04`, `AUTO-05`

**Success Criteria:**
1. Wrapper supports a quick-mode invocation path with a documented locked minimum required-check set.
2. Wrapper supports machine-readable output with per-check statuses and deterministic summary counts.
3. Default invocation behavior remains backward compatible with existing human-readable contract.
4. Verification artifacts show non-zero exit behavior is preserved when required checks fail.

### Phase 8: Compatibility Matrix Evidence Automation

**Status:** Complete (2026-02-25)

**Goal:** Compatibility matrix rows can be generated/updated from observed verification evidence without inferred status claims.

**Requirements:** `COMP-03`

**Success Criteria:**
1. Canonical matrix file `.planning/compatibility/v1.1-matrix.md` remains the source-of-truth artifact.
2. Matrix update flow requires schema-complete rows (`Environment Profile`, `Check Scope`, `Status`, `Caveat`, `Command Set Reference`, `Last Validated`).
3. Matrix updates capture observed evidence provenance and preserve status vocabulary (`PASS`/`SKIP`/`FAIL`).
4. README and AGENTS guidance reflect matrix generation/maintenance workflow and caveat interpretation.

## Notes

- Scope guardrail: no net-new runtime feature families in shell/tmux/vim.
- Deferred beyond v1.2: CI integration scaffolding and fully automatic matrix publication pipelines.

## Next Step

`$gsd-complete-milestone v1.2`
