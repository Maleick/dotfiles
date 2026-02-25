# Architecture

**Analysis Date:** 2026-02-25

## Pattern Overview

**Overall:** Symlinked dotfiles configuration repository with script-driven bootstrap and runtime-specific configuration modules.

**Key Characteristics:**
- Centralized source-of-truth configs in `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`, linked into `$HOME` by `install.sh`.
- Execution model is startup/config driven (shell/tmux/vim load paths), not long-running application logic.
- Operational helpers (aliases/functions/keybindings) are embedded directly in config files instead of split modules.

## Layers

**Bootstrap Layer:**
- Purpose: Install and update symlink targets in the user environment.
- Location: `install.sh`
- Contains: Backup creation, idempotent linking helper (`link_file`), and symlink orchestration.
- Depends on: Shell utilities (`mkdir`, `mv`, `ln`) and current repository path.
- Used by: Manual operator invocation (`./install.sh` from repository root).

**Shell Runtime Layer:**
- Purpose: Configure Zsh behavior, PATH, completions, prompting, and red-team command helpers.
- Location: `zsh/.zshrc`
- Contains: Environment setup, aliases, shell functions (`quickscan`, `extract`, `rev-shell`, `/help`), optional plugin loaders.
- Depends on: System binaries and optional local files (for example `$HOME/.zshrc.local`, `/opt/VanguardForge/load_env_from_secrets.sh`).
- Used by: Interactive Zsh startup via `~/.zshrc` symlink created by `install.sh`.

**Tmux Runtime Layer:**
- Purpose: Configure terminal multiplexing behavior, keybindings, session controls, and logging helpers.
- Location: `tmux/.tmux.conf`
- Contains: Terminal settings, pane/window navigation mappings, red-team shortcuts, `asciinema`/history capture bindings.
- Depends on: `tmux`, optional `fzf`, and user filesystem paths like `$HOME/Logs`.
- Used by: Tmux server/client startup and config reload (`bind r source-file ~/.tmux.conf`).

**Editor Runtime Layer:**
- Purpose: Configure terminal Vim behavior and plugin-backed editing workflows.
- Location: `vim/.vimrc`
- Contains: Core editor options, plugin declarations (`vim-plug`), language mappings, red-team editing shortcuts.
- Depends on: Vim runtime, `vim-plug`, and plugin ecosystem under `~/.vim/plugged`.
- Used by: Vim startup via `~/.vimrc` symlink created by `install.sh`.

**Documentation and Release Metadata Layer:**
- Purpose: Define operator guidance, version history, and repository-scoped instructions.
- Location: `README.md`, `AGENTS.md`, `CHANGELOG.md`, `VERSION`, `.gitignore`
- Contains: Usage docs, architecture guidance, changelog history, semantic version marker, repository inclusion/exclusion policy.
- Depends on: Not applicable.
- Used by: Human maintainers and automation/orchestrator workflows that read repository docs.

## Data Flow

**Bootstrap Install Flow:**

1. Operator runs `./install.sh` from `/opt/dotfiles`.
2. `install.sh` creates backup directory at `~/.dotfiles_backup_<timestamp>`.
3. Existing targets (`~/.tmux.conf`, `~/.vimrc`, `~/.zshrc`) are moved to backup via `link_file`.
4. Source files `tmux/.tmux.conf`, `vim/.vimrc`, and `zsh/.zshrc` are symlinked into `$HOME`.
5. Interactive tools load linked configs on next startup (`source ~/.zshrc`, tmux restart/reload, Vim restart).

**Interactive Shell Command Flow:**

1. Zsh loads `~/.zshrc` (symlink target `zsh/.zshrc`).
2. Environment and prompt state are initialized (Homebrew/Python/OpenJDK/PATH, completion, history options).
3. User runs an alias/function defined in `zsh/.zshrc` (for example `quickscan`, `netinfo`, `/help`).
4. Function validates arguments when implemented and delegates to external binaries (`nmap`, `curl`, `python3`, `grep`).
5. Output is returned directly to terminal without intermediate service layer.

**Tmux Operational Shortcut Flow:**

