# Verification

Run the maintained smoke wrapper from the repo root:

```bash
./scripts/verify-suite.sh
```

The wrapper validates installer syntax, script-location path resolution, zsh syntax, tmux config load, tmux clipboard fallback, Vim startup, and documentation surface contracts.

Useful focused checks:

```bash
bash -n install.sh
zsh -n zsh/.zshrc
tmux -f tmux/.tmux.conf -L dotfiles-check start-server \; kill-server
vim -Nu vim/.vimrc -n -es -c 'qa!'
```
