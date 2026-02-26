# Roadmap: Red Team Dotfiles Reliability Sprint

## Milestones

- ✅ **v1.0 milestone** — Phases 1-4 shipped on 2026-02-25. Archive: `.planning/milestones/v1.0-ROADMAP.md`.
- ✅ **v1.1 automation** — Phases 5-6 shipped on 2026-02-25. Archive: `.planning/milestones/v1.1-ROADMAP.md`.
- ✅ **v1.2 automation expansion** — Phases 7-8 shipped on 2026-02-25. Archive: `.planning/milestones/v1.2-ROADMAP.md`.
- 🟡 **v1.3 automation hardening** — Phases 9-10 planned.

## Active Roadmap: v1.3 automation hardening

**Milestone goal:** Harden verification automation contracts with explicit schema versioning and broader evidence-backed compatibility coverage.

**Requirements in scope:** `AUTO-06`, `COMP-04`

**Plan:** 2 phases, ordered for dependency safety.

| # | Phase | Goal | Requirements | Success Criteria |
|---|-------|------|--------------|------------------|
| 9 | Verification Schema Versioning Contract | Add explicit machine-readable schema versioning while preserving existing parser compatibility and required-failure semantics | `AUTO-06` | 4 |
| 10 | Compatibility Coverage Expansion | Expand compatibility matrix evidence across additional Linux distro/terminal profiles with deterministic row maintenance guardrails | `COMP-04` | 4 |

### Phase 9: Verification Schema Versioning Contract

**Goal:** `./scripts/verify-suite.sh --json` emits explicit versioned schema metadata and maintains backward-compatible payload semantics.

**Requirements:** `AUTO-06`

**Success Criteria:**
1. JSON output includes explicit schema metadata (name/version) without removing existing fields (`checks`, `summary`, mode semantics).
2. Existing parser expectations for status values and summary counts remain compatible.
3. Required-failure behavior remains non-zero and represented consistently in JSON summary semantics.
4. README and AGENTS document schema versioning and compatibility policy for maintainers/operators.

### Phase 10: Compatibility Coverage Expansion

**Goal:** Compatibility matrix coverage expands to additional Linux distro/terminal profiles with evidence-only claims and deterministic update behavior.

**Requirements:** `COMP-04`

**Success Criteria:**
1. `.planning/compatibility/v1.1-matrix.md` includes additional observed Linux distro/terminal profile rows with canonical schema fields.
2. New/updated rows preserve status vocabulary (`PASS`/`SKIP`/`FAIL`) and required caveat/provenance/date fields.
3. Matrix update tooling continues deterministic update/insert behavior for expanded profile keys.
4. Verification artifacts document expanded coverage runs and rejection-path safeguards for malformed evidence/schema.

## Notes

- Scope guardrail: no net-new runtime feature families in shell/tmux/vim.
- Deferred beyond v1.3: CI publishing pipelines and matrix externalization flows.

## Next Step

`$gsd-discuss-phase 9 --auto`
