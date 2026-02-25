# Phase 3: Tmux/Vim Workflow Stability - Context

**Gathered:** 2026-02-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 3 stabilizes existing tmux and Vim workflows so keybindings, startup behavior, logging paths, and editor fallback behavior remain dependable across normal usage. Scope is reliability hardening and validation of current workflow contracts only; no net-new tmux/vim feature capabilities are added in this phase.

</domain>

<decisions>
## Implementation Decisions

### Tmux optional dependency behavior
- Use fail-soft behavior for optional tmux tools (for example `asciinema` and `fzf`).
- Workflows should remain usable with actionable fallback messages or degraded-but-functional behavior.
- Avoid hard failures that break core tmux interaction when optional binaries are absent.

### Tmux keybinding compatibility
- Preserve existing tmux keybindings exactly, including current operational shortcuts.
- Preserve aliasr integrations on `Prefix + U` and `Prefix + K` unchanged.
- Reliability improvements must not redesign the current keybinding layout in this phase.

### Tmux logging path contract
- Keep `~/Logs` as the stable output contract for recording and history exports.
- Reliability work may improve guard behavior (for example path existence checks) but must not change the canonical logging location.

### Vim startup stability policy
- Use graceful fallback behavior when plugin/theme dependencies are missing.
- Vim must still start cleanly without startup breakage under degraded plugin availability.
- Maintain current editor workflow and mapping surface where possible while hardening startup behavior.

### Vim theme fallback policy
- Keep the existing theme fallback priority chain:
  1. `catppuccin`
  2. `dracula`
  3. `molokai`
- Reliability changes should reinforce this chain rather than replacing it with a new theme strategy.

### Verification depth policy
- Require targeted smoke checks for Phase 3 acceptance.
- Do not reduce verification to syntax-only checks.
- Do not require heavy manual-only verification as the default acceptance gate.

### Scope guardrails
- No keybinding redesign in this phase.
- No plugin-manager migration in this phase.
- No net-new tmux/vim feature families in this phase (capture as deferred ideas only).

### Claude's Discretion
- Exact smoke-check command sequence and ordering for tmux and Vim validation.
- Exact wording of fallback/error messaging as long as fail-soft behavior is preserved.
- Internal refactor structure to improve reliability without altering locked external contracts.

</decisions>

<specifics>
## Specific Ideas

- Treat tmux and Vim reliability as “safe to reload/start repeatedly” with predictable behavior.
- Prioritize preserving operator muscle memory by keeping keybinding and command-entry contracts stable.
- Keep reliability validation focused and fast through targeted smoke checks tied to the locked contracts.

</specifics>

<deferred>
## Deferred Ideas

- Keybinding redesign or larger shortcut ergonomics overhaul (future phase).
- Plugin manager migration/framework changes for Vim (future phase).
- Broader tmux/vim UX redesign and new workflow feature families (future phase).

</deferred>

---

*Phase: 03-tmux-vim-workflow-stability*
*Context gathered: 2026-02-25*
