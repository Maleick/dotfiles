# Feature Research

**Domain:** Red-team terminal dotfiles and operator environment management
**Researched:** 2026-02-25
**Confidence:** HIGH

## Feature Landscape

### Table Stakes (Users Expect These)

Features users assume exist. Missing these = product feels incomplete.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Safe installer with backups | Operators must not lose existing configs | MEDIUM | `install.sh` backup + symlink behavior is core contract |
| Stable shell aliases/functions | Red-team workflows depend on predictable command behavior | MEDIUM | Includes network helpers, encoding helpers, reverse shell generation |
| Tmux keybinding reliability | Session orchestration is core daily workflow | MEDIUM | Includes logging/recording and shortcut continuity |
| Vim plugin/mapping consistency | Editing operations must stay predictable | MEDIUM | Theme fallback and plugin setup must not break startup |
| Accurate docs and help entrypoints | Operators need fast recall under pressure | LOW | README and `/help` guidance must match reality |

### Differentiators (Competitive Advantage)

Features that set the project apart. Not required, but valuable.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Context-aware verification checklist | Reduces regressions before rollout | MEDIUM | Bridges gap between ad hoc checks and heavy CI |
| Structured phase-driven planning artifacts | Enables resumable execution and clear scope | MEDIUM | Uses `.planning/` lifecycle documents |
| Cross-platform command guards | Improves reliability across macOS/Linux hosts | MEDIUM | Catches utility flag differences early |

### Anti-Features (Commonly Requested, Often Problematic)

Features that seem good but create problems.

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Large plugin explosion | “More tools means more power” | Startup slowdown and maintenance burden | Keep curated plugin set aligned to real workflows |
| Hidden magic bootstrap layers | “One command should do everything automatically” | Harder debugging and poor failure visibility | Explicit install script + observable steps |
| Embedding secrets in dotfiles | Convenience | High security risk, easy accidental leak | Local untracked overrides + external secret loaders |

## Feature Dependencies

```
Installer safety
    └──requires──> repo source-of-truth discipline
                       └──requires──> documented reload workflow

Shell/tmux/vim stability ──requires──> compatibility checks

Documentation accuracy ──depends_on──> validated runtime behavior
```

### Dependency Notes

- **Workflow reliability requires installer safety first:** configuration behavior is meaningless if bootstrap is unsafe.
- **Docs depend on verified behavior:** documentation updates should follow successful checks, not assumptions.
- **Compatibility hardening depends on baseline commands:** preserve behavior before adding stricter guards.

## MVP Definition

### Launch With (v1)

Minimum viable product — what is needed to validate reliability sprint outcomes.

- [ ] Installer idempotency and backup correctness verified
- [ ] Zsh/tmux/vim core workflows validated against docs
- [ ] Local verification checklist documented and runnable
- [ ] Documentation drift corrected for active commands and bindings

### Add After Validation (v1.x)

- [ ] Optional wrapper command for running full local verification set
- [ ] Compatibility notes split by OS profile (macOS/Linux)

### Future Consideration (v2+)

- [ ] Lightweight automation hook for pre-commit checks
- [ ] Structured release checklist template for each version bump

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Installer safety verification | HIGH | MEDIUM | P1 |
| Shell/tmux/vim behavior validation | HIGH | MEDIUM | P1 |
| Documentation alignment | HIGH | LOW | P1 |
| Compatibility matrix expansion | MEDIUM | MEDIUM | P2 |
| Automated validation wrappers | MEDIUM | MEDIUM | P2 |

**Priority key:**
- P1: Must have for launch
- P2: Should have, add when possible
- P3: Nice to have, future consideration

## Competitor Feature Analysis

| Feature | Competitor A | Competitor B | Our Approach |
|---------|--------------|--------------|--------------|
| Dotfile bootstrap | Generic symlink scripts | Framework-driven bootstrap | Keep explicit, auditable shell installer |
| Shell workflow curation | Broad/unfocused aliases | Minimal baseline only | Maintain red-team specific helpers + OPSEC defaults |
| Validation strategy | CI-heavy | Manual only | Local-first checklist with future optional automation |

## Sources

- `/opt/dotfiles/.planning/codebase/CONCERNS.md`
- `/opt/dotfiles/.planning/codebase/CONVENTIONS.md`
- `/opt/dotfiles/idea.md`

---
*Feature research for: red-team terminal dotfiles*
*Researched: 2026-02-25*
