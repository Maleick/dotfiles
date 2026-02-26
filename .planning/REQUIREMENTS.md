# Requirements: Red Team Dotfiles Reliability Sprint

**Defined:** 2026-02-26
**Core Value:** An operator can bootstrap and trust a stable red-team shell environment in minutes, without regressions in critical workflows.

## v1.3 Requirements

Requirements for the v1.3 milestone. Each maps to exactly one roadmap phase.

### Wrapper Schema Contracts

- [ ] **AUTO-06**: Operator and tooling can rely on an explicit versioned JSON output schema from `./scripts/verify-suite.sh --json`, with backward-compatible guarantees for existing fields.

### Compatibility Coverage Expansion

- [ ] **COMP-04**: Maintainer can capture and maintain additional Linux distro/terminal profile compatibility evidence rows with canonical schema fields, explicit caveats, and validation dates.

## v2 Requirements

Deferred to a future release.

### Extended Automation

- **AUTO-07**: Add machine-readable matrix export mode for downstream tooling and reports.
- **COMP-05**: Add repeatable profile bundle runner for batch evidence collection.

## Out of Scope

Explicit exclusions for v1.3 to prevent scope drift.

| Feature | Reason |
|---------|--------|
| CI-provider-specific publishing pipelines | Local operator workflow remains primary scope |
| Auto-install missing dependencies during verify/update runs | Violates read-only verification posture |
| Net-new shell/tmux/vim feature families | Milestone scope is automation hardening only |
| Matrix auto-publication to external systems | Requires infra/process expansion beyond v1.3 |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUTO-06 | Phase 9 | Pending |
| COMP-04 | Phase 10 | Pending |

**Coverage:**
- v1.3 requirements: 2 total
- Mapped to phases: 2
- Unmapped: 0 ✓

---
*Requirements defined: 2026-02-26*
*Last updated: 2026-02-26 after roadmap creation*
