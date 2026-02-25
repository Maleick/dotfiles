# Phase 8: Compatibility Matrix Evidence Automation - Context

**Gathered:** 2026-02-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 8 implements compatibility matrix evidence automation for `COMP-03` only.

In scope:
- Deterministic evidence ingestion from observed wrapper output
- Deterministic row update/insert behavior for the canonical matrix artifact
- Schema and provenance enforcement for matrix rows
- Documentation linkage updates that explain automated evidence update semantics

Out of scope:
- New runtime feature families in shell/tmux/vim behavior
- CI-provider integration or publication pipelines
- Long-horizon schema versioning contracts (`AUTO-06`)

</domain>

<decisions>
## Implementation Decisions

### Boundary Contract
- Phase 8 delivers matrix evidence automation for `COMP-03` only.
- No net-new runtime feature families are introduced.

### Canonical Target
- Source-of-truth matrix artifact remains `.planning/compatibility/v1.1-matrix.md`.
- Automation flow must read and write this canonical file path.

### Evidence Ingestion Contract
- Primary evidence input is `./scripts/verify-suite.sh --json` observed output.
- Optional evidence supplements may include phase verification/checklist artifacts for provenance annotation.
- Inferred PASS/FAIL claims are prohibited; only observed evidence can update matrix status claims.

### Row Identity and Update Model
- Matrix row identity key is `Environment Profile` + `Check Scope`.
- If a row key already exists, update in place (do not duplicate rows).
- If a row key does not exist, insert a new row.
- Update behavior must be deterministic for repeated runs with the same evidence input.

### Schema Enforcement Contract
- Every row must include all required columns:
  - `Environment Profile`
  - `Check Scope`
  - `Status`
  - `Caveat`
  - `Command Set Reference`
  - `Last Validated`
- `Status` vocabulary is restricted to `PASS` / `SKIP` / `FAIL`.
- Automation must preserve schema consistency and reject unknown status values.

### Caveat and Provenance Model
- `SKIP` entries must include explicit reason text (for example unobserved environment context).
- `Command Set Reference` must point to actual executed evidence sources.
- `Last Validated` must be date-stamped from observed run context.

### Failure Behavior Contract
- Invalid or missing evidence input must fail fast with actionable error messaging.
- Matrix schema mismatch must fail fast; automation must not silently rewrite malformed structures.

### Docs Linkage Contract
- `README.md` and `AGENTS.md` remain aligned with automated evidence update flow and interpretation semantics.
- Docs should preserve matrix trust model: observed evidence only, caveat-aware interpretation.

### Verification Depth Contract
- Targeted smoke checks must cover:
  - deterministic update of existing keyed rows,
  - deterministic insertion of new keyed rows,
  - schema/status vocabulary validity,
  - rejection path for malformed evidence.
- Syntax-only verification is insufficient.

### Claude's Discretion
- Exact helper script decomposition and naming under `scripts/`.
- Exact normalization strategy for environment/check-scope key strings.
- Exact error text phrasing and docs wording style, while preserving locked contracts above.

</decisions>

<specifics>
## Specific Ideas

- Treat `scripts/verify-suite.sh --json` as the primary evidence payload producer for matrix updates.
- Keep `.planning/compatibility/v1.1-matrix.md` as the canonical matrix output file and enforce existing row schema.
- Ensure `README.md` and `AGENTS.md` reflect automated update semantics and evidence/provenance expectations.
- Keep explicit requirement traceability for `COMP-03` in downstream planning artifacts.

</specifics>

<deferred>
## Deferred Ideas

- `AUTO-06` output schema versioning and compatibility guarantees for downstream parsers.
- CI-provider integration and matrix auto-publication pipelines.
- Deep environment permutation expansion (`COMP-04` and beyond).

</deferred>

---
*Phase: 08-compatibility-matrix-evidence-automation*
*Context gathered: 2026-02-25*
