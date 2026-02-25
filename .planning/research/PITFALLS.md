# Pitfalls Research

**Domain:** Red-team terminal dotfiles and operator environment management
**Researched:** 2026-02-25
**Confidence:** HIGH

## Critical Pitfalls

### Pitfall 1: Installer Drift and Non-Idempotent Changes

**What goes wrong:** Repeated installs create inconsistent links/backups or overwrite expected state.

**Why it happens:** Installer updates are made without replaying the install path across existing home state variations.

**How to avoid:** Validate backup/link behavior after any installer change and keep explicit path checks.

**Warning signs:** Backup directories stop appearing, symlink targets diverge, or install outputs vary between runs.

**Phase to address:** Phase 1 (Installation Baseline).

---

### Pitfall 2: Documentation Drift from Runtime Reality

**What goes wrong:** README/AGENTS describe commands or tooling no longer present.

**Why it happens:** Runtime config evolves faster than documentation updates.

**How to avoid:** Include documentation reconciliation as required release-phase work.

**Warning signs:** Docs reference missing commands, files, or keybindings.

**Phase to address:** Phase 4 (Docs and Release Hygiene).

---

### Pitfall 3: Cross-Platform Command Assumptions

**What goes wrong:** Helper aliases/functions fail on hosts with different CLI flags or binaries.

**Why it happens:** Commands are validated only on one OS profile.

**How to avoid:** Add compatibility checks and command fallbacks for macOS/Linux variants.

**Warning signs:** Runtime errors around `base64`, `ip`, `route`, or clipboard/network helpers.

**Phase to address:** Phase 2 (Zsh Behavior Integrity).

---

### Pitfall 4: Keybinding Conflicts in Tmux/Vim

**What goes wrong:** Newly added bindings override critical navigation or workflow actions.

**Why it happens:** Key additions are not checked against existing bindings and docs.

**How to avoid:** Reserve critical bindings and run targeted keypath tests after edits.

**Warning signs:** Unexpected pane/editor behavior and previously working shortcuts no longer trigger.

**Phase to address:** Phase 3 (Tmux/Vim Workflow Stability).

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Skipping validation pass after config edits | Faster merge | Regressions in operator workflows | Only for draft exploration, never for final merge |
| Keeping stale docs temporarily | Short-term speed | Increases onboarding and execution errors | Acceptable for very short-lived branch work only |
| Adding alias/binding without section docs | Quick convenience | Command surface becomes opaque and fragile | Rarely acceptable |

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| `aliasr` | Renaming/removing alias or bindings unintentionally | Preserve `alias a='aliasr'` and tmux `Prefix + U/K` contracts |
| `asciinema` | Assuming recorder exists everywhere | Keep optional behavior and clear fallback messaging |
| External IP services | Single-provider reliance | Keep redundant helper endpoints |

## Performance Traps

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Excessive plugin growth in shell/editor | Slow startup and input lag | Maintain curated plugin set and fallback chain | Noticeable on lower-resource hosts |
| Overly complex prompt logic | Delayed prompt rendering | Keep prompt logic minimal and terminal-aware | Frequent command loops |
| Large helper monoliths in one file | Hard-to-debug regressions | Keep grouped sections and focused functions | As helper count rises |

## Security Mistakes

| Mistake | Risk | Prevention |
|---------|------|------------|
| Committing secrets in docs/config | Credential exposure | Keep secrets external and use local untracked overrides |
| Logging sensitive command output by default | OPSEC leakage | Preserve history controls and explicit logging actions |
| Trusting remote commands in helper aliases without review | Unintended execution risk | Keep helpers explicit, auditable, and documented |

## UX Pitfalls

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| Undocumented alias changes | Lost operator speed and confidence | Document and announce command surface updates |
| Inconsistent naming conventions | Higher cognitive load | Keep predictable naming patterns by section |
| Hidden dependency assumptions | Setup failures on new hosts | List prerequisites and fallbacks in README |

## "Looks Done But Isn't" Checklist

- [ ] **Installer update:** backup + symlink behavior validated across repeat runs.
- [ ] **Shell update:** core aliases/functions and prompt behavior manually checked.
- [ ] **Tmux/Vim update:** critical keybindings tested in live session.
- [ ] **Docs update:** README/AGENTS/CHANGELOG aligned with actual runtime behavior.

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Installer regression | MEDIUM | Restore from backup dir, fix installer logic, re-run idempotency checks |
| Docs drift | LOW | Reconcile docs against config files and ship update patch |
| Broken keybinding | LOW | Restore previous binding from git history and retest workflows |
| Cross-platform command failure | MEDIUM | Add guarded fallback path and verify on both target OS profiles |

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Installer drift | Phase 1 | Repeated install passes keep valid symlinks and backups |
| Cross-platform assumptions | Phase 2 | Shell helper checks pass on intended host profiles |
| Keybinding conflicts | Phase 3 | Critical tmux/vim paths validated in-session |
| Documentation drift | Phase 4 | Documentation audit confirms behavior parity |

## Sources

- `/opt/dotfiles/.planning/codebase/CONCERNS.md`
- `/opt/dotfiles/README.md`
- `/opt/dotfiles/AGENTS.md`

---
*Pitfalls research for: red-team terminal dotfiles*
*Researched: 2026-02-25*
