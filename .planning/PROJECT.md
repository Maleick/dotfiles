# Red Team Dotfiles Reliability Sprint

## What This Is

This project hardens and evolves a red-team-focused dotfiles repository so setup and daily terminal workflows stay predictable. It targets a solo operator who relies on `zsh`, `tmux`, and `vim` as primary tooling. The repository remains the source of truth for install behavior, shell helpers, keybindings, and operator guidance.

## Core Value

An operator can bootstrap and trust a stable red-team shell environment in minutes, without regressions in critical workflows.

## Current State (v1.2 Shipped)

`v1.2` is shipped and archived. The codebase now includes:
- Wrapper mode contracts in `./scripts/verify-suite.sh` (`default`, `--quick`, `--json`, `--quick --json`).
- Canonical compatibility matrix at `.planning/compatibility/v1.1-matrix.md`.
- Deterministic evidence automation via `./scripts/update-compat-matrix.sh` and `scripts/update_compat_matrix.py`.
- Goal-backward verification artifacts through `.planning/phases/08-compatibility-matrix-evidence-automation/08-VERIFICATION.md`.

## Next Milestone Goals

- [ ] Define next milestone objective and scope with `$gsd-new-milestone`.
- [ ] Generate fresh active requirements (`.planning/REQUIREMENTS.md`) for the next release cycle.
- [ ] Decide whether to prioritize deferred automation (`AUTO-06`, `COMP-04`) or a new reliability focus area.

## Requirements

### Validated

- ✓ Installer safety/idempotency and deterministic reruns (`INST-01`, `INST-02`, `INST-03`) — v1.0
- ✓ Shell reliability preserving OPSEC, Warp behavior, aliasr integration, and helper fallbacks (`SHLL-01`, `SHLL-02`, `SHLL-03`, `SHLL-04`) — v1.0
- ✓ Tmux/Vim workflow stability with preserved keybinding and fallback contracts (`TVIM-01`, `TVIM-02`) — v1.0
- ✓ Documentation/release metadata parity and repeatable verification checklist (`DOCS-01`, `DOCS-02`, `VFY-01`) — v1.0
- ✓ Verification wrapper command and deterministic status/exit contracts (`AUTO-01`, `AUTO-02`, `AUTO-03`) — v1.1
- ✓ Compatibility matrix baseline coverage and caveat-aware traceability (`COMP-01`, `COMP-02`) — v1.1
- ✓ Quick-mode wrapper contract with locked minimum required-check subset (`AUTO-04`) — v1.2
- ✓ Machine-readable wrapper contract with deterministic per-check records (`AUTO-05`) — v1.2
- ✓ Compatibility matrix row generation/update from observed verification evidence (`COMP-03`) — v1.2

### Active

- [ ] No active milestone requirements yet (run `$gsd-new-milestone`).

### Out of Scope

- Converting this repo into a compiled application or service.
- Storing secrets, tokens, or credential material in tracked files.
- Introducing enterprise process overhead (sprint ceremonies, stakeholder workflows).
- Redesigning established operator keybindings or changing aliasr integration contracts.

## Context

- v1.2 shipped wrapper mode expansion and matrix evidence automation while preserving runtime feature-family boundaries.
- Active roadmap and requirements are intentionally collapsed for next-cycle setup.
- Existing reliability contracts in `install.sh`, `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc` remain source of truth.
- Documentation and maintainer guidance (`README.md`, `AGENTS.md`) are aligned to shipped wrapper/matrix behavior.

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
| Keep research and checker gates enabled in auto planning flows | Maintains plan quality while preserving momentum | ✓ Good |
| Preserve no-flag wrapper behavior while adding mode flags | Avoids breaking existing operator workflows | ✓ Good |
| Use evidence-only matrix update model with strict schema guardrails | Prevents inferred compatibility claims and matrix drift | ✓ Good |
| Archive `v1.1` and `v1.2` without formal audit artifacts | Delivery momentum favored over strict audit gate | ⚠ Revisit |

<details>
<summary>Milestone Archive Context</summary>

### v1.1
- Archive roadmap: `.planning/milestones/v1.1-ROADMAP.md`
- Archive requirements: `.planning/milestones/v1.1-REQUIREMENTS.md`
- Scope: 2 phases, 4 plans, 8 tasks

### v1.2
- Archive roadmap: `.planning/milestones/v1.2-ROADMAP.md`
- Archive requirements: `.planning/milestones/v1.2-REQUIREMENTS.md`
- Scope: 2 phases, 4 plans, 8 tasks
- Git range: `v1.1..HEAD`
- Diff summary: 31 files changed, 2250 insertions(+), 347 deletions(-)

</details>

---
*Last updated: 2026-02-25 after v1.2 milestone completion*
