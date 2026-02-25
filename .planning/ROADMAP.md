# Roadmap: Red Team Dotfiles Reliability Sprint

## Overview

This roadmap delivers reliability hardening in a dependency-aware order: installer safety first, shell behavior stability second, tmux/vim workflow integrity third, and documentation/release hygiene last. Each phase maps directly to v1 requirements with observable completion criteria.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Installation Baseline** - Verify installer safety, idempotency, and baseline checks. (completed 2026-02-25)
- [ ] **Phase 2: Shell Reliability Hardening** - Preserve OPSEC, Warp, aliasr, and helper command stability.
- [ ] **Phase 3: Tmux/Vim Workflow Stability** - Keep keybindings and editor workflows dependable.
- [ ] **Phase 4: Documentation and Release Hygiene** - Align public docs and release metadata to shipped behavior.

## Phase Details

### Phase 1: Installation Baseline
**Goal**: Installer behavior is safe, repeatable, and verifiable on every run.
**Depends on**: Nothing (first phase)
**Requirements**: INST-01, INST-02, INST-03, VFY-01
**Success Criteria** (what must be TRUE):
  1. Running `install.sh` repeatedly preserves valid symlink targets and backups.
  2. Installer output and post-install runtime state are deterministic.
  3. Operators can execute a documented baseline verification checklist.
**Plans**: 3 plans

Plans:
- [x] 01-01-PLAN.md — Harden installer idempotency and backup safety behavior.
- [x] 01-02-PLAN.md — Define and publish baseline verification checklist.
- [x] 01-03-PLAN.md — Execute baseline checks and capture evidence.

### Phase 2: Shell Reliability Hardening
**Goal**: Shell startup and helper command surface remain stable across hosts and edits.
**Depends on**: Phase 1
**Requirements**: SHLL-01, SHLL-02, SHLL-03, SHLL-04
**Success Criteria** (what must be TRUE):
  1. OPSEC history and prompt behavior remain intact after reload.
  2. Warp-aware branch logic behaves correctly when `TERM_PROGRAM=WarpTerminal`.
  3. `aliasr` and core helpers execute correctly with guarded fallbacks where needed.
**Plans**: 3 plans

Plans:
- [ ] 02-01: Stabilize shell options, prompt branches, and environment ordering.
- [ ] 02-02: Validate helper commands and add safe compatibility guards.
- [ ] 02-03: Update shell-specific guidance to match final behavior.

### Phase 3: Tmux/Vim Workflow Stability
**Goal**: Multiplexer/editor behavior remains fast, predictable, and operator-safe.
**Depends on**: Phase 2
**Requirements**: TVIM-01, TVIM-02
**Success Criteria** (what must be TRUE):
  1. Tmux critical bindings and logging/recording paths behave as documented.
  2. Vim starts with intended plugin/theme fallback behavior.
  3. Core navigation and red-team mappings remain non-conflicting.
**Plans**: 2 plans

Plans:
- [ ] 03-01: Validate/fix tmux bindings, logging, and optional-tool behavior.
- [ ] 03-02: Validate/fix vim plugin/mapping startup and fallback behavior.

### Phase 4: Documentation and Release Hygiene
**Goal**: Documentation and release metadata accurately reflect delivered behavior.
**Depends on**: Phase 3
**Requirements**: DOCS-01, DOCS-02
**Success Criteria** (what must be TRUE):
  1. README and AGENTS accurately describe current commands and keybindings.
  2. CHANGELOG and VERSION are consistent with shipped reliability work.
  3. Operators can follow docs without hitting stale or missing references.
**Plans**: 2 plans

Plans:
- [ ] 04-01: Reconcile README/AGENTS with runtime behavior.
- [ ] 04-02: Finalize changelog/version hygiene for release readiness.

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 1.1 → 1.2 → 2 → 3 → 4

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Installation Baseline | 3/3 | Complete    | 2026-02-25 |
| 2. Shell Reliability Hardening | 0/3 | Not started | - |
| 3. Tmux/Vim Workflow Stability | 0/2 | Not started | - |
| 4. Documentation and Release Hygiene | 0/2 | Not started | - |
