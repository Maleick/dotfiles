# Tmux

Key bindings:

- `Prefix + h/j/k/l`: move between panes
- `Prefix + H/J/K/L`: resize panes
- `Prefix + |`: horizontal split in current path
- `Prefix + -`: vertical split in current path
- `Prefix + S`: save pane history to `~/Logs`
- `Prefix + N`: create a named session
- `Prefix + s`: open tmux's built-in session tree
- `Prefix + U`: open aliasr in a split and send to previous pane
- `Prefix + K`: open aliasr in a split and execute in previous pane
- `Prefix + r`: reload tmux config

Copy-mode `y` uses the first available clipboard tool from `pbcopy`, `wl-copy`, `xclip`, `clip.exe`, then falls back to the tmux buffer.
