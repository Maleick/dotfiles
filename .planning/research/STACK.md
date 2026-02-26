# Stack Research — v1.3 Automation Hardening

## Existing Baseline (Already Shipped)

- Shell automation: `bash` entrypoints in `scripts/`
- Structured processing: `python3` helpers (`scripts/update_compat_matrix.py`)
- Verification producer: `./scripts/verify-suite.sh --json`
- Canonical evidence target: `.planning/compatibility/v1.1-matrix.md`

## Scope-Specific Additions for v1.3

### AUTO-06 (JSON schema versioning)

Recommended stack approach:
- Keep output generation in existing `scripts/verify-suite.sh` pipeline.
- Add explicit schema contract fields inside JSON payload, for example:
  - `schema_version` (e.g., `1.0`)
  - `schema_name` (e.g., `verify-suite-result`)
- Add lightweight schema validation checks using existing `python3` runtime (no new dependency required).
- Add compatibility rules documented in `README.md`/`AGENTS.md` and verified in phase smoke checks.

### COMP-04 (coverage expansion)

Recommended stack approach:
- Reuse existing matrix updater tooling:
  - `./scripts/update-compat-matrix.sh`
  - `scripts/update_compat_matrix.py`
- Keep matrix format markdown table for maintainability and human review.
- Add profile normalization/coverage guard logic in Python helper where needed (no external parser dependency).

## Dependencies to Avoid

- Full JSON schema library addition unless current Python stdlib checks become insufficient.
- CI-provider-specific SDK dependencies (out of scope).
- Complex matrix auto-publication tooling (defer beyond this milestone).

## Integration Notes

- Preserve backward compatibility for current consumers of `--json` output by adding fields, not removing/renaming existing keys.
- Ensure schema version semantics are reflected in both runtime and docs contracts.
- Keep compatibility matrix row semantics evidence-backed (no inferred PASS/FAIL claims).

## Recommended Tooling Choice

Use **existing bash + python3 stack only** for v1.3:
- Lowest change-risk
- Already validated in v1.2
- Supports both schema versioning and coverage expansion without introducing new operational dependencies
