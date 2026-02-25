# Red Team Dotfiles Reliability Sprint

## What This Is

This project hardens and evolves a red-team-focused dotfiles repository so setup and daily terminal workflows stay predictable. It targets a solo operator who relies on `zsh`, `tmux`, and `vim` as primary tooling. The repository remains the source of truth for install behavior, shell helpers, keybindings, and operator guidance.

## Core Value

An operator can bootstrap and trust a stable red-team shell environment in minutes, without regressions in critical workflows.

## Current State

**Milestone `v1.1 automation` shipped on 2026-02-25.**

Delivered outcomes:
- One-command verification wrapper (`./scripts/verify-suite.sh`) with deterministic `PASS`/`FAIL`/`SKIP` semantics.
- Evidence-backed compatibility matrix at `.planning/compatibility/v1.1-matrix.md`.
- README/AGENTS guidance for matrix interpretation and maintenance policy.
- Phase-level verification reports confirming completion of `AUTO-01`, `AUTO-02`, `AUTO-03`, `COMP-01`, and `COMP-02`.

## Next Milestone Goals

Pending definition via `$gsd-new-milestone`.

Suggested starting areas:
- Decide whether to prioritize `AUTO-04` quick-mode execution.
- Decide whether to prioritize `AUTO-05` machine-readable output mode.
- Evaluate `COMP-03` matrix generation automation from repeatable run evidence.

## Requirements

### Validated

- ✓ Installer safety/idempotency and deterministic reruns (`INST-01`, `INST-02`, `INST-03`) — v1.0
- ✓ Shell reliability preserving OPSEC, Warp behavior, aliasr integration, and helper fallbacks (`SHLL-01`, `SHLL-02`, `SHLL-03`, `SHLL-04`) — v1.0
- ✓ Tmux/Vim workflow stability with preserved keybinding and fallback contracts (`TVIM-01`, `TVIM-02`) — v1.0
- ✓ Documentation/release metadata parity and repeatable verification checklist (`DOCS-01`, `DOCS-02`, `VFY-01`) — v1.0
- ✓ Verification wrapper command and deterministic status/exit contracts (`AUTO-01`, `AUTO-02`, `AUTO-03`) — v1.1
- ✓ Compatibility matrix baseline coverage and caveat-aware traceability (`COMP-01`, `COMP-02`) — v1.1

### Active

- [ ] Next milestone scope not defined yet (run `$gsd-new-milestone`).

### Out of Scope

- Converting this repo into a compiled application or service.
- Storing secrets, tokens, or credential material in tracked files.
- Introducing enterprise process overhead (sprint ceremonies, stakeholder workflows).

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
| Start `v1.1` scope from carried-forward automation requirements | Maintains continuity from validated v1.0 outcomes and reduces re-discovery overhead | ✓ Good |
| Use evidence-backed compatibility matrix contract in v1.1 | Prevents inferred claims and keeps operator trust high | ✓ Good |
| Archive `v1.1` without formal audit artifact | Explicitly accepted process debt to preserve delivery momentum | ⚠ Revisit |

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
*Last updated: 2026-02-25 after v1.1 milestone archival*
