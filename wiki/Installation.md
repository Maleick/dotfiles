# Installation

Clone and install from any current directory:

```bash
git clone https://github.com/Maleick/dotfiles.git /opt/dotfiles
/opt/dotfiles/install.sh
```

The installer backs up existing `~/.zshrc`, `~/.tmux.conf`, and `~/.vimrc` into `~/.dotfiles_backup_<timestamp>` before linking the repo-managed files.

After installing, reload the shell:

```bash
source ~/.zshrc
```

Use `/help` to view the built-in command guide.
