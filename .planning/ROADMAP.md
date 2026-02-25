# Roadmap: Red Team Dotfiles

## Overview

This roadmap strengthens the existing red-team dotfiles baseline by preserving core operator workflows first, then hardening shell/editor behavior, and finally tightening docs and verification so future changes can ship with lower regression risk.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: Installation Baseline** - Lock in installer safety and reproducible bootstrap checks.
- [ ] **Phase 2: Zsh Behavior Integrity** - Preserve OPSEC, Warp, and alias-driven shell workflow reliability.
- [ ] **Phase 3: Tmux/Vim Workflow Stability** - Harden terminal multiplexer and editor behavior without breaking established bindings.
- [ ] **Phase 4: Docs and Release Hygiene** - Align docs to real behavior and close drift before next milestone.

## Phase Details

### Phase 1: Installation Baseline
**Goal**: Installer behavior is safe, repeatable, and verifiable on every run.
**Depends on**: Nothing (first phase)
**Requirements**: INST-01, INST-02, INST-03, QA-01
**Success Criteria** (what must be TRUE):
  1. Running `install.sh` creates backups before replacing managed dotfiles.
  2. Running `install.sh` multiple times keeps valid symlinks and working configs.
  3. A local verification checklist exists and parse/load checks can be executed by an operator.
**Plans**: 3 plans

Plans:
- [ ] 01-01: Validate and harden backup/symlink idempotency paths in `install.sh`.
- [ ] 01-02: Define and document local verification commands for installer and config syntax.
- [ ] 01-03: Execute baseline verification and capture expected outcomes in planning docs.

### Phase 2: Zsh Behavior Integrity
**Goal**: Shell startup and helper command behavior remain stable across edits.
**Depends on**: Phase 1
**Requirements**: ZSH-01, ZSH-02, ZSH-03
**Success Criteria** (what must be TRUE):
  1. OPSEC-sensitive history settings remain active and documented.
  2. Warp detection/prompt behavior still works as expected after reload.
  3. `aliasr` and key helper aliases/functions run without regressions.
**Plans**: 3 plans

Plans:
- [ ] 02-01: Audit and stabilize critical shell options, prompt branches, and PATH ordering.
- [ ] 02-02: Verify helper functions/aliases and fix compatibility regressions.
- [ ] 02-03: Update shell help text or inline guidance where behavior changed.

### Phase 3: Tmux/Vim Workflow Stability
**Goal**: Tmux and Vim remain dependable for red-team terminal workflows.
**Depends on**: Phase 2
**Requirements**: TMX-01, TMX-02, VIM-01, VIM-02
**Success Criteria** (what must be TRUE):
  1. Tmux navigation, logging, and `aliasr` split-pane shortcuts behave as documented.
  2. Vim loads with intended plugin/theme fallback behavior in terminal environments.
  3. Core red-team and navigation mappings remain available and conflict-free.
**Plans**: 3 plans

Plans:
- [ ] 03-01: Validate and adjust tmux bindings, logging paths, and optional-tool fallbacks.
- [ ] 03-02: Validate vim plugin/mapping setup and improve fallback safety.
- [ ] 03-03: Add/update focused manual verification notes for tmux and vim workflows.

### Phase 4: Docs and Release Hygiene
**Goal**: Public docs match shipped behavior and milestone is ready for controlled release.
**Depends on**: Phase 3
**Requirements**: DOC-01
**Success Criteria** (what must be TRUE):
  1. README and AGENTS describe current commands, bindings, and repo structure accurately.
  2. No stale references to removed tooling remain in user-facing guidance.
  3. Release notes/versioning updates reflect actual delivered changes.
**Plans**: 2 plans

Plans:
- [ ] 04-01: Reconcile README/AGENTS/CHANGELOG with implemented behavior.
- [ ] 04-02: Prepare release hygiene pass (version/changelog consistency check).

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 1.1 → 1.2 → 2 → 3 → 4

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Installation Baseline | 0/3 | Not started | - |
| 2. Zsh Behavior Integrity | 0/3 | Not started | - |
| 3. Tmux/Vim Workflow Stability | 0/3 | Not started | - |
| 4. Docs and Release Hygiene | 0/2 | Not started | - |