1. Tmux loads `tmux/.tmux.conf`.
2. User triggers binding (for example `Prefix + P`, `Prefix + U`, `Prefix + C-n`).
3. Tmux executes inline command (`pipe-pane`, `split-window`, `new-window`, `command-prompt`).
4. Optional artifacts are written to `$HOME/Logs` for recording/history capture.

**State Management:**
- Repository state is file-based in tracked config files (`zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, docs).
- User runtime state is externalized to home-directory files (`~/.zsh_history`, `~/.dotfiles_backup_*`, `$HOME/Logs/*`).
- No in-repo persisted runtime database or service state is detected.

## Key Abstractions

**Symlink Install Primitive (`link_file`):**
- Purpose: Normalize file deployment into `$HOME` while preserving existing user files.
- Examples: `install.sh` (`link_file "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf`, similar calls for Vim/Zsh).
- Pattern: Small procedural helper function used by a single bootstrap script.

**Shell Command Catalog:**
- Purpose: Provide task-focused terminal utilities as aliases and functions.
- Examples: `zsh/.zshrc` (`alias a='aliasr'`, `quickscan()`, `extract()`, `rev-shell()`, `/help()`).
- Pattern: Inline command registry embedded in one monolithic shell config file.

**Keybinding-to-Command Dispatch:**
- Purpose: Map tmux keystrokes to actionable operational commands.
- Examples: `tmux/.tmux.conf` (`bind U split-window "aliasr send -pp"`, `bind C-s ... http.server`, `bind P ... asciinema`).
- Pattern: Declarative keybinding definitions with direct shell command execution.

**Plugin-Declared Editor Capability:**
- Purpose: Compose Vim behavior through plugin declarations and mapping conventions.
- Examples: `vim/.vimrc` (`call plug#begin(...)`, `Plug 'neoclide/coc.nvim'`, `nnoremap`/`au FileType` bindings).
- Pattern: Declarative plugin list plus imperative keymap/autocmd configuration.

## Entry Points

**Installer Entry Point:**
- Location: `install.sh`
- Triggers: Manual execution (`./install.sh`).
- Responsibilities: Back up existing dotfiles and create/update symlinks into `$HOME`.

**Shell Startup Entry Point:**
- Location: `zsh/.zshrc` (loaded via `~/.zshrc`)
- Triggers: Interactive Zsh session start or explicit `source ~/.zshrc`.
- Responsibilities: Initialize environment, options, prompt, completions, aliases/functions, and optional local loaders.

**Tmux Startup/Reload Entry Point:**
- Location: `tmux/.tmux.conf` (loaded via `~/.tmux.conf`)
- Triggers: Tmux startup or `Prefix + r` reload binding.
- Responsibilities: Apply terminal behavior, status UI, navigation bindings, and operational shortcuts.

**Vim Startup Entry Point:**
- Location: `vim/.vimrc` (loaded via `~/.vimrc`)
- Triggers: Vim startup.
- Responsibilities: Apply editor settings, load plugins, and register language/red-team mappings.

## Error Handling

**Strategy:** Fail fast in installer path and degrade gracefully in runtime configs when optional dependencies are unavailable.

**Patterns:**
- `install.sh` uses `set -e` for immediate failure on bootstrap errors and explicit backup before replacement.
- `zsh/.zshrc` performs argument checks in functions (`if (( $# < 1 )) ... return 1`) and guards optional sources with file checks.
- Optional environment loader in `zsh/.zshrc` uses defensive sourcing with `|| true` to avoid blocking shell startup.
- `tmux/.tmux.conf` uses `if-shell` branching for optional tools (for example `fzf` session switcher).
- `vim/.vimrc` uses `silent! colorscheme ...` fallback chain to avoid hard failure when a theme is missing.

## Cross-Cutting Concerns

**Logging:** Bootstrap progress logging is emitted via `echo` in `install.sh`; operational capture is handled via `tmux/.tmux.conf` bindings writing to `$HOME/Logs`.
**Validation:** Input validation exists for several shell helpers in `zsh/.zshrc` through argument-count checks and usage messages.
**Authentication:** Not applicable for repository-internal execution paths in `install.sh`, `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`.

---

*Architecture analysis: 2026-02-25*
