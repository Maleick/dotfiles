# Red Team Dotfiles Reliability Sprint

## What This Is

This project hardens and evolves a red-team-focused dotfiles repository so setup and daily terminal workflows stay predictable. It targets a solo operator who relies on `zsh`, `tmux`, and `vim` as primary tooling. The repository remains the source of truth for install behavior, shell helpers, keybindings, and operator guidance.

## Core Value

An operator can bootstrap and trust a stable red-team shell environment in minutes, without regressions in critical workflows.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Keep installer behavior safe and idempotent across repeated runs.
- [ ] Preserve OPSEC-conscious shell behavior, Warp compatibility, and `aliasr` integrations.
- [ ] Add verification coverage for shell/tmux/vim load and syntax checks.
- [ ] Keep docs aligned with actual commands, keybindings, and constraints.

### Out of Scope

- Converting this repo into a compiled application or service.
- Storing secrets, tokens, or credential material in tracked files.
- Introducing enterprise process overhead (sprint ceremonies, stakeholder workflows).

## Context

The repository currently contains configuration sources in `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`, plus installer/version/docs files. A codebase map exists under `.planning/codebase/` and highlights technical debt around validation gaps and documentation drift. The project idea emphasizes reliability, repeatability, and operator trust over feature expansion.

## Constraints

- **Compatibility**: Preserve existing operator workflows and keybindings (`alias a='aliasr'`, tmux `Prefix + U`/`Prefix + K`) — changing these breaks daily usage.
- **Security**: Never commit secret values or credential payloads — protects operator and infrastructure exposure.
- **Terminal-first**: All outcomes must work in terminal environments (macOS first, Linux-compatible where intended).
- **Source-of-truth**: Changes are made in repo files, then linked into `$HOME` via `install.sh`.
- **Incremental delivery**: Work is phased so each stage has observable reliability improvements.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Keep repo as dotfiles + installer | Maximizes auditability and low-friction edits | ✓ Good |
| Run initialization in auto mode from `idea.md` | User requested automatic rerun with explicit idea source | ✓ Good |
| Keep research enabled in auto mode | Captures ecosystem guidance before final roadmap structure | ✓ Good |
| Preserve existing codebase map while resetting init docs | Avoids losing verified architectural context | ✓ Good |

---
*Last updated: 2026-02-25 after auto re-initialization from `idea.md`*
