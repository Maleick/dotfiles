# Phase 1 Baseline Results

## Execution Metadata

- Checklist source: `.planning/phases/01-installation-baseline/01-VERIFICATION-CHECKLIST.md`
- Run date: 2026-02-25
- Runner: Codex execution in `/opt/dotfiles`

## Command Outcomes

| Check | Timestamp (UTC) | Status | Notes |
|---|---|---|---|
| `bash -n install.sh` | 2026-02-25T18:36:45Z | PASS | Installer syntax valid. |
| `zsh -n zsh/.zshrc` | 2026-02-25T18:36:45Z | PASS | Shell config parsed successfully. |
| `tmux -f tmux/.tmux.conf new-session -d -s gsd_baseline_check && tmux kill-session -t gsd_baseline_check` | 2026-02-25T18:36:45Z | PASS | Tmux config loaded and temporary session lifecycle succeeded. |
| `vim -Nu vim/.vimrc -n -es +'qa!'` | 2026-02-25T18:36:45Z | PASS | Vim startup sanity check passed in non-interactive mode. |
| `./install.sh` (rerun #1) | 2026-02-25T18:36:45Z | PASS | Reported explicit `[already linked]` states for all managed targets. |
| `./install.sh` (rerun #2) | 2026-02-25T18:36:45Z | PASS | Repeat run remained idempotent with stable logs. |
| `ls -l "$HOME/.dotfiles" "$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.vimrc"` | 2026-02-25T18:36:45Z | PASS | All symlinks point to `/opt/dotfiles` repository targets. |

## Key Evidence

Installer rerun output (both runs):

```text
[start] Creating backup directory at /Users/maleick/.dotfiles_backup_20260225123645
[start] Copying dotfiles to home directory...
[already linked] /Users/maleick/.dotfiles -> /opt/dotfiles
[already linked] /Users/maleick/.tmux.conf -> /opt/dotfiles/tmux/.tmux.conf
[already linked] /Users/maleick/.vimrc -> /opt/dotfiles/vim/.vimrc
[already linked] /Users/maleick/.zshrc -> /opt/dotfiles/zsh/.zshrc
[done] Dotfiles install completed.
```

Symlink integrity output:

```text
/Users/maleick/.dotfiles -> /opt/dotfiles
/Users/maleick/.tmux.conf -> /opt/dotfiles/tmux/.tmux.conf
/Users/maleick/.vimrc -> /opt/dotfiles/vim/.vimrc
/Users/maleick/.zshrc -> /opt/dotfiles/zsh/.zshrc
```

## Overall Verdict

Phase 1 baseline checks passed. Installer behavior is deterministic on rerun, and managed symlink targets are correct.

## Residual Concerns

None.
