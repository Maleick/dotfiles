# Phase 6: Compatibility Matrix and Coverage - Research

**Researched:** 2026-02-25
**Domain:** Compatibility documentation grounded in observed verification evidence
**Confidence:** HIGH

## User Constraints

### Locked Decisions (from 06-CONTEXT.md)
- Compatibility artifact source-of-truth path is `.planning/compatibility/v1.1-matrix.md`.
- Matrix rows must use explicit status values: `PASS` / `SKIP` / `FAIL`.
- Every matrix row must include: environment profile, check scope, status, caveat text, command set reference, and last-validated date.
- Matrix claims must be evidence-backed by observed command runs; inferred compatibility claims are out of scope.
- Coverage depth is baseline macOS/Linux with explicit runtime/network caveat tags.
- `README.md` and `AGENTS.md` must explain matrix usage/interpretation.
- Phase 6 is documentation/coverage work only (no net-new runtime features).

### Requirement Mapping

| Requirement | Phase 6 Interpretation | Planning Impact |
|-------------|------------------------|-----------------|
| `COMP-01` | Operator can reference a matrix covering baseline macOS/Linux install/shell/tmux/vim verification behavior | Must create and populate `.planning/compatibility/v1.1-matrix.md` with baseline platform rows and check-scope coverage |
| `COMP-02` | Matrix entries include command set and environment caveats | Must include command refs + caveat taxonomy + last-validated date, and document matrix consumption in README/AGENTS |

### Deferred / Out of Scope
- `AUTO-04` quick-mode wrapper behavior
- `AUTO-05` machine-readable output mode
- `COMP-03` auto-generated matrix rows from historical runs
- CI-provider integration scaffolding
- Deep distro/terminal/profile permutation expansion

## Current Repository Ground Truth

### Existing Evidence Sources
- `./scripts/verify-suite.sh` outputs deterministic `PASS`/`FAIL`/`SKIP` + summary and is the primary Phase 5 evidence producer.
- `.planning/phases/05-validation-wrapper-baseline/05-VERIFICATION.md` already records observed evidence for required/optional checks.
- `.planning/phases/01-installation-baseline/01-VERIFICATION-CHECKLIST.md` defines baseline command intent across install/shell/tmux/vim surfaces.

### Current Gaps for Phase 6
- `.planning/compatibility/` directory does not yet exist.
- No `v1.1-matrix.md` compatibility artifact exists yet.
- README and AGENTS mention wrapper behavior but not compatibility matrix interpretation or freshness policy.

## Recommended Artifact Design

### Canonical Matrix File
**Path:** `.planning/compatibility/v1.1-matrix.md`

**Recommended sections:**
1. Purpose and scope boundary
2. Command set reference block
3. Matrix table with required row fields
4. Caveat tag glossary
5. Freshness/update policy
6. Evidence notes (explicit source references)

### Matrix Row Schema (enforce in plans)

| Field | Type | Notes |
|------|------|-------|
| `Environment Profile` | text | Example: `macOS (current host)` / `Linux (baseline target)` |
| `Check Scope` | text | Install, shell, tmux, vim, docs parity groupings |
| `Status` | enum | One of `PASS` / `SKIP` / `FAIL` |
| `Caveat` | text | Human-readable constraint/limitation statement |
| `Command Set Reference` | text | Link or pointer to wrapper/checklist commands |
| `Last Validated` | date | `YYYY-MM-DD` |

### Status Semantics
- `PASS`: observed check execution succeeded for stated environment/check scope.
- `FAIL`: observed check execution failed for stated environment/check scope.
- `SKIP`: check not executed in that environment context (include actionable caveat explaining why).

This preserves evidence-only policy while allowing cross-environment coverage without fabricating pass/fail claims.

## Documentation Integration Strategy

### README Contract
Add a concise compatibility section that states:
- where matrix lives,
- when to consult it,
- how to interpret `PASS/SKIP/FAIL`,
- that matrix claims come from observed command runs.

### AGENTS Contract
Add maintainer guidance for:
- updating matrix after relevant verification/runtime/docs changes,
- preserving row schema and evidence policy,
- avoiding inferred compatibility claims.

## Verification Strategy for Phase 6 Plans

Plans should include executable verify commands that prove:
- matrix file exists at canonical path,
- rows include required schema fields,
- status vocabulary constrained to `PASS/SKIP/FAIL`,
- entries include command reference + last-validated date,
- README and AGENTS reference matrix usage,
- no prohibited scope creep terms (`AUTO-04`, `AUTO-05`, CI scaffolding, auto-generation implementation).

## Implementation Decomposition Recommendation

### Plan 06-01 (Wave 1)
- Create `.planning/compatibility/v1.1-matrix.md` and populate baseline rows from observed evidence.
- Include command-set reference and caveat taxonomy.
- Focus requirement coverage on `COMP-01`.

### Plan 06-02 (Wave 2, depends on 06-01)
- Integrate matrix interpretation and freshness guidance into README and AGENTS.
- Ensure traceable linkage to canonical matrix file and maintained evidence policy.
- Focus requirement coverage on `COMP-02`.

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Treating inferred behavior as validated behavior | Invalid matrix claims | Enforce evidence-only wording and `SKIP` for non-observed contexts |
| Matrix/docs drift over time | Operator confusion | Add explicit freshness/update policy in matrix and maintainer docs |
| Scope creep into wrapper feature changes | Delayed phase completion | Keep modifications constrained to matrix + docs references |
| Inconsistent row formatting | Hard to maintain | Lock row schema and verify with grep-based checks |

## Suggested Verify Commands for Planner

```bash
test -f .planning/compatibility/v1.1-matrix.md
rg -n "PASS|SKIP|FAIL" .planning/compatibility/v1.1-matrix.md
rg -n "Environment Profile|Check Scope|Status|Caveat|Command Set Reference|Last Validated" .planning/compatibility/v1.1-matrix.md
rg -n "scripts/verify-suite\.sh|01-VERIFICATION-CHECKLIST\.md|05-VERIFICATION\.md" .planning/compatibility/v1.1-matrix.md
rg -n "compatibility matrix|v1\.1-matrix\.md|PASS|SKIP|FAIL" README.md AGENTS.md
```

## Sources
- `.planning/phases/06-compatibility-matrix-and-coverage/06-CONTEXT.md`
- `.planning/ROADMAP.md`
- `.planning/REQUIREMENTS.md`
- `.planning/phases/05-validation-wrapper-baseline/05-VERIFICATION.md`
- `.planning/phases/01-installation-baseline/01-VERIFICATION-CHECKLIST.md`
- `scripts/verify-suite.sh`
- `README.md`
- `AGENTS.md`

---
*Research completed: 2026-02-25*
*Ready for planning: yes*
