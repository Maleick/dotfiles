# Requirements: Red Team Dotfiles Reliability Sprint

**Defined:** 2026-02-25
**Core Value:** An operator can bootstrap and trust a stable red-team shell environment in minutes, without regressions in critical workflows.

## v1.2 Requirements

Requirements for the v1.2 milestone. Each maps to exactly one roadmap phase.

### Wrapper Modes and Contracts

- [ ] **AUTO-04**: Operator can run a quick verification mode from repo root that completes faster while preserving a locked minimum required-check signal.
- [ ] **AUTO-05**: Operator can run a machine-readable output mode that reports per-check `PASS`/`FAIL`/`SKIP` statuses and deterministic summary counts without changing default human-readable output behavior.

### Compatibility Evidence Automation

- [ ] **COMP-03**: Maintainer can generate/update compatibility matrix rows from observed verification run evidence with canonical schema fields and validation date provenance.

## v3 Requirements

Deferred to a future release.

### Extended Automation

- **AUTO-06**: Add output schema versioning and compatibility guarantees for downstream parsers.
- **COMP-04**: Expand compatibility matrix coverage across broader distro/terminal profile permutations.

## Out of Scope

Explicit exclusions for v1.2 to prevent scope drift.

| Feature | Reason |
|---------|--------|
| CI-provider-specific integration scaffolding | Local operator workflow remains primary scope |
| Auto-install missing dependencies during verify run | Violates read-only verification posture |
| Auto-rewrite runtime config files from verification command | High side-effect risk and trust degradation |
| Net-new shell/tmux/vim feature families | Milestone is automation and evidence hygiene only |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUTO-04 | Phase TBD | Pending |
| AUTO-05 | Phase TBD | Pending |
| COMP-03 | Phase TBD | Pending |

**Coverage:**
- v1.2 requirements: 3 total
- Mapped to phases: 0
- Unmapped: 3 ⚠️

---
*Requirements defined: 2026-02-25*
*Last updated: 2026-02-25 after initial v1.2 definition*
