# Roadmap: Red Team Dotfiles Reliability Sprint

## Milestones

- ✅ **v1.0 milestone** — Phases 1-4 shipped on 2026-02-25. Archive: `.planning/milestones/v1.0-ROADMAP.md`.
- 🚧 **v1.1 automation** — Phases 5-6 planned for validation automation and compatibility coverage.

## Overview

This roadmap converts manual reliability checks into a repeatable operator command and a maintained compatibility matrix, without adding new runtime feature families. Work starts from the already-shipped v1.0 baseline and keeps existing shell/tmux/vim workflow contracts intact.

## Phases

- [x] **Phase 5: Validation Wrapper Baseline** - Build one-command reliability verification with deterministic summary and exit-code contracts. (completed 2026-02-25)
- [ ] **Phase 6: Compatibility Matrix and Coverage** - Publish validated environment matrix and integrate matrix/docs verification flow.

## Phase Details

### Phase 5: Validation Wrapper Baseline
**Goal**: Operators can run one command from repo root to verify core runtime contracts quickly and reliably.
**Depends on**: v1.0 shipped baseline
**Requirements**: AUTO-01, AUTO-02, AUTO-03
**Success Criteria** (what must be TRUE):
  1. A single documented wrapper command executes shell/tmux/vim/docs checks from repo root.
  2. Wrapper output reports per-check PASS/FAIL/SKIP and returns non-zero if required checks fail.
  3. Optional dependency checks remain fail-soft with actionable guidance when dependencies are missing.
**Plans**: 2 plans

Plans:
- [x] 05-01-PLAN.md — Implement wrapper orchestration and check catalog contracts.
- [x] 05-02-PLAN.md — Harden output semantics, fail-soft handling, and wrapper documentation.

### Phase 6: Compatibility Matrix and Coverage
**Goal**: Compatibility guidance is grounded in validated check outcomes and remains easy for operators to follow.
**Depends on**: Phase 5
**Requirements**: COMP-01, COMP-02
**Success Criteria** (what must be TRUE):
  1. A compatibility matrix documents baseline macOS/Linux verification behavior and caveats.
  2. Matrix entries include last-validated command set/date and environment notes.
  3. README/AGENTS reference matrix usage so operators can select appropriate checks per environment.
**Plans**: 2 plans

Plans:
- [ ] 06-01-PLAN.md — Create compatibility matrix artifact from validated checks.
- [ ] 06-02-PLAN.md — Integrate matrix guidance into docs and verification flow.

## Progress

**Execution Order:**
Phases execute in numeric order: 5 -> 6

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 5. Validation Wrapper Baseline | 2/2 | Complete    | 2026-02-25 |
| 6. Compatibility Matrix and Coverage | 0/2 | Not started | - |
