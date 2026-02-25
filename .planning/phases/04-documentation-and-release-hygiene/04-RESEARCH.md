# Phase 04 Research: Documentation and Release Hygiene

**Phase:** 04 - documentation-and-release-hygiene
**Date:** 2026-02-25
**Confidence:** HIGH

<objective>
Research how to implement Phase 4 so documentation and release metadata accurately reflect the shipped behavior of this dotfiles repository.
</objective>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| DOCS-01 | `README.md` and `AGENTS.md` match actual command/keybinding behavior. | Build docs-vs-runtime deltas from `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, and `install.sh`, then reconcile docs comprehensively. |
| DOCS-02 | `CHANGELOG.md` and `VERSION` stay consistent with delivered reliability changes. | Create a structured `2.1.1` entry, preserve history, add legacy context note, and ensure `VERSION` matches release header. |
</phase_requirements>

<findings>
## Key Findings

### Docs-vs-runtime delta matrix

| Surface | Current State | Delta to Address |
|---------|---------------|------------------|
| `README.md` | Documents shell reliability checks and core command surface. | Needs dedicated cross-surface checklist section covering install + shell + tmux + vim + docs/release integrity. |
| `README.md` | Contains static version badge `2.1.0`. | Must be updated when `VERSION` moves to `2.1.1` to avoid release metadata drift. |
| `AGENTS.md` | Captures most shell/tmux/vim architecture and constraints. | Should explicitly reflect tmux fail-soft recording/history guards and Vim plugin/bootstrap fail-soft behavior added in Phase 3. |
| `CHANGELOG.md` | Latest entry is `2.1.0`; historical entries include now-legacy tooling references. | Needs new `2.1.1` entry for delivered reliability/doc work and explicit legacy-context note without rewriting old history. |
| `VERSION` | `2.1.0`. | Must bump to `2.1.1` in sync with changelog release header. |

### Runtime truth anchors for reconciliation
- Shell behavior contract: `zsh/.zshrc` (`/help` surface, helper fallback behavior, Warp/OPSEC invariants).
- Tmux contract: `tmux/.tmux.conf` (`Prefix + P/S/U/K`, `~/Logs` path contract, fail-soft `asciinema` guard, `fzf` fallback on session switch).
- Vim contract: `vim/.vimrc` (guarded `vim-plug` bootstrap, guarded coc usage, theme fallback chain).
- Installer contract: `install.sh` (idempotent relinking and backup behavior expectations).

### Recommended implementation direction
- Reconcile docs from runtime truth outward (source files first, docs second) to avoid stale narrative drift.
- Keep release notes additive and historical; do not rewrite older versions.
- Explicitly separate:
  1. Runtime contracts (what exists now)
  2. Legacy historical context (what older entries refer to)

### Verification strategy
- Assertions for DOCS-01:
  - Every major runtime contract called out in docs maps to current source snippets/commands.
  - Added verification checklist has executable commands covering all required surfaces.
- Assertions for DOCS-02:
  - `VERSION` exactly matches latest changelog version.
  - Changelog includes structured `2.1.1` entry plus legacy-context note for older entries.
  - No old entries rewritten/pruned.
</findings>

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Comprehensive reconciliation for `README.md` + `AGENTS.md`.
- Dedicated verification checklist model in `README.md`.
- Patch release target `2.1.1`.
- Structured changelog entry with file/contract specificity.
- Preserve historical changelog entries and add legacy-context note for older broad tooling references.
- No net-new runtime features or scope expansion.

### Claude's Discretion
- Exact section placement and wording for the verification checklist.
- Exact bullet categorization and phrasing for `2.1.1` entry.
- Final sentence-level readability improvements while preserving factual accuracy.

### Deferred Ideas (OUT OF SCOPE)
- New feature families in shell/tmux/vim.
- CI/release automation restoration work.
</user_constraints>

<confidence>
## Confidence Assessment

| Area | Level | Reason |
|------|-------|--------|
| Runtime-to-doc reconciliation | HIGH | Source-of-truth files and docs are local and directly comparable. |
| Release metadata consistency | HIGH | Single `VERSION` file and changelog header provide deterministic checks. |
| Legacy context preservation policy | HIGH | Can be handled by additive notes without historical rewrites. |
</confidence>

## Open Questions
- None blocking. Context already locks scope and decision tradeoffs.

---
*Research complete: 2026-02-25*
