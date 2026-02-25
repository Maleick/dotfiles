# Phase 03 Research: Tmux/Vim Workflow Stability

**Phase:** 03 - tmux-vim-workflow-stability
**Date:** 2026-02-25
**Confidence:** HIGH

<objective>
Research how to implement Phase 3 so tmux and Vim workflows remain stable without changing keybinding contracts or adding new feature families.
</objective>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| TVIM-01 | `tmux` navigation, logging, and `aliasr` keybindings (`Prefix + U`, `Prefix + K`) work as documented. | Preserve existing bindings and logging path while adding fail-soft behavior for optional tools (`asciinema`, `fzf`). |
| TVIM-02 | `vim` plugin bootstrap, theme fallback, and key mappings load without startup breakage. | Add startup guards for missing plugin manager/dependencies and preserve theme chain `catppuccin -> dracula -> molokai`. |
</phase_requirements>

<findings>
## Key Findings

### Tmux baseline in `tmux/.tmux.conf`
- `Prefix + U` and `Prefix + K` bindings are already present and must remain unchanged.
- Logging and recording target `~/Logs`, but `bind S` does not create the directory before save-buffer.
- `bind s` already has a fail-soft pattern (`fzf` fallback to `choose-tree`), which is the right model.
- `bind P` directly executes `asciinema`; when unavailable it fails with a shell error rather than an actionable tmux message.

### Vim baseline in `vim/.vimrc`
- Theme fallback chain is already implemented with `silent!` in the required order:
  1. `catppuccin_mocha`
  2. `dracula`
  3. `molokai`
- `call plug#begin()` and `call plug#end()` are unguarded; if `vim-plug` is missing, startup errors can occur.
- COC function calls are partially unguarded (`CocAction`/`CocActionAsync` usage), which can produce runtime errors when plugins are unavailable.
- Plugin-specific mappings should degrade gracefully when plugins are not installed.

### Recommended implementation direction
- Apply a narrow reliability hardening pass:
  - Tmux: keep existing bindings and behavior shape, add command-availability guards and explicit fallback messages.
  - Vim: guard plugin bootstrap and plugin-dependent function calls while preserving mappings and theme chain.
- Do not redesign keybindings, plugin manager, or workflow architecture.

### Validation strategy for this phase
- Tmux smoke checks:
  - Parse/load config in isolated tmux server.
  - Verify required bindings still exist (`U`, `K`, `P`, `S`, `s`).
  - Verify `~/Logs` contract still appears in config.
- Vim smoke checks:
  - Headless startup with default home and with an empty temp home.
  - Verify fallback theme chain lines remain intact in file.
  - Verify plugin bootstrap guard exists so startup is non-fatal when plugin manager is absent.
</findings>

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Optional tmux dependencies must be fail-soft with actionable messages.
- Keep tmux keybindings unchanged, including `Prefix + U` and `Prefix + K`.
- Keep `~/Logs` as tmux recording/history output contract.
- Vim startup must degrade gracefully when dependencies are missing.
- Theme fallback priority must remain `catppuccin -> dracula -> molokai`.
- Verification must use targeted smoke checks (not syntax-only).

### Claude's Discretion
- Exact tmux fallback message text and guard implementation details.
- Exact Vim guard structure for plugin-dependent functions/mappings.
- Exact smoke-check command order, as long as contract coverage remains complete.

### Deferred Ideas (OUT OF SCOPE)
- Keybinding redesign.
- Vim plugin-manager migration.
- New tmux/Vim feature families beyond reliability hardening.
</user_constraints>

<confidence>
## Confidence Assessment

| Area | Level | Reason |
|------|-------|--------|
| Tmux contract preservation | HIGH | Existing keybindings and path contracts are explicit and easy to validate with command checks. |
| Optional dependency fail-soft behavior | HIGH | `if-shell` guards fit current tmux style and avoid workflow breakage. |
| Vim startup hardening | HIGH | Missing dependency failure points are clear (`plug#begin`, CocAction calls) and can be guarded safely. |
</confidence>

## Open Questions
- None blocking for planning; phase decisions are locked in context.

---
*Research complete: 2026-02-25*
