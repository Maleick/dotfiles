# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository overview

This repo contains opinionated dotfiles for a red-team focused shell environment. It is not an application with a build/test pipeline, but a set of configuration files that are symlinked into the home directory.

Key pieces:
- `zsh/.zshrc` – primary shell configuration, including Warp-specific behavior, PATH/tool setup, aliases, and red-team helper functions.
- `tmux/.tmux.conf` – tmux configuration optimized for Warp and red-team workflows, with recording/logging helpers and shortcuts.
- `vim/.vimrc` – Vim configuration with `vim-plug`-first behavior and fail-soft startup guards when plugin tooling is unavailable.
- `install.sh` – idempotent installer that backs up existing dotfiles and symlinks these configs into `$HOME`.
- `README.md` – high-level feature overview and usage examples for shell aliases and functions.
- `CHANGELOG.md` and `VERSION` – semantic versioning and historical notes; some older tooling mentioned there (e.g., CI/test frameworks, Makefile) is not present in this slimmed-down repo.

## Common workflows & commands

### Initial install / re-install

From the repo root:
- Install/sync dotfiles into `$HOME` (backs up existing files into `~/.dotfiles_backup_<timestamp>`):
  - `./install.sh`
- After editing configs in this repo, re-run `./install.sh` to refresh the symlinks if necessary, then reload the shell:
  - `source ~/.zshrc`

Be aware that every `./install.sh` run will move any existing `~/.zshrc`, `~/.vimrc`, and `~/.tmux.conf` into a new backup directory before re-linking.

### Verifying the environment

Once installed:
- Reload shell config: `source ~/.zshrc`
- Show the current version of the dotfiles: `cat VERSION`
- Use the built-in help for red-team commands: `/help`
- Run wrapper baseline verification from repo root: `./scripts/verify-suite.sh` (deterministic `PASS`/`FAIL`/`SKIP` output, non-zero on required-check failure, fail-soft optional checks)

### Editing core configs

When updating behavior, future agents should edit the files in this repo, not the copies in `$HOME` (those are symlink targets):
- Zsh: edit `zsh/.zshrc`
- Tmux: edit `tmux/.tmux.conf`
- Vim: edit `vim/.vimrc`

After changes, prompt the user to either start a new shell/tmux/Vim session or reload the specific component (e.g., `source ~/.zshrc`, restart tmux, or restart Vim).

## Zsh configuration architecture (`zsh/.zshrc`)

High-level structure (order matters in some sections):
- **Environment & tooling setup**
  - Homebrew shell environment on macOS (auto-detection of `/opt/homebrew` vs `/usr/local`).
  - Python 3.13 and OpenJDK 17 added to `PATH` for compatibility with offensive tooling (e.g., PyO3 tools, Cobalt Strike client).
  - Docker CLI completions, pdtm-related Go paths, and other tool-specific PATH adjustments near the end.
  - PATH mutations are guarded to avoid duplicate entries during repeated shell reloads.
- **Warp-specific behavior**
  - Detects Warp via `TERM_PROGRAM == "WarpTerminal"` and sets `WARP_TERMINAL=1` plus disables auto title for better integration.
  - Prompt logic branches on `WARP_TERMINAL` to keep the Warp prompt simpler (Warp handles directory display itself).
- **Interactive shell behavior**
  - Zsh options (history, completion, keybindings, prompt substitution, etc.) tuned for productivity and red-team OPSEC (e.g., commands starting with a space are not logged, history deduplication).
  - Completion system using a custom `fpath`, cached `compinit`, and specific completion styles for tools like `nmap` and `gobuster`.
  - Syntax highlighting and autosuggestions configured if the relevant plugins are present on disk.
- **Aliases and red-team helpers**
  - Standard colored `ls`/`grep`/`diff` family aliases plus convenience `ll`, `lt`, `lh`, etc.
  - **aliasr integration:** `alias a='aliasr'` provides a short alias for the `aliasr` TUI launcher (installed via `pipx`/`uv tool`). Future agents must preserve this alias when refactoring.
  - Network and recon helpers (`myip*`, `localip`, `netinfo`, `quickscan`, `ports`, `listening`, `webserver`, `http-server`, `https-server`, `smbserver`, etc.) now use guarded fallback behavior instead of brittle single-command assumptions.
  - Encoding/decoding utilities (`base64encode`, `base64decode`, `urlencode`, `urldecode`, `rot13`, `hexdump`, `strings`) include cross-platform decode flag handling (`-D`/`-d`) for macOS/Linux reliability.
  - Commands with external dependencies (`quickscan`, `http-server`, `https-server`) emit actionable error messages when prerequisites are missing.
  - Reverse-shell generator `rev-shell` for multiple languages.
  - Archive extraction (`extract`), text search (`findtext`), and other small helpers.
- **User guidance**
  - On shell startup, prints a red-team banner and the message `Type /help for a list of commands.`
  - Defines a `/help` shell function that prints a curated overview of the most important red-team commands and tmux shortcuts.

When modifying this file:
- Keep Warp-specific behavior (`WARP_TERMINAL` checks, prompt branches) intact.
- Keep OPSEC-related history settings (e.g., `hist_ignore_space`) and help messaging intact unless the user explicitly requests changes.
- Respect existing PATH order: Homebrew first, then Python 3.13, then OpenJDK 17, then pdtm and Go-related paths.
- Preserve helper fallback/error guard behavior; prefer compatibility wrappers over removing established helper entrypoints.

