# Requirements: Red Team Dotfiles Reliability Sprint

**Defined:** 2026-02-25
**Core Value:** An operator can bootstrap and trust a stable red-team shell environment in minutes, without regressions in critical workflows.

## v1 Requirements

### Installation

- [x] **INST-01**: Running `install.sh` creates timestamped backups before replacing target dotfiles.
- [x] **INST-02**: Running `install.sh` creates/refreshes correct symlinks for `~/.zshrc`, `~/.tmux.conf`, and `~/.vimrc`.
- [x] **INST-03**: Re-running `install.sh` does not break shell/editor startup behavior.

### Shell Reliability

- [x] **SHLL-01**: `zsh/.zshrc` preserves OPSEC history settings and command behavior across reloads.
- [x] **SHLL-02**: Warp-aware prompt/runtime behavior remains functional.
- [x] **SHLL-03**: `aliasr` integration (`alias a='aliasr'`) remains available and documented.
- [x] **SHLL-04**: Core helper commands have platform-safe behavior or explicit guarded fallback paths.

### Tmux and Vim Stability

- [x] **TVIM-01**: `tmux` navigation, logging, and `aliasr` keybindings (`Prefix + U`, `Prefix + K`) work as documented.
- [x] **TVIM-02**: `vim` plugin bootstrap, theme fallback, and key mappings load without startup breakage.

### Documentation and Verification

- [x] **DOCS-01**: `README.md` and `AGENTS.md` match actual command/keybinding behavior.
- [x] **DOCS-02**: `CHANGELOG.md` and `VERSION` stay consistent with delivered reliability changes.
- [x] **VFY-01**: A repeatable local verification checklist exists for installer, shell, tmux, and vim checks.

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
| INST-01 | Phase 1 | Complete |
| INST-02 | Phase 1 | Complete |
| INST-03 | Phase 1 | Complete |
| VFY-01 | Phase 1 | Complete |
| SHLL-01 | Phase 2 | Complete |
| SHLL-02 | Phase 2 | Complete |
| SHLL-03 | Phase 2 | Complete |
| SHLL-04 | Phase 2 | Complete |
| TVIM-01 | Phase 3 | Complete |
| TVIM-02 | Phase 3 | Complete |
| DOCS-01 | Phase 4 | Complete |
| DOCS-02 | Phase 4 | Complete |

**Coverage:**
- v1 requirements: 12 total
- Mapped to phases: 12
- Unmapped: 0 ✓

---
*Requirements defined: 2026-02-25*
*Last updated: 2026-02-25 after Phase 4 documentation/release hygiene completion*
