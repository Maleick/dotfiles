# Idea: Red Team Dotfiles Reliability Sprint

## One-line idea
Harden and evolve this dotfiles repository so an operator can install, reload, and use core red-team workflows with predictable behavior on every machine.

## Problem
- Current behavior is powerful but fragile in places because validation is mostly manual.
- Documentation can drift from real command/keybinding behavior.
- Cross-platform shell differences can silently break helper commands.

## Who this is for
- Primary user: a solo red-team operator running terminal-first workflows.
- Secondary user: any future maintainer who needs fast onboarding and low-risk edits.

## Core value
An operator can bootstrap a reliable red-team shell environment in minutes and trust that key workflows remain stable release to release.

## v1 goals
- Keep `install.sh` idempotent and safe across repeated runs.
- Preserve `zsh` OPSEC settings, Warp-aware behavior, and `aliasr` integration.
- Preserve `tmux` recording/logging and `aliasr` keybindings.
- Preserve `vim` terminal-first plugin/mapping behavior.
- Add a clear verification checklist for installer + shell/tmux/vim syntax/load checks.
- Align README/AGENTS/CHANGELOG with actual repository behavior.

## Non-goals
- Rebuilding this repo as a compiled application.
- Adding secrets management into tracked files.
- Introducing heavyweight enterprise workflow/process tooling.

## Constraints
- Source of truth stays in repo files (`zsh/`, `tmux/`, `vim/`, `install.sh`).
- No secret values in repo content or generated planning artifacts.
- Maintain backward compatibility for core aliases and keybindings.

## Success criteria
- Fresh install and re-install both succeed with correct symlinks and backups.
- Core shell/tmux/vim workflows work as documented.
- Verification steps are documented and repeatable.
- Documentation matches real behavior and no stale references remain.

## Future (v2+) ideas
- Optional lightweight automated validation wrappers.
- Expanded compatibility matrix for macOS/Linux shell differences.
- More structured release checklists for version/changelog quality.