## Tmux configuration architecture (`tmux/.tmux.conf`)

The tmux config is focused on Warp compatibility, red-team session management, and integration with external tools.

Key aspects:
- **Terminal/behavior settings**
  - `default-terminal "tmux-256color"` and terminal overrides for truecolor.
  - `set -s escape-time 0` and `set -s focus-events on` for responsive key handling and focus detection (recommended for aliasr and Warp).
  - Mouse mode enabled and history limit increased.
- **Navigation and layout**
  - Vi-style keybindings in copy mode and pane movement (`h/j/k/l`) plus resize bindings (`H/J/K/L`).
  - Splits and new windows default to the current pane path.
- **Status bar theme**
  - Custom “red team” color scheme and powerline-style separators.
- **Recording, logging, and sessions**
  - Asciinema recording toggle on `Prefix + P` (records per-pane casts into `~/Logs`) with fail-soft messaging if `asciinema` is missing.
  - `Prefix + S` saves pane history to `~/Logs` and ensures the log directory exists before write.
  - Session management helpers: `Prefix + N` (new session), `Prefix + p/n` (prev/next window), `Prefix + s` (fzf-based session switcher).
- **Red-team shortcuts and aliasr integration**
  - `Prefix + C-n` – prompt for an `nmap` target and open a new window running `nmap`.
  - `Prefix + C-g` – prompt for a target and run `gobuster` with a default wordlist.
  - `Prefix + C-s` – open a new window running `python3 -m http.server 8080`.
  - **aliasr integration (added for this environment):**
    - `Prefix + U` – split the current window and run `aliasr send -pp` (opens aliasr and sends commands to the previously focused pane without pressing Enter).
    - `Prefix + K` – same as above, but with `-e` to execute the command immediately.

When editing tmux config:
- Preserve the aliasr keybindings and focus/terminal settings unless the user explicitly wants different keys.
- Keep the logging/recording paths stable (`$HOME/Logs`) so references in documentation and `/help` remain accurate.

## Vim configuration architecture (`vim/.vimrc`)

This Vim config is tuned for terminal red-team usage with fail-soft startup behavior when `vim-plug` or plugin-provided functions are unavailable.

High-level layout:
- **Core editor behavior** – sensible defaults for search, indentation, status line, and performance in terminals.
- **Warp-specific handling** – if `TERM_PROGRAM` is `WarpTerminal`, enables truecolor and mouse; otherwise falls back to generic terminal-safe settings.
- **Plugin management** – `plug#begin('~/.vim/plugged')` with:
  - Themes (e.g., `catppuccin`, `dracula`, `molokai`).
  - General utilities (Git integration, commenting, NERDTree, airline, FZF, COC.nvim, language packs).
  - Red-team friendly plugins (markdown tooling for reports, Python indentation, etc.).
- **Plugin bootstrap guards** – plugin manager bootstrap is guarded so startup degrades gracefully if `vim-plug` is not installed.
- **Theme and airline setup** – prefers `catppuccin_mocha` but gracefully falls back to other themes.
- **COC.nvim and language-specific mappings** – LSP-style navigation (`gd`, `gr`, `K`, etc.), format/rename bindings, and Go-specific shortcuts, with guarded fallback behavior when COC functions are unavailable.
- **Red-team operations section** – custom filetype associations (PowerShell, scripts, Dockerfiles, configs, logs), markdown report snippet mappings, and navigation bindings.

Future agents editing Vim config should:
- Keep plugin declarations consistent (no partial deletions that break `Plug` blocks).
- Avoid introducing plugins that assume a GUI; this config is terminal-first.
- Preserve startup guard behavior around plugin bootstrap and plugin-provided function calls.
- Be aware that some plugins (e.g., `vim-instant-markdown`) introduce external dependencies (like `yarn`).

## aliasr tool expectations

The user has installed `aliasr` (a modern TUI launcher for pentest commands) via `pipx`/`uv tool` and integrated it into this environment:
- Zsh: `alias a='aliasr'` provides a short, preferred entrypoint.
- Tmux: `Prefix + U` and `Prefix + K` bindings integrate aliasr with pane splits, as described above.

Guidance for future agents:
- Do **not** remove or rename the `a` alias or the aliasr tmux bindings unless explicitly asked; they are part of the user’s core workflow.
- If you add new aliases or tmux shortcuts that overlap aliasr’s behavior, document how they interact to avoid confusion.
- Do not attempt to manage aliasr’s installation (e.g., running `pipx install`) from this repo; assume the user manages aliasr and its config under `~/.config/aliasr/`.

## How future agents should operate here

- Treat this repo as the **source of truth** for zsh/tmux/vim behavior; avoid editing `~/.zshrc`, `~/.tmux.conf`, or `~/.vimrc` directly since they are symlinks.
- Before large changes, briefly scan `README.md` and `/help` to keep behavior and documentation aligned.
- When adding new red-team helpers, group them logically:
  - Shell aliases/functions in `zsh/.zshrc` under the existing section headings.
  - Tmux shortcuts in `tmux/.tmux.conf` under the appropriate section (navigation, logging, red-team shortcuts).
  - Editor mappings or plugin changes in `vim/.vimrc` under the relevant plugin or keybinding sections.
- There is currently **no automated test or build system** in this repo; validate changes manually by starting new shells/tmux sessions/Vim instances and exercising the affected commands.
