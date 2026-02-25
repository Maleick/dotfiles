# Phase 7: Verification Wrapper Modes and Output Contracts - Context

**Gathered:** 2026-02-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 7 covers wrapper mode and output-contract expansion for `./scripts/verify-suite.sh` under requirements `AUTO-04` and `AUTO-05`.

In scope:
- Quick execution mode behavior (`--quick`)
- Machine-readable output behavior (`--json`)
- Combined-mode behavior (`--quick --json`)
- Preservation of existing deterministic status/exit contracts across all supported modes

Out of scope for this phase:
- Compatibility matrix row generation automation (`COMP-03`, Phase 8)
- CI-provider integrations and pipeline scaffolding
- Net-new runtime feature families in shell/tmux/vim configs

</domain>

<decisions>
## Implementation Decisions

### Wrapper Entry and Backward Compatibility
- Entrypoint remains `./scripts/verify-suite.sh`.
- No-flag default invocation must stay behaviorally equivalent to the current full human-readable run.
- Existing per-check status model (`PASS`/`FAIL`/`SKIP`) and deterministic summary contract are preserved.

### Quick Mode Contract (`AUTO-04`)
- `--quick` is the quick-mode contract.
- Quick mode runs a fixed, locked minimum required-check subset (defined in implementation/planning, then treated as contract).
- Checks excluded from quick mode that exist in full mode should be surfaced explicitly as `SKIP` where applicable so operators can see scope differences.
- Quick mode remains non-interactive and repo-root constrained.

### Machine-Readable Contract (`AUTO-05`)
- `--json` is the machine-readable output contract.
- JSON output includes deterministic per-check records and deterministic summary counts for `PASS`/`FAIL`/`SKIP`.
- JSON mode must remain parse-stable within this milestone (no ad hoc field drift during Phase 7).
- Human-readable default behavior is preserved when `--json` is not specified.

### Combined Mode Behavior
- `--quick --json` is supported.
- Combined mode uses quick-mode check selection and JSON reporting while preserving the same required-check failure semantics.

### Exit and Failure Semantics
- Exit semantics remain unchanged across modes: non-zero when any required check fails.
- Failure-path behavior must stay deterministic and directly tied to required-check outcomes.

### Optional Dependency Policy
- Optional dependencies (`asciinema`, `fzf`) remain fail-soft with actionable guidance.
- No auto-install or auto-remediation behavior is introduced.

### Documentation and Operator Contract
- `README.md` must document new mode flags and mode semantics (`default`, `--quick`, `--json`, `--quick --json`).
- `AGENTS.md` must document maintainer contract expectations for mode compatibility and deterministic output/exit behavior.
- Docs changes must emphasize backward compatibility of default wrapper usage.

### Verification Depth Requirement
- Phase verification must include targeted smoke checks for:
  - default mode
  - quick mode
  - json mode
  - combined quick+json mode
  - required-check failure path
- Syntax-only verification is insufficient.

### Claude's Discretion
- Exact quick-mode required-check subset composition after preserving milestone guarantees.
- Exact JSON object structure naming (field names/order) so long as determinism and status/summary requirements are satisfied.
- Exact CLI help/usage text style for mode documentation.

</decisions>

<specifics>
## Specific Ideas

- Keep mode logic and reporting anchored to existing wrapper behavior in `scripts/verify-suite.sh`.
- Ensure docs synchronization in both `README.md` and `AGENTS.md` during Phase 7, not as a later cleanup task.
- Reuse prior baseline evidence expectations from `.planning/phases/05-validation-wrapper-baseline/05-VERIFICATION.md` when defining mode-specific smoke checks.
- Preserve existing operator-readable output as the default mode while adding machine-consumable output as an explicit opt-in.

</specifics>

<deferred>
## Deferred Ideas

- `COMP-03` compatibility matrix row generation automation (Phase 8 scope).
- `AUTO-06` output schema versioning / long-term compatibility guarantees.
- CI-provider integration and matrix auto-publication pipeline work.

</deferred>

---
*Phase: 07-verification-wrapper-modes-and-output-contracts*
*Context gathered: 2026-02-25*
