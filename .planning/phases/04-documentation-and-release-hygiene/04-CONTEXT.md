# Phase 4: Documentation and Release Hygiene - Context

**Gathered:** 2026-02-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 4 aligns public documentation and release metadata with the behavior that is already shipped in this repository. Scope is accuracy and operator trust for docs and versioning only: reconcile `README.md` and `AGENTS.md` with runtime behavior, and reconcile `CHANGELOG.md` plus `VERSION` with delivered reliability work.

</domain>

<decisions>
## Implementation Decisions

### Documentation reconciliation model
- Use comprehensive reconciliation of `README.md` and `AGENTS.md` against actual behavior in `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, and `install.sh`.
- Treat docs as operator-safe runbooks, not marketing-only summaries.
- Prefer concrete command/keybinding examples over abstract statements when behavior contracts exist.

### Verification documentation model
- Add or maintain a dedicated verification checklist section in `README.md`.
- Checklist must cover install, shell, tmux, vim, and docs/release integrity checks.
- Verification guidance should use copy/paste-ready commands where practical.

### Release/version policy
- Plan for patch bump from `2.1.0` to `2.1.1` for this phase.
- Treat this as non-breaking reliability/documentation alignment (no feature-family expansion).

### Changelog entry style
- Add a structured `2.1.1` changelog entry using categorized bullets.
- Include file-level and contract-level specifics to improve traceability (for example, docs/runtime sync points and release metadata updates).

### Changelog history policy
- Preserve older changelog entries as historical records.
- Do not rewrite or prune historical releases.
- Add explicit legacy context for older entries that reference broader legacy tooling/CI structures not present in the current slimmed repository.

### Scope guardrails
- No net-new runtime features in Phase 4.
- No keybinding redesign.
- No plugin-manager migration.
- Changes are limited to documentation and release metadata accuracy.

### Claude's Discretion
- Exact structure/placement of the dedicated verification checklist in `README.md`.
- Exact wording and grouping of `2.1.1` changelog categories while preserving required release facts.
- Exact sentence-level refinements to improve readability, as long as behavior claims remain source-grounded in current files.

</decisions>

<specifics>
## Specific Ideas

- Reconcile operator-facing docs directly against canonical behavior sources:
  - `README.md` <-> `zsh/.zshrc` command behavior and `/help` command surface.
  - `AGENTS.md` <-> `tmux/.tmux.conf` keybinding contracts (`Prefix + P/S/U/K`, logging path behavior).
  - `AGENTS.md` and `README.md` <-> `vim/.vimrc` startup/fallback contract notes.
- Ensure release docs stay coherent:
  - `CHANGELOG.md` includes new `2.1.1` release record tied to reliability/documentation alignment.
  - `VERSION` is updated consistently with changelog release header.
- Include docs-release integrity checks in the verification checklist:
  - Confirm version/changelog consistency.
  - Confirm doc claims map to current runtime files.

</specifics>

<deferred>
## Deferred Ideas

- New runtime capabilities (additional helper families, tmux feature expansions, Vim feature expansions) are deferred to future phases.
- Broad release-process automation (CI/release tooling restoration) is deferred unless explicitly scoped in a later phase.

</deferred>

---

*Phase: 04-documentation-and-release-hygiene*
*Context gathered: 2026-02-25*
