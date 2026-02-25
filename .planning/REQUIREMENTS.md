# Requirements: Red Team Dotfiles Automation Milestone

**Defined:** 2026-02-25
**Core Value:** An operator can bootstrap and trust a stable red-team shell environment in minutes, without regressions in critical workflows.

## v1.1 Requirements

Requirements for the v1.1 milestone. Each maps to exactly one roadmap phase.

### Automation Enhancements

- [x] **AUTO-01**: Operator can run a single repository command from repo root that executes the reliability validation suite.
- [x] **AUTO-02**: Validation wrapper reports deterministic per-check PASS/FAIL/SKIP results and returns non-zero when required checks fail.
- [x] **AUTO-03**: Validation wrapper preserves fail-soft behavior for optional dependencies and emits actionable skip guidance.

### Compatibility Matrix

- [x] **COMP-01**: Operator can reference a compatibility matrix covering baseline macOS and Linux behavior for install/shell/tmux/vim verification.
- [x] **COMP-02**: Compatibility matrix entries include last-validated command set and environment caveats (network/runtime differences).

## v2 Requirements

Deferred to a future release.

### Automation and Coverage Expansion

- **AUTO-04**: Add quick-mode execution path for fast local pre-commit checks.
- **AUTO-05**: Add machine-readable output mode for CI/log ingestion.
- **COMP-03**: Generate compatibility matrix rows from repeatable verification runs.

## Out of Scope

Explicitly excluded for this milestone.

| Feature | Reason |
|---------|--------|
| Auto-installing missing dependencies during validation | Introduces side effects and reduces operator trust |
| Auto-rewriting runtime configs as part of verify command | Verification must remain read-only |
| CI-provider-specific integration scaffolding | Scope is local operator workflow reliability first |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUTO-01 | Phase 5 | Complete |
| AUTO-02 | Phase 5 | Complete |
| AUTO-03 | Phase 5 | Complete |
| COMP-01 | Phase 6 | Complete |
| COMP-02 | Phase 6 | Complete |

**Coverage:**
- v1.1 requirements: 5 total
- Mapped to phases: 5
- Unmapped: 0 ✓

---
*Requirements defined: 2026-02-25*
*Last updated: 2026-02-25 after Phase 6 completion*
