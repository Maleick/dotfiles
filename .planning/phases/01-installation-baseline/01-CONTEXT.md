# Phase 1: Installation Baseline - Context

**Gathered:** 2026-02-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 1 delivers installer safety, idempotency, and baseline verification for the existing dotfiles setup flow. Scope is limited to validating and hardening `install.sh` behavior plus defining and executing baseline checks. New feature capability work (shell/tmux/vim behavior changes beyond install baseline) is out of scope for this phase.

</domain>

<decisions>
## Implementation Decisions

### Backup behavior policy
- Every install run must create a timestamped backup before replacing existing target files (`~/.zshrc`, `~/.tmux.conf`, `~/.vimrc`).
- Backup behavior should be deterministic and visible in command output so operators can confirm what moved.
- If no prior target file exists, install should still proceed cleanly without backup error paths.

### Symlink correctness and idempotency
- `install.sh` is the authoritative publish path from repo source files into `$HOME`.
- Re-running install must refresh symlinks safely and leave runtime configs usable after each run.
- Existing non-symlink target files are treated as backup candidates rather than overwritten in-place.

### Baseline verification contract
- Phase output must include a repeatable local checklist for installer and runtime sanity checks.
- Checklist must cover: installer run/re-run, shell syntax/load check, tmux config load check, vim startup sanity.
- Verification expectations should be concrete enough for future releases to reuse without reinterpretation.

### Failure handling and operator feedback
- Installer failures should be fail-fast with clear, actionable output.
- Partial states should be minimized; operator should be able to rerun safely after correction.
- No silent mutation behavior for critical file operations.

### Claude's Discretion
- Exact wording/format of verification checklist output.
- Internal helper structure in `install.sh` so long as external install behavior remains stable.
- Level of verbosity for non-critical informational output.

</decisions>

<specifics>
## Specific Ideas

- Keep the workflow terminal-first and explicit; avoid adding hidden automation layers in this phase.
- Maintain source-of-truth discipline: repo files are edited, then published via installer.
- Prioritize “safe to rerun anytime” behavior as the phase acceptance lens.

</specifics>

<deferred>
## Deferred Ideas

- Optional lightweight automation wrapper to run full validation suite quickly (v2+ idea).
- Expanded cross-platform compatibility matrix beyond baseline checks (future phase work).
- Structured release checklist automation for version/changelog hygiene (future phase work).

</deferred>

---

*Phase: 01-installation-baseline*
*Context gathered: 2026-02-25*
