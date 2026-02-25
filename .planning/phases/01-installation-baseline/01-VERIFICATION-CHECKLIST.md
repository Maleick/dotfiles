# Phase 1 Baseline Verification Checklist

Run these commands from the repository root (`/opt/dotfiles`) to validate installation baseline safety.

## 1. Syntax checks

Command:

```bash
bash -n install.sh
```

Pass criteria:
- Command exits `0`.
- No syntax errors are printed.

Command:

```bash
zsh -n zsh/.zshrc
```

Pass criteria:
- Command exits `0`.
- No parse errors are printed.

## 2. Tmux config load sanity

Command:

```bash
tmux -f tmux/.tmux.conf new-session -d -s gsd_baseline_check
tmux kill-session -t gsd_baseline_check
```

Pass criteria:
- Command exits `0`.
- No invalid-option or parse errors are printed.

## 3. Vim startup sanity

Command:

```bash
vim -Nu vim/.vimrc -n -es +'qa!'
```

Pass criteria:
- Command exits `0`.
- Vim starts and exits without fatal config errors.

## 4. Installer idempotency and link integrity

Command:

```bash
./install.sh
./install.sh
```

Pass criteria:
- Both runs exit `0`.
- Per-target state logs are explicit (`[already linked]`, `[backed up]`, `[linked]`).

Command:

```bash
ls -l "$HOME/.dotfiles" "$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.vimrc"
```

Pass criteria:
- `~/.dotfiles` points to `/opt/dotfiles`.
- `~/.zshrc` points to `/opt/dotfiles/zsh/.zshrc`.
- `~/.tmux.conf` points to `/opt/dotfiles/tmux/.tmux.conf`.
- `~/.vimrc` points to `/opt/dotfiles/vim/.vimrc`.

## 5. Result recording format

For each command above, record:
- Status: `PASS` or `FAIL`
- Timestamp: UTC ISO-8601
- Notes: key output lines and follow-up action if failed
