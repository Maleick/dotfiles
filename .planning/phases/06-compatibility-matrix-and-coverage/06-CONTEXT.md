# Phase 6: Compatibility Matrix and Coverage - Context

**Gathered:** 2026-02-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 6 delivers compatibility guidance grounded in validated runtime behavior. This phase defines and publishes a compatibility matrix that covers baseline macOS/Linux verification outcomes for install, shell, tmux, and vim checks, then links matrix usage from operator/maintainer docs.

Scope is compatibility documentation and coverage clarity only. No net-new runtime feature families are introduced in this phase.

</domain>

<decisions>
## Implementation Decisions

### Matrix Scope Contract
- Phase 6 delivers compatibility guidance only; no new runtime feature families.
- Matrix coverage includes baseline macOS/Linux behavior for install/shell/tmux/vim verification outcomes.
- Matrix guidance must remain aligned with actual repository contracts in `install.sh`, `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`.

### Canonical Matrix Location
- Source-of-truth matrix artifact path is `.planning/compatibility/v1.1-matrix.md`.
- Phase 6 context, research, plan, and docs updates must point to that canonical matrix file.

### Row Schema Contract
- Each matrix row must include:
  - environment profile
  - check scope
  - status (`PASS`/`SKIP`/`FAIL`)
  - caveat text
  - command set reference
  - last-validated date
- Status semantics must preserve optional/fail-soft nuance (`SKIP`) and avoid ambiguous narrative-only entries.

### Evidence Contract
- Compatibility claims must be backed by observed command-run evidence only.
- Evidence sources are wrapper/checklist execution outcomes (for example `./scripts/verify-suite.sh` and phase checklist commands).
- Inferred compatibility claims without executed evidence are out of policy for this phase.

### Coverage and Caveat Model
- Coverage depth is baseline macOS/Linux plus explicit runtime caveat tags.
- Caveats must explicitly note relevant dependency/runtime assumptions, including optional dependency presence (`asciinema`, `fzf`), terminal/runtime context, and network-sensitive behavior where applicable.

### Documentation Linkage Contract
- `README.md` and `AGENTS.md` must reference matrix usage and interpretation for operators/maintainers.
- Documentation updates in this phase explain matrix consumption and limits; they do not add new runtime features.

### Freshness Policy
- Balanced baseline freshness policy applies.
- Refresh matrix entries when relevant verification/runtime/doc changes occur and before milestone closeout.
- Matrix freshness is not a hard release-block gate in this phase.

### Scope Guardrails
- No quick mode implementation (`AUTO-04`) in this phase.
- No machine-readable output mode implementation (`AUTO-05`) in this phase.
- No CI-provider-specific integration scaffolding in this phase.
- No matrix auto-generation pipeline in this phase.

### Claude's Discretion
- Exact matrix table column ordering and formatting style.
- Exact caveat tag naming conventions, if they preserve required semantics.
- Placement and wording style for README/AGENTS matrix references.

</decisions>

<specifics>
## Specific Ideas

- Use `./scripts/verify-suite.sh` as the primary evidence source for Phase 6 matrix entries.
- Cross-reference baseline command intent from `.planning/phases/01-installation-baseline/01-VERIFICATION-CHECKLIST.md`.
- Keep docs references anchored in `README.md` and `AGENTS.md` so operators and maintainers can locate matrix guidance quickly.
- Maintain explicit requirement traceability to `COMP-01` and `COMP-02` in planning artifacts.
- Canonical matrix file should remain under `.planning/compatibility/v1.1-matrix.md` for milestone-local ownership and update flow.

</specifics>

<deferred>
## Deferred Ideas

- `AUTO-04`: quick-mode execution path.
- `AUTO-05`: machine-readable output mode.
- `COMP-03`: generated matrix rows from repeatable run history.
- Deep permutation matrix expansion (distro/terminal/profile explosion) beyond baseline Phase 6 scope.

</deferred>

---

*Phase: 06-compatibility-matrix-and-coverage*
*Context gathered: 2026-02-25*
