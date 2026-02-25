# Phase 8: Compatibility Matrix Evidence Automation - Research

**Researched:** 2026-02-25
**Domain:** Deterministic matrix row updates from observed verification evidence
**Confidence:** HIGH

## User Constraints

### Locked Decisions (from 08-CONTEXT.md)
- Phase scope is limited to `COMP-03` evidence automation only.
- Canonical compatibility artifact remains `.planning/compatibility/v1.1-matrix.md`.
- Evidence source-of-truth is observed output from `./scripts/verify-suite.sh --json`.
- No inferred platform claims; only observed evidence may set `PASS`/`FAIL`/`SKIP`.
- Row identity key is `Environment Profile` + `Check Scope`.
- Existing key updates in place; new key inserts a new row.
- Required row fields are fixed:
  - `Environment Profile`
  - `Check Scope`
  - `Status`
  - `Caveat`
  - `Command Set Reference`
  - `Last Validated`
- Status vocabulary is restricted to `PASS` / `SKIP` / `FAIL`.
- Invalid evidence and schema mismatch must fail fast with actionable output.
- README and AGENTS must explain automated evidence flow and interpretation.

### Requirement Mapping

| Requirement | Phase 8 Interpretation | Planning Impact |
|-------------|------------------------|-----------------|
| `COMP-03` | Maintainer can generate/update matrix rows from observed wrapper evidence with schema and provenance guarantees | Plan must implement deterministic update flow, schema guards, status validation, and docs linkage without runtime feature expansion |

### Deferred / Out of Scope
- `AUTO-06` schema versioning contracts.
- CI-provider integration and matrix publication pipelines.
- Deep environment permutation expansion (`COMP-04+`).
- Net-new shell/tmux/vim runtime feature families.

## Current Repository Ground Truth

### Evidence Producer Contract
- `scripts/verify-suite.sh` already supports `--json` and emits deterministic payload shape:
  - `mode`
  - `format`
  - `checks[]` (`status`, `id`, `kind`, `message`)
  - `summary` (`pass`, `fail`, `skip`, `required_fail`)
- Wrapper enforces repo-root invocation and non-zero exit on required failure.

### Matrix Contract Already Published
- `.planning/compatibility/v1.1-matrix.md` exists and already defines:
  - status semantics (`PASS` / `FAIL` / `SKIP`)
  - required column schema
  - evidence note expectations and freshness policy
- Current matrix rows are manually maintained and include caveat tags and date fields.

### Documentation Baseline
- README includes compatibility matrix location and interpretation guidance.
- AGENTS includes maintainer contract for evidence-only matrix updates.

### Gaps for Phase 8
- No automated command exists to ingest wrapper JSON and update matrix rows.
- No deterministic key-based update mechanism is implemented yet.
- No explicit malformed-evidence rejection workflow is implemented.
- No automated schema-structure guard for matrix mutation path.

## Recommended Implementation Strategy

### Automation Entry Contract
Add a dedicated script entrypoint for matrix updates, for example:
- `scripts/update-compat-matrix.sh --evidence <json-file> --env-profile "..." --check-scope "..." --caveat "..." --command-ref "..." --date YYYY-MM-DD`

Implementation should remain non-interactive and fail fast on missing/invalid arguments.

### Parser and Update Engine
Use a Python helper for deterministic parsing and table rewriting (safer than shell-only text mutation):
- Parse evidence JSON and validate required structure.
- Derive status with evidence-only rules:
  - `FAIL` if required failures observed.
  - `PASS` if no required failures and evidence is present.
  - `SKIP` only when explicit unobserved/unsupported context is declared by caller.
- Enforce allowed vocabulary and required row fields.
- Load matrix table and update row by exact key match (`Environment Profile` + `Check Scope`).
- Preserve row order except deterministic append for new keys.

