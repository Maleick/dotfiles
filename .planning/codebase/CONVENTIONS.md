# Coding Conventions

**Analysis Date:** 2026-02-25

## Naming Patterns

**Files:**
- Keep shell config in dotfile names under feature folders: `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`.
- Keep top-level operational files short and conventional: `install.sh`, `README.md`, `CHANGELOG.md`, `VERSION`, `.gitignore`, `AGENTS.md`.
- Keep repository scope minimal as enforced by `.gitignore` exclusions in `.gitignore`.
- Test file naming patterns (`*.test.*`, `*.spec.*`) are `Not detected` in `/opt/dotfiles`.

**Functions:**
- Use lowercase command-style function names in `zsh/.zshrc` (`quickscan`, `extract`, `findtext`, `netinfo`, `get_external_ip`).
- Keep user-facing command aliases short and lowercase in `zsh/.zshrc` (`myip`, `myip6`, `webserver`, `a`).
- Use explicit usage guards and non-zero exits in `zsh/.zshrc` functions (`return 1` on bad args).
- Keep special interactive entrypoints explicit when needed, as shown by `/help` in `zsh/.zshrc`.

**Variables:**
- Use uppercase for exported environment/global variables in `zsh/.zshrc` (`PATH`, `HISTFILE`, `HISTSIZE`, `SAVEHIST`, `HOMEBREW_PREFIX`).
- Use lowercase `local` variables for function internals in `zsh/.zshrc` (`target`, `search_term`, `archive`, `type`, `lhost`, `lport`).
- Keep machine-specific secrets and overrides outside the repo using `~/.zshrc.local`, as loaded at the end of `zsh/.zshrc`.

**Types:**
- Interface/type alias/enum conventions are `Not applicable` for `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, and `install.sh`.

## Code Style

**Formatting:**
- Use sectioned comment banners for major blocks, following `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`.
- Use 4-space indentation inside shell conditionals/functions, matching `zsh/.zshrc` and `install.sh`.
- Keep quotes explicit around paths and variable expansions in shell scripts (`install.sh`, `zsh/.zshrc`).
- Keep cross-platform shell fallbacks inline with stderr suppression where appropriate in `zsh/.zshrc` (`2>/dev/null` patterns).
- Dedicated formatter configuration files (`.prettierrc*`, `eslint.config.*`, `biome.json`) are `Not detected` in `/opt/dotfiles`.

**Linting:**
- Lint tool configuration is `Not detected` in `/opt/dotfiles`.
- Shared lint rule set is `Not detected` in `/opt/dotfiles`.
- Project lint command in repo metadata is `Not detected` in `README.md`, `AGENTS.md`, and `install.sh`.

## Import Organization

**Order:**
1. In `zsh/.zshrc`, place environment/bootstrap exports first (`Homebrew`, `PATH`, shell options).
2. In `zsh/.zshrc`, place shell behavior config next (`setopt`, keybindings, completion, history).
3. In `zsh/.zshrc`, place user command surface next (aliases and helper functions).
4. In `zsh/.zshrc`, place local/optional environment loaders at the end (`~/.zshrc.local`, `/opt/VanguardForge/load_env_from_secrets.sh`).

**Grouping:**
- Keep logical section headers for all major config blocks in `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`.
- Group `Plug` declarations by purpose in `vim/.vimrc` (theme, utilities, language support, red-team specific).
- Group `bind` operations by workflow in `tmux/.tmux.conf` (navigation, status bar, red-team operations).

**Path Aliases:**
- Source code import/path aliases are `Not applicable` for `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, and `install.sh`.

## Error Handling

**Patterns:**
- Use fail-fast shell behavior in executable scripts with `set -e`, as implemented in `install.sh`.
- Validate function arguments early and return `1` with usage text in `zsh/.zshrc`.
- Use safe optional loading with guarded existence checks in `zsh/.zshrc` (`if [[ -f ... ]]; then source ... fi`).
- Use explicit soft-failure (`|| true`) only for optional integrations, as shown in `zsh/.zshrc` VanguardForge loader.

**Error Types:**
- Throw/exception classes are `Not applicable` for `install.sh` and `zsh/.zshrc`.
- Return-code based failure handling is the standard in `install.sh` and `zsh/.zshrc`.
- User-facing failure messages should be plain `echo` output, consistent with `install.sh` and `zsh/.zshrc`.

## Logging

**Framework:**
- Structured logging framework is `Not detected` in `/opt/dotfiles`.
- Runtime output uses shell/tmux primitives (`echo` in `install.sh` and `zsh/.zshrc`, `display-message` in `tmux/.tmux.conf`).

**Patterns:**
- Log install lifecycle actions with concise status lines in `install.sh`.
- Log interactive operator feedback in tmux keybindings via `display-message` in `tmux/.tmux.conf`.
- Keep helper command output directly user-readable in `zsh/.zshrc` without extra wrappers.

## Comments

**When to Comment:**
- Use comments to label operational sections and intent in `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`.
- Use comments for non-obvious command prerequisites (for example HTTPS cert generation in `zsh/.zshrc`).
- Avoid redundant comments for self-evident one-liners; follow the concise style used in `install.sh`.

**JSDoc/TSDoc:**
- JSDoc/TSDoc patterns are `Not applicable` for `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, and `install.sh`.

**TODO Comments:**
- TODO/FIXME/HACK markers are `Not detected` in `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, `install.sh`, `README.md`, and `AGENTS.md`.

## Function Design

**Size:**
- Keep helper functions focused on a single task in `zsh/.zshrc` (scan, decode, extract, network info, reverse-shell generation).
- Prefer small reusable utility wrappers over monolithic logic blocks in `zsh/.zshrc`.

**Parameters:**
- Use positional parameters with explicit count checks in `zsh/.zshrc` (`if (( $# < N )); then ...`).
- Normalize frequently reused values into `local` variables in `zsh/.zshrc` before command execution.

**Return Values:**
- Return explicit non-zero codes for invalid usage in `zsh/.zshrc` and rely on command exit codes for runtime failures.
- Return early on guard failures before side effects, as in `quickscan`, `extract`, `findtext`, and `rev-shell` in `zsh/.zshrc`.

## Module Design

**Exports:**
- Treat `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc` as the source modules; publish them to `$HOME` via symlinks from `install.sh`.
- Keep install orchestration centralized in `install.sh` (`link_file` + symlink flow) rather than duplicating linking logic elsewhere.

**Barrel Files:**
- Barrel export files are `Not applicable` in `/opt/dotfiles`.
- Directory-level module separation is by tool domain only: `zsh/`, `tmux/`, and `vim/`.

---

*Convention analysis: 2026-02-25*
*Update when patterns change*
