# Feature Research

**Domain:** Dotfiles verification workflow automation expansion
**Researched:** 2026-02-25
**Confidence:** HIGH

## Feature Landscape

### Table Stakes (Users Expect These)

Features operators should get in this milestone because they were deferred explicitly from v1.1 scope.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Quick-mode wrapper path (`AUTO-04`) | Operator needs faster pre-commit confidence loop | MEDIUM | Should preserve deterministic order for selected required checks |
| Machine-readable output mode (`AUTO-05`) | Maintainers need parseable verify results in scripts/log pipelines | MEDIUM | Must coexist with current human-readable output contract |
| Matrix row generation from observed runs (`COMP-03`) | Matrix maintenance is currently manual and easy to drift | MEDIUM | Needs strict evidence-only provenance and timestamp discipline |
| Stable default wrapper behavior unchanged | Existing users rely on current command semantics | LOW | Default mode must remain backwards-compatible |

### Differentiators (Competitive Advantage)

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Unified command with explicit mode flags | Prevents command sprawl and keeps operator mental model simple | LOW | Keep `./scripts/verify-suite.sh` as canonical entrypoint |
| Matrix update helpers tied to wrapper output schema | Reduces documentation drift and trust debt | MEDIUM | Requires stable output field names |
| Contract-level docs guidance for new modes | Improves maintainer handoff quality | LOW | README/AGENTS should document guarantees and caveats clearly |

### Anti-Features (Commonly Requested, Often Problematic)

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Quick mode skipping essential required checks | Faster run time | Produces false confidence and weakens release hygiene | Define a locked required-check minimum set for quick mode |
| Replacing human output with machine-only output | Easier automation consumption | Hurts operator debugging and interactive use | Keep human-readable default; add explicit machine mode |
| Auto-generated matrix `PASS` labels without observed runs | Convenience | Violates evidence policy and can mislead operators | Require observed command artifacts and explicit caveat tags |

## Feature Dependencies

```
[AUTO-04 quick mode]
    └──requires──> [Stable check catalog partitions]
                       └──requires──> [Required check baseline contract]

[AUTO-05 machine output]
    └──requires──> [Deterministic result model]
                       └──requires──> [Stable field schema]

[COMP-03 matrix generation]
    └──requires──> [Observed wrapper/checklist evidence]
                       └──requires──> [Canonical matrix schema contract]
```

## Priority Signals for This Milestone

1. Preserve existing behavior first, then add modes.
2. Keep output contracts explicit and testable.
3. Keep matrix claims evidence-backed, with no inferred success labels.

## Sources

- `idea.md` (future v2+ ideas)
- `.planning/PROJECT.md` (active milestone scope)
- `.planning/milestones/v1.1-REQUIREMENTS.md` (deferred requirement lineage)
- `scripts/verify-suite.sh` (current wrapper behavior)
- `.planning/compatibility/v1.1-matrix.md` (existing matrix schema)

---
*Feature research for: v1.2 automation expansion*
*Researched: 2026-02-25*
