# Requirements: Red Team Dotfiles

**Defined:** 2026-02-25
**Core Value:** An operator can bootstrap and use a reliable red-team shell workflow in minutes, with critical behaviors staying stable release to release.

## v1 Requirements

Requirements for the current milestone. Each maps to a roadmap phase.

### Installation

- [ ] **INST-01**: `install.sh` creates timestamped backups before replacing existing `~/.zshrc`, `~/.tmux.conf`, and `~/.vimrc`.
- [ ] **INST-02**: `install.sh` symlinks managed files from repo paths (`zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`) into `$HOME`.
- [ ] **INST-03**: Re-running `install.sh` is idempotent and leaves a valid, usable shell/editor setup.

### Zsh Workflow

- [ ] **ZSH-01**: `zsh/.zshrc` preserves OPSEC history behavior (`hist_ignore_space`, dedupe, immediate append).
- [ ] **ZSH-02**: Warp-aware behavior and prompt branching remain intact.
- [ ] **ZSH-03**: `alias a='aliasr'` and documented red-team helper commands remain functional.

### Tmux Workflow

- [ ] **TMX-01**: `tmux/.tmux.conf` keeps red-team session shortcuts and pane/window navigation behavior stable.
- [ ] **TMX-02**: `tmux/.tmux.conf` preserves recording/logging and `aliasr` split-pane keybindings (`Prefix + U`, `Prefix + K`).

### Vim Workflow

- [ ] **VIM-01**: `vim/.vimrc` remains terminal-first with plugin declarations and fallback-safe theme logic.
- [ ] **VIM-02**: Key mappings for red-team and navigation workflows remain available and non-conflicting.

### Documentation & Verification

- [ ] **DOC-01**: `README.md` and `AGENTS.md` accurately describe current commands, keybindings, and repository scope.
- [ ] **QA-01**: A documented local verification checklist exists and covers syntax/load checks for installer, zsh, tmux, and vim configs.

## v2 Requirements

### Tooling Enhancements

- **AUTO-01**: Add optional automated validation hooks (for example local task runner wrappers) without forcing CI dependency.
- **AUTO-02**: Add structured compatibility test matrix for macOS/Linux shell differences.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Rewriting configs into a GUI settings app | Violates terminal-first and plain-text editability goals |
| Bundling secrets or secret retrieval mechanisms in repo | Security boundary: secrets remain external to tracked files |
| Mandatory cloud CI gate for all edits | Current workflow is local-first and intentionally lightweight |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| INST-01 | Phase 1 | Pending |
| INST-02 | Phase 1 | Pending |
| INST-03 | Phase 1 | Pending |
| QA-01 | Phase 1 | Pending |
| ZSH-01 | Phase 2 | Pending |
| ZSH-02 | Phase 2 | Pending |
| ZSH-03 | Phase 2 | Pending |
| TMX-01 | Phase 3 | Pending |
| TMX-02 | Phase 3 | Pending |
| VIM-01 | Phase 3 | Pending |
| VIM-02 | Phase 3 | Pending |
| DOC-01 | Phase 4 | Pending |

**Coverage:**
- v1 requirements: 12 total
- Mapped to phases: 12
- Unmapped: 0 ✓

---
*Requirements defined: 2026-02-25*
*Last updated: 2026-02-25 after initial definition*
