# Phase 7: Verification Wrapper Modes and Output Contracts - Research

**Researched:** 2026-02-25
**Domain:** Wrapper mode expansion and deterministic dual-output contracts
**Confidence:** HIGH

## User Constraints

### Locked Decisions (from 07-CONTEXT.md)
- Entrypoint remains `./scripts/verify-suite.sh`; no replacement command.
- Default (no-flag) behavior must remain equivalent to existing full human-readable run.
- Add quick mode via `--quick` with a locked minimum required-check subset.
- Add machine-readable output via `--json` while preserving status semantics (`PASS`/`FAIL`/`SKIP`).
- Combined invocation `--quick --json` must be supported.
- Exit status remains non-zero for any required-check failure in every mode.
- Optional dependency checks (`asciinema`, `fzf`) stay fail-soft with actionable guidance.
- Verification must include targeted smoke checks (default, quick, json, combined, forced-failure).

### Requirement Mapping

| Requirement | Phase 7 Interpretation | Planning Impact |
|-------------|------------------------|-----------------|
| `AUTO-04` | Quick-mode execution path with faster runtime and preserved reliability signal | Plan must define quick subset contract, explicit skipped checks, and equivalence guardrails for default behavior |
| `AUTO-05` | Machine-readable deterministic reporting with per-check + summary semantics | Plan must define stable JSON schema, combined-mode behavior, and parser-safe smoke checks |

### Deferred / Out of Scope
- `COMP-03` compatibility matrix row generation automation (Phase 8).
- `AUTO-06` formal schema-versioning contract.
- CI-provider integration and matrix publication pipelines.

## Current Repository Ground Truth

### Existing Wrapper Behavior
- `scripts/verify-suite.sh` currently runs a fixed full check list and prints deterministic text lines (`PASS|FAIL|SKIP | check_id | message`) plus `SUMMARY` counts.
- Required failure behavior is already testable through `VERIFY_SUITE_FORCE_FAIL_REQUIRED=1` for `req.install_syntax`.
- Optional dependencies (`asciinema`, `fzf`) already emit fail-soft `SKIP` guidance.

### Existing Documentation Contract
- `README.md` documents current baseline wrapper semantics and optional dependency behavior.
- `AGENTS.md` documents maintainer expectations for deterministic wrapper contract and fail-soft behavior.

### Gaps for Phase 7
- No quick mode (`--quick`) path exists.
- No machine-readable (`--json`) output exists.
- No combined-mode behavior exists.
- No docs coverage for new mode flags or parse contract expectations.

## Recommended Contract Design

### CLI Contract
- Flags:
  - `--quick`: quick subset selection.
  - `--json`: JSON output mode.
  - Combined usage allowed.
- Unknown flags should fail fast with usage text and non-zero exit.
- Default mode remains full + text output.

### Check Selection Model
Define checks as metadata records with stable fields:
- `id`
- `kind` (`required` / `optional`)
- `quick` (`true` if included in quick baseline)
- `description`
- `command/pattern metadata`

Use one execution core and mode-specific selection/filtering.

### Quick Mode Baseline (recommended)
Include these required checks in quick mode:
- `req.install_syntax`
- `req.zsh_syntax`
- `req.tmux_config`
- `req.vim_startup`

Full-only required checks to mark as quick exclusions (`SKIP` with explicit reason):
- `req.vim_temp_home`
- `req.readme_verify_section`
- `req.agents_tmux_contract`

Optional checks (`opt.asciinema`, `opt.fzf`) may remain in quick mode as lightweight probes; if omitted they should be surfaced as `SKIP` for clarity.

### JSON Schema Strategy
Recommended top-level shape:

```json
{
  "mode": "full|quick",
  "format": "json",
  "checks": [
    {
      "status": "PASS|FAIL|SKIP",
      "id": "req.install_syntax",
      "kind": "required|optional",
      "message": "..."
    }
  ],
  "summary": {
    "pass": 0,
    "fail": 0,
    "skip": 0,
    "required_fail": false
  }
}
```

Determinism rules:
- Stable check order equals execution order.
- Stable key set per record.
- Summary counts match emitted check statuses exactly.

### Combined Mode Behavior
`--quick --json` should:
- Use quick selection semantics.
- Emit JSON with `mode: quick`.
- Preserve required failure exit semantics.

## Verification Strategy (Phase 7)

Plans should include executable smoke commands for:
1. Default mode still works and prints text summary.
2. Quick mode runs and shows explicit skip behavior for excluded checks.
3. JSON mode outputs valid parseable JSON and expected status vocabulary.
4. Combined mode outputs valid parseable JSON with `mode=quick` semantics.
5. Forced required failure returns non-zero in both text and json modes.

Recommended verify command primitives:

```bash
./scripts/verify-suite.sh
./scripts/verify-suite.sh --quick
./scripts/verify-suite.sh --json | python3 -m json.tool >/dev/null
./scripts/verify-suite.sh --quick --json | python3 -m json.tool >/dev/null
VERIFY_SUITE_FORCE_FAIL_REQUIRED=1 ./scripts/verify-suite.sh >/dev/null 2>&1; test $? -ne 0
VERIFY_SUITE_FORCE_FAIL_REQUIRED=1 ./scripts/verify-suite.sh --json >/dev/null 2>&1; test $? -ne 0
```

## Planning Decomposition Recommendation

### Plan 07-01 (Wave 1)
- Implement argument parsing and mode selection framework.
- Implement quick-mode check selection and explicit exclusion/SKIP messaging.
- Preserve default output/exit compatibility.
- Requirement focus: `AUTO-04`.

### Plan 07-02 (Wave 2, depends on 07-01)
- Implement JSON emission and combined-mode behavior.
- Add docs coverage for mode flags and compatibility expectations.
- Add deterministic smoke-check commands for all mode/failure paths.
- Requirement focus: `AUTO-05`.

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Quick subset hides meaningful regressions | False confidence | Keep explicit locked required subset and emit skips for excluded checks |
| Text and JSON outputs diverge | Contract drift | Generate both outputs from one shared result model |
| JSON escaping/format bugs | Parsing failures | Use strict shell escaping and validate with `python3 -m json.tool` |
| Scope creep into matrix generation | Phase spillover | Explicitly block `COMP-03` work in plan files/checker gates |

## Suggested Checker Gates
- Both plans exist and are non-empty.
- Frontmatter includes required keys (`wave`, `depends_on`, `files_modified`, `autonomous`, `requirements`, `must_haves`).
- `AUTO-04` and `AUTO-05` appear in plan requirement mappings.
- Verify sections include commands for default/quick/json/combined/forced-failure paths.
- No plan mentions `COMP-03` implementation work.

## Sources
- `.planning/phases/07-verification-wrapper-modes-and-output-contracts/07-CONTEXT.md`
- `.planning/ROADMAP.md`
- `.planning/REQUIREMENTS.md`
- `scripts/verify-suite.sh`
- `README.md`
- `AGENTS.md`
- `.planning/phases/05-validation-wrapper-baseline/05-VERIFICATION.md`

---
*Research completed: 2026-02-25*
*Ready for planning: yes*