### Schema and Provenance Guards
Enforce these checks before write:
- Matrix table header includes all required columns.
- Existing row statuses are valid vocabulary.
- Incoming row has non-empty caveat, command reference, and date.
- Date matches `YYYY-MM-DD`.

On violation: return non-zero with clear actionable message and no write.

### Determinism Rules
- Same matrix input + same evidence input + same CLI args => byte-stable updated table row content.
- Update-in-place must not duplicate key rows.
- New-key insert location must be deterministic (append at table end).

## Verification Strategy (Phase 8)

Plans should include targeted smoke checks for:
1. Existing-row deterministic update (same key, changed status/caveat/date).
2. New-row insertion (new environment/scope key).
3. Schema/status vocabulary enforcement (`PASS`/`SKIP`/`FAIL` only).
4. Malformed evidence rejection (bad JSON or missing expected fields).
5. Missing matrix schema rejection (missing header column should fail).
6. Docs linkage checks for README and AGENTS references to automated flow.

Recommended verify command primitives:

```bash
bash -n scripts/update-compat-matrix.sh
python3 scripts/update_compat_matrix.py --help
python3 scripts/update_compat_matrix.py --matrix .planning/compatibility/v1.1-matrix.md --evidence /tmp/evidence.json --env-profile "macOS (Darwin arm64, current host)" --check-scope "install/shell/tmux/vim/docs parity" --caveat "host-specific observed run" --command-ref "./scripts/verify-suite.sh --json" --date 2026-02-25
rg -n "PASS|SKIP|FAIL" .planning/compatibility/v1.1-matrix.md
rg -n "Environment Profile|Check Scope|Status|Caveat|Command Set Reference|Last Validated" .planning/compatibility/v1.1-matrix.md
```

## Planning Decomposition Recommendation

### Plan 08-01 (Wave 1)
- Implement evidence ingestion + deterministic matrix update engine.
- Implement schema/status validation and fail-fast behavior.
- Add focused test fixtures for existing-row update and new-row insertion paths.
- Requirement focus: `COMP-03`.

### Plan 08-02 (Wave 2, depends on 08-01)
- Integrate docs linkage updates for automated usage and interpretation.
- Add targeted verification workflow doc for malformed evidence and schema rejection checks.
- Ensure no scope creep into CI/pipeline/schema-versioning work.
- Requirement focus: `COMP-03` continuation (docs and operational contract closure).

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Markdown table rewrite corruption | Matrix unreadable | Parse and validate header/schema before write; fail fast on mismatch |
| Inferred status leakage | Trust model violation | Require observed evidence file and disallow status inference without evidence |
| Duplicate key rows | Conflicting matrix claims | Enforce strict key match update-in-place logic |
| Scope creep into CI/publishing | Milestone slip | Keep plans constrained to local automation + docs linkage only |

## Suggested Checker Gates
- `08-RESEARCH.md`, `08-01-PLAN.md`, `08-02-PLAN.md` exist and are non-empty.
- Plan frontmatter contains required fields and includes `COMP-03` mapping.
- Wave/dependency lock is preserved: `08-01` wave 1, `08-02` wave 2 depends on `08-01`.
- Plan verify blocks include deterministic update, insert, schema enforcement, and malformed evidence rejection.
- No plan content introduces `AUTO-06`, CI integration, or runtime feature-family expansion.

## Sources
- `.planning/phases/08-compatibility-matrix-evidence-automation/08-CONTEXT.md`
- `.planning/ROADMAP.md`
- `.planning/REQUIREMENTS.md`
- `scripts/verify-suite.sh`
- `.planning/compatibility/v1.1-matrix.md`
- `README.md`
- `AGENTS.md`
- `.planning/phases/05-validation-wrapper-baseline/05-VERIFICATION.md`
- `.planning/phases/07-verification-wrapper-modes-and-output-contracts/07-VERIFICATION.md`

---
*Research completed: 2026-02-25*
*Ready for planning: yes*
