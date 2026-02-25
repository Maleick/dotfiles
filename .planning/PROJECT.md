# Red Team Dotfiles Reliability Sprint

## What This Is

This project hardens and evolves a red-team-focused dotfiles repository so setup and daily terminal workflows stay predictable. It targets a solo operator who relies on `zsh`, `tmux`, and `vim` as primary tooling. The repository remains the source of truth for install behavior, shell helpers, keybindings, and operator guidance.

## Core Value

An operator can bootstrap and trust a stable red-team shell environment in minutes, without regressions in critical workflows.

## Current Milestone: v1.1 automation

**Goal:** Automate reliability verification and publish an operator-safe compatibility matrix so environment validation is faster and repeatable.

**Target features:**
- Single-command validation wrapper that runs shell/tmux/vim/docs checks and returns a clear pass/fail summary.
- Compatibility matrix documenting expected behavior across macOS/Linux and common network/runtime conditions.
- Documentation alignment so operators can choose the right checks per environment without ambiguity.

## Requirements

### Validated

- ✓ Installer safety/idempotency and deterministic reruns (`INST-01`, `INST-02`, `INST-03`) — v1.0
- ✓ Shell reliability preserving OPSEC, Warp behavior, aliasr integration, and helper fallbacks (`SHLL-01`, `SHLL-02`, `SHLL-03`, `SHLL-04`) — v1.0
- ✓ Tmux/Vim workflow stability with preserved keybinding and fallback contracts (`TVIM-01`, `TVIM-02`) — v1.0
- ✓ Documentation/release metadata parity and repeatable verification checklist (`DOCS-01`, `DOCS-02`, `VFY-01`) — v1.0

### Active

- [ ] `AUTO-01`: Add optional command wrapper to run the full validation suite quickly.
- [ ] `AUTO-02`: Add expanded compatibility matrix for multiple OS/network environments.

### Out of Scope

- Converting this repo into a compiled application or service.
- Storing secrets, tokens, or credential material in tracked files.
- Introducing enterprise process overhead (sprint ceremonies, stakeholder workflows).

## Context

Milestone `v1.0` shipped on 2026-02-25 with all 4 planned phases complete (10 plans / 20 tasks). Runtime behavior is aligned across `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`, and release metadata is synchronized (`VERSION=2.1.1`, updated `CHANGELOG.md`, docs parity updates in `README.md` and `AGENTS.md`). Phase-level execution history remains in `.planning/phases/` and milestone archives in `.planning/milestones/`.

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
| Archive `v1.0` with milestone artifacts before new scope definition | Keeps active planning files concise while preserving traceable history | ✓ Good |
| Start `v1.1` scope from carried-forward automation requirements (`AUTO-01`, `AUTO-02`) | Maintains continuity from validated v1.0 outcomes and reduces re-discovery overhead | ✓ Good |

---
*Last updated: 2026-02-25 after v1.1 milestone kickoff*
