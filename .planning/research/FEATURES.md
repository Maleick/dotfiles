# Features Research — v1.3 Automation Hardening

## Milestone Theme

Harden machine-readable contracts and broaden compatibility evidence depth while preserving existing operator workflows.

## Table Stakes

### AUTO-06 — JSON Schema Version Contract

- Add explicit version field in `--json` payload.
- Document compatibility expectations for downstream parsers.
- Preserve existing payload keys and semantics (`checks`, `summary`, `PASS/FAIL/SKIP`, required-failure signaling).
- Add deterministic verification checks for schema fields and backward-compat behavior.

### COMP-04 — Compatibility Coverage Expansion

- Expand matrix coverage to additional Linux distro/terminal profile combinations.
- Ensure each new row remains evidence-backed with caveat + command reference + last-validated date.
- Keep row status vocabulary restricted to `PASS`/`SKIP`/`FAIL`.
- Preserve canonical matrix target and freshness policy.

## Differentiators (Optional but Valuable)

- Coverage profile templates for common operator environments (e.g., Ubuntu + tmux, Kali + Warp alternatives).
- Clear “not observed” guidance for environments without local evidence.
- Stable profile naming conventions to reduce duplicate-key drift.

## Anti-Features / Keep Out of Scope

- CI-driven automatic publication pipelines.
- Runtime feature-family changes in `zsh`, `tmux`, `vim`.
- Large schema refactors that break existing `--json` consumers.

## Complexity Notes

- AUTO-06: low to medium (contract + docs + smoke checks).
- COMP-04: medium (coverage strategy and deterministic evidence capture discipline).

## Dependency Relationships

- AUTO-06 should land before COMP-04 evidence expansion to stabilize downstream parsing semantics for new coverage runs.
