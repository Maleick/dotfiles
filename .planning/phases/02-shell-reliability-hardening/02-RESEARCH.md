# Phase 02 Research: Shell Reliability Hardening

**Phase:** 02 - shell-reliability-hardening
**Date:** 2026-02-25
**Confidence:** HIGH

<objective>
Research how to implement Phase 2 (Shell Reliability Hardening) so plans preserve locked shell contracts while improving startup and helper reliability.
</objective>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| SHLL-01 | `zsh/.zshrc` preserves OPSEC history settings and command behavior across reloads. | Preserve `hist_ignore_space`, dedupe/history controls, and startup safety while refactoring helper logic. |
| SHLL-02 | Warp-aware prompt/runtime behavior remains functional. | Add explicit Warp detection guard and keep prompt behavior stable in both Warp and non-Warp terminals. |
| SHLL-03 | `aliasr` integration (`alias a='aliasr'`) remains available and documented. | Preserve alias contract and keep `/help` + docs aligned with aliasr usage expectations. |
| SHLL-04 | Core helper commands have platform-safe behavior or explicit guarded fallback paths. | Add cross-platform guards for command flags/tool availability and deterministic helper fallbacks. |
</phase_requirements>

<findings>
## Key Findings

### Current shell baseline in `zsh/.zshrc`
- OPSEC-critical history settings are already configured (`hist_ignore_space`, `hist_ignore_dups`, `inc_append_history`) and should remain locked.
- `alias a='aliasr'` is present and `/help` documents aliasr/tmux shortcuts.
- Environment order is currently Homebrew -> Python 3.13 -> later OpenJDK 17 -> pdtm/Go -> local bin; this order should be preserved explicitly.

### Reliability gaps observed
- Warp-specific variable/branching contract described in `AGENTS.md` is not explicitly represented as `WARP_TERMINAL` state in the current shell file.
- Some helper aliases rely on platform-specific flags/commands without fallback guards:
  - `base64decode` uses `base64 -D` (macOS form) with no Linux fallback.
  - `alias ip='ip --color=auto'` assumes GNU/Linux-style `ip` command availability.
  - `alias diff='diff --color=auto'` may not work on BSD `diff`.
- Helper behavior and docs can drift unless command behavior checks and docs sync are treated as one phase outcome.

### Recommended implementation direction
- Keep current shell architecture, but add explicit guard helpers and fallback pathways instead of broad rewrites.
- Introduce Warp detection as a simple compatibility branch (`TERM_PROGRAM=WarpTerminal`) that preserves existing prompt behavior expectations.
- Implement compatibility wrappers for helpers where command syntax differs across hosts (especially base64 decode and optional colorized aliases).
- Keep red-team operator UX unchanged (`/help`, alias names, core helper names), while making behavior safer under missing tools.

### Validation strategy for this phase
- Syntax/reload safety: `zsh -n zsh/.zshrc` and isolated startup checks using `ZDOTDIR`.
- Contract checks: ensure `alias a='aliasr'` exists, OPSEC settings remain present, Warp branch exports expected state.
- Helper checks: run representative commands for IP/base64/network helpers with guarded command paths.
- Documentation sync: verify README and AGENTS shell guidance reflects final runtime behavior.

</findings>

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Preserve OPSEC history behavior and startup guidance as non-negotiable shell contracts.
- Preserve Warp-aware behavior and keep both Warp and non-Warp sessions reliable.
- Preserve `alias a='aliasr'` and compatibility with documented aliasr workflow.
- Add guarded fallback behavior for helper commands instead of removing existing operator entrypoints.

### Claude's Discretion
- Exact fallback ordering among equivalent helper providers.
- Internal refactor style for helper wrappers and guard functions.
- Prompt cosmetic tuning that does not alter locked behavior contracts.

### Deferred Ideas (OUT OF SCOPE)
- New red-team helper feature families (beyond reliability hardening).
- Prompt/theme redesign unrelated to reliability.
- Plugin-manager migration or major shell framework adoption.

</user_constraints>

<confidence>
## Confidence Assessment

| Area | Level | Reason |
|------|-------|--------|
| Shell contract preservation | HIGH | Current contracts are explicit in `AGENTS.md` + `zsh/.zshrc` and can be validated locally. |
| Cross-platform helper guard updates | HIGH | Gaps are concrete and can be addressed with guarded wrappers/alias conditionals. |
| Documentation synchronization | HIGH | Docs and shell source are local and directly traceable. |
</confidence>

## Open Questions
- None blocking for planning; exact helper fallback ordering remains implementation discretion.

---
*Research complete: 2026-02-25*
