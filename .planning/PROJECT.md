# Red Team Dotfiles

## What This Is

Red Team Dotfiles is the source-of-truth repository for an operator-focused terminal environment built around `zsh`, `tmux`, and `vim`. It provides reproducible shell/editor ergonomics, red-team helper commands, and an idempotent installer that links managed configs into `$HOME`. The audience is a single operator who wants fast setup, predictable shortcuts, and low-friction daily usage across terminal-first workflows.

## Core Value

An operator can bootstrap and use a reliable red-team shell workflow in minutes, with critical behaviors staying stable release to release.

## Requirements

### Validated

- ✓ Installer backs up existing dotfiles and symlinks managed configs into `$HOME` (`install.sh`).
- ✓ `zsh` environment includes OPSEC-conscious history behavior, Warp-aware prompt handling, and red-team helper aliases/functions (`zsh/.zshrc`).
- ✓ `tmux` environment includes red-team navigation, logging/recording, and `aliasr` integration (`tmux/.tmux.conf`).
- ✓ `vim` environment is terminal-first, plugin-managed, and includes red-team oriented mappings (`vim/.vimrc`).
- ✓ Core usage and operator guidance are documented (`README.md`, `AGENTS.md`).

### Active

- [ ] Keep installation and reload workflows idempotent and safe across repeated runs.
- [ ] Preserve OPSEC, Warp compatibility, and `aliasr` behaviors while evolving configs.
- [ ] Introduce explicit verification checks for installer and config syntax so regressions are caught quickly.
- [ ] Keep documentation synchronized with actual command names, keybindings, and current repo scope.

### Out of Scope

- Full migration to a compiled/package-managed application — this repo remains plain-text dotfiles for direct operator control.
- Secret management implementation inside this repository — secret values and secret stores stay external by design.
- Enterprise process overhead (multi-team ceremonies, sprint governance) — this workflow targets solo operator execution.

## Context

This repository is intentionally slimmed down and currently contains managed configs for `zsh`, `tmux`, and `vim`, plus install/docs/version files. Mapping artifacts under `.planning/codebase/` establish current architecture, conventions, and concerns for planning. Existing docs note historical tooling not present in the current tree, so consistency and drift control are active concerns.

## Constraints

- **Behavioral compatibility**: Preserve critical workflows (`alias a='aliasr'`, tmux `Prefix + U/K`, OPSEC history options) — these are core operator habits.
- **Terminal-first scope**: Keep all changes CLI-native and terminal-compatible — no GUI assumptions.
- **Source-of-truth location**: Edit files inside repo paths (`zsh/`, `tmux/`, `vim/`) rather than `$HOME` symlink targets — avoids state drift.
- **Safety**: Never write secrets to repo files or generated planning artifacts — prevents credential leaks.
- **Incremental delivery**: Ship in phase-sized chunks with clear verifiable outcomes — enables fast correction loops.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Keep the repo as plain dotfiles + installer | Fast to audit, easy to patch, low coupling | ✓ Good |
| Preserve `aliasr` and Warp-specific integrations as compatibility constraints | Existing operator workflow depends on these bindings/branches | ✓ Good |
| Use `.planning/` artifacts to drive future phases | Makes requirements, roadmap, and execution state explicit and resumable | ✓ Good |
| Skip domain research for initialization | Codebase map already captures in-repo truth for this project type | ✓ Good |

---
*Last updated: 2026-02-25 after `$gsd-map-codebase` and `$gsd-new-project` initialization*
