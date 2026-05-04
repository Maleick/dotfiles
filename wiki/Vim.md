# Vim

The Vim config is terminal-first and fail-soft:

- Starts cleanly when `vim-plug` is missing.
- Uses `~/.vim/autoload/plug.vim` when available.
- Installs plugins into `~/.vim/plugged`.
- Prefers dark terminal themes and falls back safely if a theme is unavailable.
- Guards COC mappings so startup does not break when plugin functions are missing.

Install or refresh plugins inside Vim:

```vim
:PlugInstall
```

Headless startup check:

```bash
vim -Nu vim/.vimrc -n -es -c 'qa!'
```
