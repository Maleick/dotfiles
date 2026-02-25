# Red Team Dotfiles Reliability Sprint

## What This Is

This project hardens and evolves a red-team-focused dotfiles repository so setup and daily terminal workflows stay predictable. It targets a solo operator who relies on `zsh`, `tmux`, and `vim` as primary tooling. The repository remains the source of truth for install behavior, shell helpers, keybindings, and operator guidance.

## Core Value

An operator can bootstrap and trust a stable red-team shell environment in minutes, without regressions in critical workflows.

## Current Milestone: v1.2 automation expansion

**Goal:** Extend verification automation and compatibility evidence workflows while preserving the read-only reliability contract.

**Target features:**
- `AUTO-04`: Add quick-mode execution for fast local pre-commit checks.
- `AUTO-05`: Add machine-readable verify output mode for tooling and log ingestion.
- `COMP-03`: Add repeatable compatibility-matrix row generation from observed verification runs.

## Requirements

### Validated

- ✓ Installer safety/idempotency and deterministic reruns (`INST-01`, `INST-02`, `INST-03`) — v1.0
- ✓ Shell reliability preserving OPSEC, Warp behavior, aliasr integration, and helper fallbacks (`SHLL-01`, `SHLL-02`, `SHLL-03`, `SHLL-04`) — v1.0
- ✓ Tmux/Vim workflow stability with preserved keybinding and fallback contracts (`TVIM-01`, `TVIM-02`) — v1.0
- ✓ Documentation/release metadata parity and repeatable verification checklist (`DOCS-01`, `DOCS-02`, `VFY-01`) — v1.0
- ✓ Verification wrapper command and deterministic status/exit contracts (`AUTO-01`, `AUTO-02`, `AUTO-03`) — v1.1
- ✓ Compatibility matrix baseline coverage and caveat-aware traceability (`COMP-01`, `COMP-02`) — v1.1

### Active

- [ ] `AUTO-04`: Quick-mode execution path for fast local pre-commit checks.
- [ ] `AUTO-05`: Machine-readable output mode for CI/log ingestion.
- [ ] `COMP-03`: Compatibility matrix row generation from repeatable observed verification runs.

### Out of Scope

- Converting this repo into a compiled application or service.
- Storing secrets, tokens, or credential material in tracked files.
- Introducing enterprise process overhead (sprint ceremonies, stakeholder workflows).
- Redesigning established operator keybindings or changing aliasr integration contracts.

## Context

- v1.1 shipped deterministic wrapper verification (`./scripts/verify-suite.sh`) and canonical matrix documentation at `.planning/compatibility/v1.1-matrix.md`.
- Next delivery should deepen automation without introducing new runtime feature families.
- Existing reliability contracts in `install.sh`, `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc` remain the source of truth.
- Documentation and maintainer guidance (`README.md`, `AGENTS.md`) must stay synchronized with wrapper/matrix behavior.

## Constraints

- **Compatibility**: Preserve existing operator workflows and keybindings (`alias a='aliasr'`, tmux `Prefix + U`/`Prefix + K`) — changing these breaks daily usage.
- **Security**: Never commit secret values or credential payloads — protects operator and infrastructure exposure.
- **Terminal-first**: All outcomes must work in terminal environments (macOS first, Linux-compatible where intended).
- **Read-only verification**: Verification commands must not mutate runtime config by default.
- **Source-of-truth**: Changes are made in repo files, then linked into `$HOME` via `install.sh`.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Keep repo as dotfiles + installer | Maximizes auditability and low-friction edits | ✓ Good |
| Run initialization in auto mode from `idea.md` | User requested automatic rerun with explicit idea source | ✓ Good |
| Keep research enabled in auto mode | Captures ecosystem guidance before final roadmap structure | ✓ Good |
| Preserve existing codebase map while resetting init docs | Avoids losing verified architectural context | ✓ Good |
| Archive `v1.0` with milestone artifacts before new scope definition | Keeps active planning files concise while preserving traceable history | ✓ Good |
| Start `v1.1` scope from carried-forward automation requirements | Maintains continuity from validated v1.0 outcomes and reduces re-discovery overhead | ✓ Good |
| Use evidence-backed compatibility matrix contract in v1.1 | Prevents inferred claims and keeps operator trust high | ✓ Good |
| Archive `v1.1` without formal audit artifact | Explicitly accepted process debt to preserve delivery momentum | ⚠ Revisit |
| Start `v1.2` from deferred automation/matrix items (`AUTO-04`, `AUTO-05`, `COMP-03`) | Aligns new work to explicitly deferred backlog with low discovery risk | — Pending |

<details>
<summary>v1.1 Development Context Archive</summary>

- Milestone range: `v1.0..HEAD`
- Phase coverage: 5-6
- Plans complete: 4/4
- Tasks complete: 8
- Diff summary: 28 files changed, 1846 insertions(+), 314 deletions(-)
- Key artifacts:
  - `.planning/milestones/v1.1-ROADMAP.md`
  - `.planning/milestones/v1.1-REQUIREMENTS.md`
  - `.planning/compatibility/v1.1-matrix.md`

</details>

---
*Last updated: 2026-02-25 after v1.2 milestone kickoff*
