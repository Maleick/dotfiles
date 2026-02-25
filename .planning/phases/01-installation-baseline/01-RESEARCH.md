# Phase 01 Research: Installation Baseline

**Phase:** 01 - installation-baseline
**Date:** 2026-02-25
**Confidence:** HIGH

<objective>
Research how to implement Phase 1 (Installation Baseline) so planning can produce executable, low-risk plans.
</objective>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| INST-01 | Running `install.sh` creates timestamped backups before replacing target dotfiles. | Installer needs explicit pre-link backup checks and deterministic backup path logging. |
| INST-02 | Running `install.sh` creates/refreshes correct symlinks for `~/.zshrc`, `~/.tmux.conf`, and `~/.vimrc`. | Symlink operations should be explicit and idempotent with path validation. |
| INST-03 | Re-running `install.sh` does not break shell/editor startup behavior. | Repeat-run safety requires non-destructive behavior when symlinks already point correctly. |
| VFY-01 | A repeatable local verification checklist exists for installer, shell, tmux, and vim checks. | Phase must output documented commands and expected outcomes for baseline checks. |
</phase_requirements>

<findings>
## Key Findings

### Current installer behavior
- `install.sh` already uses `set -e` and a `link_file` helper for backup + symlink setup.
- Existing flow creates a timestamped backup directory and moves pre-existing targets into it.
- Existing symlink logic is simple (`ln -sf`) and generally idempotent, but does not emit detailed checks about pre-existing correct symlinks.

### Risks observed
- Installer output is concise but not explicit about idempotency outcomes (for example, whether a file was already correctly linked vs newly linked).
- Verification guidance is mostly in `README.md`; there is no formal baseline checklist artifact in phase directory yet.
- Re-run behavior is safe in practice, but safety criteria are not codified in a reusable script/checklist.

### Recommended implementation direction
- Keep installer architecture lightweight (no framework migration).
- Add guarded link behavior in `link_file`:
  - detect already-correct symlink and skip unnecessary replacement,
  - only back up non-symlink or mis-targeted existing files,
  - preserve deterministic user-facing log messages.
- Add a Phase 1 baseline verification script/checklist under phase docs so future changes can rerun the same checks.

### Verification commands (baseline)
- `bash -n install.sh`
- `zsh -n zsh/.zshrc`
- `tmux -f tmux/.tmux.conf start-server \; source-file tmux/.tmux.conf \; kill-server`
- `vim -Nu vim/.vimrc -n +qall` (startup sanity)
- `./install.sh` run twice; verify symlinks with `ls -l ~/.zshrc ~/.tmux.conf ~/.vimrc`

</findings>

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Every install run must create timestamped backup behavior for replacement scenarios.
- Re-running install must remain safe and leave runtime configs usable.
- A repeatable baseline verification checklist is required output for this phase.

### Claude's Discretion
- Exact checklist wording/format.
- Internal installer helper structure, as long as external behavior remains stable.
- Verbosity level for non-critical informational logs.

### Deferred Ideas (OUT OF SCOPE)
- Full automation wrapper for all validation checks (future phase).
- Expanded compatibility matrix and release checklist automation (future phase).
</user_constraints>

<confidence>
## Confidence Assessment

| Area | Level | Reason |
|------|-------|--------|
| Installer hardening scope | HIGH | Directly based on current `install.sh` and phase context constraints |
| Verification checklist feasibility | HIGH | Commands exist and are reproducible in current repo shape |
| Cross-host behavior certainty | MEDIUM | Primary baseline is local; broader host matrix deferred |
</confidence>

## Open Questions
- None blocking for planning; edge-case host compatibility remains deferred by scope.

---
*Research complete: 2026-02-25*
