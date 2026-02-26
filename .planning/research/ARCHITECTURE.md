# Architecture Research — v1.3 Automation Hardening

## Existing Architecture Anchors

- `scripts/verify-suite.sh` emits deterministic text and JSON verification output.
- `scripts/update-compat-matrix.sh` and `scripts/update_compat_matrix.py` perform deterministic matrix updates.
- `.planning/compatibility/v1.1-matrix.md` is canonical compatibility artifact.
- `README.md` and `AGENTS.md` provide operator/maintainer contract language.

## Integration Plan for AUTO-06

### Components Affected

- `scripts/verify-suite.sh`
- `README.md`
- `AGENTS.md`
- Phase verification artifacts for schema compatibility checks

### Expected Contract Changes

- Extend JSON payload with schema metadata keys while preserving existing structure:
  - current: `mode`, `format`, `checks`, `summary`
  - add: schema metadata fields (version + name)
- Maintain deterministic ordering and stable status semantics.

### Validation Path

- Parse JSON via `python3 -m json.tool` + targeted key assertions.
- Verify non-zero required-failure behavior remains unchanged after schema metadata addition.

## Integration Plan for COMP-04

### Components Affected

- `.planning/compatibility/v1.1-matrix.md`
- `scripts/update_compat_matrix.py` (optional normalization hardening)
- `README.md` / `AGENTS.md`

### Expected Contract Changes

- Introduce additional environment profile rows (Linux distro/terminal permutations).
- Keep row key identity deterministic (`Environment Profile` + `Check Scope`).
- Preserve schema-required fields and explicit caveats.

### Validation Path

- Deterministic update and insert checks across expanded profile set.
- Rejection checks for malformed evidence and schema mismatch remain required.

## Suggested Build Order

1. AUTO-06 schema versioning contract in wrapper JSON.
2. AUTO-06 docs + verification contract updates.
3. COMP-04 coverage profile expansion + matrix updates.
4. COMP-04 docs and verification evidence updates.

This ordering reduces parser ambiguity before adding wider evidence coverage.
