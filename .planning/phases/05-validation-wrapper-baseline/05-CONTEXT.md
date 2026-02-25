# Phase 5: Validation Wrapper Baseline - Context

**Gathered:** 2026-02-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 5 delivers a single repository-root validation wrapper for baseline reliability checks. The wrapper validates shipped contracts in `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, and docs/runtime parity references. Compatibility matrix authoring is explicitly out of scope for this phase and belongs to Phase 6.

Scope is reliability verification behavior only: no net-new runtime feature families, no keybinding redesign, and no auto-rewrite behavior for tracked configs.

</domain>

<decisions>
## Implementation Decisions

### Invocation Contract
- Wrapper command contract is `./scripts/verify-suite.sh`.
- Command must run non-interactively from repository root.
- Wrapper must not run `install.sh` by default; verification posture remains read-only.

### Check Suite Scope
- Required check coverage includes shell (`zsh/.zshrc`), tmux (`tmux/.tmux.conf`), vim (`vim/.vimrc`), and docs/runtime parity checks in `README.md` and `AGENTS.md`.
- Required checks failing must fail the run.
- Optional checks stay fail-soft.

### Output and Exit Semantics
- Print deterministic per-check status lines: `PASS`, `FAIL`, or `SKIP`.
- Print a final deterministic summary with status counts.
- Exit `0` only when all required checks pass.
- Exit non-zero when any required check fails.

### Optional Dependency Policy
- Optional tools (`asciinema`, `fzf`) remain optional.
- Missing optional tools must produce actionable `SKIP` guidance, not silent drops.
- Prefer fallback behavior over hard failure where fallback is already part of current contracts.

### Documentation Contract
- `README.md` must document wrapper usage and outcome semantics.
- `AGENTS.md` must preserve maintainer-facing contract notes for wrapper behavior.
- Documentation updates in this phase remain tied to wrapper behavior only, not compatibility matrix content.

### Claude's Discretion
- Exact script decomposition (single file vs helper split under `scripts/verify/`).
- Exact output formatting style (line shape, color/no-color, summary layout) while preserving required semantics.
- Internal helper naming and shell structure as long as user-facing contracts above stay fixed.

</decisions>

<specifics>
## Specific Ideas

- Keep wrapper output concise and operator-readable for routine terminal use.
- Keep checks aligned with existing verification commands and contracts already documented in `README.md` and `.planning/phases/01-installation-baseline/01-VERIFICATION-CHECKLIST.md`.

</specifics>

<deferred>
## Deferred Ideas

- `AUTO-04` quick-mode execution is deferred to a future phase.
- `AUTO-05` machine-readable output mode is deferred to a future phase.
- Compatibility matrix generation/details (`COMP-01`, `COMP-02`) are deferred to Phase 6.
- CI-provider-specific integration scaffolding remains out of scope for Phase 5.

</deferred>

---

*Phase: 05-validation-wrapper-baseline*
*Context gathered: 2026-02-25*
