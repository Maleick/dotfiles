# Stack Research

**Domain:** Red-team terminal dotfiles and operator environment management
**Researched:** 2026-02-25
**Confidence:** HIGH

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Zsh | 5.8+ | Interactive shell runtime | Mature shell scripting, strong completion and prompt features, existing repo baseline |
| Tmux | 3.2+ | Session and pane orchestration | Stable multiplexer primitives for repeatable operator workflows |
| Vim | 9.x | Terminal-native editor | Fast, scriptable editing and plugin ecosystem aligned with existing config |

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| vim-plug | latest stable | Vim plugin management | Required to install/update plugin set from `vim/.vimrc` |
| fzf | latest stable | Fuzzy discovery/navigation | Used for tmux session switching and vim fuzzy file workflows |
| aliasr | latest stable | Red-team command launcher | Required for `alias a='aliasr'` and tmux split-pane send/execute bindings |

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| shellcheck | Shell linting | Use for targeted `install.sh` and helper-function quality checks |
| shfmt | Shell formatting | Apply selectively to avoid behavior regressions in existing scripts |
| git | Versioned change control | Required for atomic docs/config commits in GSD workflow |

## Installation

```bash
# Core runtime tools (platform package manager)
# zsh tmux vim fzf

# Python package launcher dependency for aliasr (if using pipx/uv workflow)
# pipx install aliasr  OR  uv tool install aliasr

# Vim plugin bootstrap after install
vim +PlugInstall +qall
```

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| Zsh | Fish | Use Fish only if team standard is Fish and POSIX/Zsh compatibility is not required |
| Vim | Neovim | Use Neovim when plugin stack explicitly requires Lua-first workflows |
| vim-plug | lazy.nvim | Prefer lazy.nvim only when migrating editor baseline to Neovim |

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| One-off local edits to `~/.zshrc`/`~/.tmux.conf`/`~/.vimrc` | Creates drift from repository source of truth | Edit repo files and re-run `./install.sh` |
| Committing secret values into dotfiles | Credential exposure risk | External secret store + local override files (`~/.zshrc.local`) |
| Heavy framework abstraction around simple config files | Increases complexity without operator value | Keep direct text config + clear docs |

## Stack Patterns by Variant

**If prioritizing fast local onboarding:**
- Use shell script install (`install.sh`) plus symlinks.
- Because it keeps setup explicit, auditable, and easy to rollback.

**If prioritizing strict reproducibility across hosts:**
- Add validation wrappers and compatibility checks per host class.
- Because command behavior differs across macOS/Linux utility variants.

## Version Compatibility

| Package A | Compatible With | Notes |
|-----------|-----------------|-------|
| tmux 3.2+ | `tmux-256color` + truecolor terminals | Needed for status theme and focus event behavior |
| vim 9.x | vim-plug ecosystem in `vim/.vimrc` | Some plugins require external binaries (for example `fzf`, node/yarn) |
| zsh 5.8+ | plugin sourcing + modern setopt usage | Needed for current prompt/completion setup |

## Sources

- `/opt/dotfiles/.planning/codebase/STACK.md` — repository-specific stack baseline
- `/opt/dotfiles/AGENTS.md` — workflow and compatibility constraints
- `/opt/dotfiles/README.md` — operator-facing prerequisites and usage contracts

---
*Stack research for: red-team terminal dotfiles*
*Researched: 2026-02-25*
