# Project Research Summary

**Project:** Red Team Dotfiles Reliability Sprint
**Domain:** Verification automation expansion and compatibility evidence maintenance
**Researched:** 2026-02-25
**Confidence:** HIGH

## Executive Summary

The next milestone should deliver the explicitly deferred automation outcomes from v1.1: quick-mode wrapper execution (`AUTO-04`), machine-readable output (`AUTO-05`), and evidence-backed matrix row generation (`COMP-03`). Existing runtime contracts and wrapper behavior are stable, so milestone risk is mostly contract drift, not core runtime instability.

Research indicates the safest approach is to keep `./scripts/verify-suite.sh` as the single canonical entrypoint while adding mode-aware behavior behind explicit flags. Quick mode and machine output should share one execution core so status semantics remain deterministic. Compatibility matrix automation should only transform observed run evidence into the canonical matrix schema and should never infer PASS outcomes.

## Key Findings

### Recommended Stack

Use shell-first implementation with optional helper tooling (`jq`, `shellcheck`, `bats-core`) for contract verification and maintainability.

**Core technologies:**
- `bash`: mode routing, check execution, and deterministic exit behavior.
- Runtime CLIs (`zsh`/`tmux`/`vim`): required-check contract targets.
- Core shell tooling (`awk`/`sed`/`grep`/`rg`, `date`, `mktemp`): result shaping and evidence metadata.

### Expected Features

**Must have (table stakes):**
- Quick mode that preserves required reliability signals.
- Machine-readable output mode aligned to current PASS/FAIL/SKIP contracts.
- Matrix row generation path that enforces observed-evidence provenance.

**Should have (competitive):**
- Unified single-entrypoint invocation with explicit mode flags.
- Stable docs guidance for operators and maintainers on mode/coverage semantics.

**Defer (v3+):**
- CI-provider integration scaffolding.
- Fully automatic matrix publication pipeline.

### Architecture Approach

Add mode parsing and shared result modeling to the existing wrapper, then add matrix-generation helpers that consume observed results into canonical markdown rows. Keep docs integration in the same milestone to reduce behavior/documentation drift.

**Major components:**
1. Wrapper mode router in `scripts/verify-suite.sh`.
2. Shared check-result model for text and machine output.
3. Matrix-generation/update helper with schema/evidence validation.

### Critical Pitfalls

1. **Quick mode signal erosion** — avoid by locking minimum required-check set.
2. **Text/machine output divergence** — avoid by rendering both from one result model.
3. **Inferred matrix status claims** — avoid by requiring command references plus date per row.
4. **Schema drift in matrix rows** — avoid with explicit column/status validation checks.

## Implications for Roadmap

Based on research, suggested phase structure:

### Phase 7: Verification Wrapper Modes and Output Contracts
**Rationale:** Shared mode/output contracts are the prerequisite for reliable matrix generation.
**Delivers:** `AUTO-04` and `AUTO-05` implementation and verification.
**Addresses:** quick execution and machine-readable output needs.
**Avoids:** quick-mode drift and report inconsistency pitfalls.

### Phase 8: Compatibility Matrix Evidence Automation
**Rationale:** Matrix automation should build on stable wrapper output contracts.
**Delivers:** `COMP-03` generation/update flow and docs maintenance guidance.
**Uses:** observed run evidence from wrapper/checklist contracts.
**Implements:** canonical schema + provenance guardrails for matrix updates.

### Phase Ordering Rationale

- Mode/output contracts must be stable before matrix automation can consume them.
- Matrix automation should be downstream of wrapper behavior to avoid brittle schema churn.
- Keeping docs linkage in Phase 8 prevents matrix policy drift at milestone closeout.

### Research Flags

Phases likely needing deeper research during planning:
- **Phase 8:** matrix row generation ergonomics and provenance validation details.

Phases with standard patterns (skip deep research-phase):
- **Phase 7:** wrapper mode/output extension follows established shell patterns in this repo.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Builds directly on existing verified shell-based workflow |
| Features | HIGH | Requirements are explicit deferred items from shipped v1.1 |
| Architecture | HIGH | Incremental extension of known wrapper/matrix contracts |
| Pitfalls | HIGH | Drift and provenance risks are already visible in current manual flow |

**Overall confidence:** HIGH

### Gaps to Address

- Exact machine-readable schema fields and backward-compatibility guarantees must be finalized during phase planning.
- Matrix generation UX (single command vs helper flow) should be decided by implementability and verification clarity.

## Sources

### Primary (HIGH confidence)
- `scripts/verify-suite.sh`
- `.planning/milestones/v1.1-REQUIREMENTS.md`
- `.planning/compatibility/v1.1-matrix.md`
- `README.md`
- `AGENTS.md`

### Secondary (MEDIUM confidence)
- `.planning/phases/05-validation-wrapper-baseline/05-VERIFICATION.md`
- `.planning/phases/06-compatibility-matrix-and-coverage/06-VERIFICATION.md`

---
*Research completed: 2026-02-25*
*Ready for roadmap: yes*
