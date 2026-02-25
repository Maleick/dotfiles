# Requirements: Red Team Dotfiles Reliability Sprint

**Defined:** 2026-02-25
**Core Value:** An operator can bootstrap and trust a stable red-team shell environment in minutes, without regressions in critical workflows.

## v1 Requirements

### Installation

- [ ] **INST-01**: Running `install.sh` creates timestamped backups before replacing target dotfiles.
- [ ] **INST-02**: Running `install.sh` creates/refreshes correct symlinks for `~/.zshrc`, `~/.tmux.conf`, and `~/.vimrc`.
- [ ] **INST-03**: Re-running `install.sh` does not break shell/editor startup behavior.

### Shell Reliability

- [ ] **SHLL-01**: `zsh/.zshrc` preserves OPSEC history settings and command behavior across reloads.
- [ ] **SHLL-02**: Warp-aware prompt/runtime behavior remains functional.
- [ ] **SHLL-03**: `aliasr` integration (`alias a='aliasr'`) remains available and documented.
- [ ] **SHLL-04**: Core helper commands have platform-safe behavior or explicit guarded fallback paths.

### Tmux and Vim Stability

- [ ] **TVIM-01**: `tmux` navigation, logging, and `aliasr` keybindings (`Prefix + U`, `Prefix + K`) work as documented.
- [ ] **TVIM-02**: `vim` plugin bootstrap, theme fallback, and key mappings load without startup breakage.

### Documentation and Verification

- [ ] **DOCS-01**: `README.md` and `AGENTS.md` match actual command/keybinding behavior.
- [ ] **DOCS-02**: `CHANGELOG.md` and `VERSION` stay consistent with delivered reliability changes.
- [ ] **VFY-01**: A repeatable local verification checklist exists for installer, shell, tmux, and vim checks.

## v2 Requirements

### Automation Enhancements

- **AUTO-01**: Add optional command wrapper to run full validation suite quickly.
- **AUTO-02**: Add expanded compatibility matrix for multiple OS/network environments.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Rewriting into GUI or compiled application | Not aligned with terminal-first operator workflow |
| Committing secrets/credentials in tracked config/docs | Violates security boundary |
| Enterprise multi-team process scaffolding | Not needed for solo operator execution |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| INST-01 | Phase 1 | Pending |
| INST-02 | Phase 1 | Pending |
| INST-03 | Phase 1 | Pending |
| VFY-01 | Phase 1 | Pending |
| SHLL-01 | Phase 2 | Pending |
| SHLL-02 | Phase 2 | Pending |
| SHLL-03 | Phase 2 | Pending |
| SHLL-04 | Phase 2 | Pending |
| TVIM-01 | Phase 3 | Pending |
| TVIM-02 | Phase 3 | Pending |
| DOCS-01 | Phase 4 | Pending |
| DOCS-02 | Phase 4 | Pending |

**Coverage:**
- v1 requirements: 12 total
- Mapped to phases: 12
- Unmapped: 0 ✓

---
*Requirements defined: 2026-02-25*
*Last updated: 2026-02-25 after auto-mode re-initialization*
