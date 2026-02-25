# Phase 2: Shell Reliability Hardening - Context

**Gathered:** 2026-02-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 2 hardens shell startup and helper-command reliability for the existing red-team zsh environment. Scope is limited to preserving and stabilizing current shell behavior across hosts/edits (OPSEC settings, Warp behavior, aliasr integration, helper command resilience). New feature capabilities outside shell reliability are out of scope.

</domain>

<decisions>
## Implementation Decisions

### Startup stability and prompt behavior
- Shell startup must remain deterministic and non-fatal even when optional plugins/tools are absent.
- Preserve OPSEC history behavior (`hist_ignore_space`, dedupe settings, immediate append) as a locked invariant.
- Preserve Warp-aware behavior and prompt branching semantics; Warp and non-Warp sessions must both remain usable and predictable.
- Keep startup guidance visible (`Type /help for a list of commands.`) and maintain `/help` as the operator entrypoint.

### Environment ordering and loader safety
- Keep environment path precedence stable: Homebrew first, then Python 3.13, then OpenJDK 17, then pdtm/Go paths, then pipx local bin.
- Optional loaders (`zsh-syntax-highlighting`, autosuggestions, local overrides, external env loaders) must remain guarded with existence checks and safe fallbacks.
- Reliability hardening may simplify duplicated path logic, but not reorder critical precedence contracts.

### Helper command reliability and compatibility
- Existing command names and function entrypoints are compatibility contracts; hardening should improve behavior without silent removals.
- Network/helper commands should have explicit fallback paths where practical (service fallback, OS-command fallback) and fail with actionable messages when not recoverable.
- Cross-platform shell compatibility (macOS/Linux differences) should be handled with guarded command branches rather than assumptions.

### aliasr and red-team workflow continuity
- Preserve `alias a='aliasr'` exactly as the short launcher contract.
- Maintain behavior compatibility with tmux aliasr keybindings (`Prefix + U` and `Prefix + K`) and `/help` command descriptions.
- Any helper cleanup must keep red-team core workflows (`quickscan`, `rev-shell`, `netinfo`, `webserver`, encoding helpers) operational or provide explicit fallback behavior.

### Claude's Discretion
- Exact fallback ordering among equivalent provider commands (for example IP detection endpoints).
- Internal function refactoring style, so long as command names/behavior contracts remain stable.
- Prompt cosmetics that do not alter the locked Warp/non-Warp behavior requirements.

</decisions>

<specifics>
## Specific Ideas

- Treat shell reliability as "safe to source repeatedly" for local iteration.
- Prefer explicit guards and clear usage/error output over implicit shell magic.
- Keep terminal-first ergonomics: fast startup, predictable aliases/functions, low-noise output.

</specifics>

<deferred>
## Deferred Ideas

- Adding net-new red-team helper capability beyond reliability hardening (new tooling families) — future phase/backlog.
- Large prompt/theme redesigns unrelated to stability — separate UX phase.
- Plugin manager migration or major shell framework adoption — separate architecture phase.

</deferred>

---

*Phase: 02-shell-reliability-hardening*
*Context gathered: 2026-02-25*
