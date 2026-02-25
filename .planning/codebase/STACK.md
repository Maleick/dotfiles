# Technology Stack

**Analysis Date:** 2026-02-25

## Languages

**Primary:**
- Zsh script language (version Not detected) - Primary shell behavior and red-team helper implementation in `zsh/.zshrc`.
- Bash script language (version Not detected) - Installer automation in `install.sh`.

**Secondary:**
- Vimscript (version Not detected) - Editor behavior, plugins, and mappings in `vim/.vimrc`.
- tmux configuration language (version Not detected) - Terminal multiplexer behavior in `tmux/.tmux.conf`.
- Markdown (version Not applicable) - Project/operator documentation in `README.md`, `AGENTS.md`, and `CHANGELOG.md`.

## Runtime

**Environment:**
- `zsh` runtime (version Not detected) - Required for `zsh/.zshrc`.
- `bash` runtime (version Not detected) - Required by shebang in `install.sh`.
- `tmux` runtime (version Not detected) - Required for `tmux/.tmux.conf`.
- `vim` runtime (version Not detected) - Required for `vim/.vimrc`.
- Python 3.13 path preference configured in `zsh/.zshrc` via `/opt/homebrew/opt/python@3.13/bin`.
- OpenJDK 17 path configured in `zsh/.zshrc` via `/opt/homebrew/opt/openjdk@17/bin`.

**Package Manager:**
- Homebrew (version Not detected) - PATH/bootstrap assumptions in `zsh/.zshrc`.
- `vim-plug` (version Not detected) - Plugin manager entrypoint `plug#begin()` in `vim/.vimrc`.
- Lockfile: Not detected (no lockfile in repository root from `find`/manifest scan).

## Frameworks

**Core:**
- Not applicable - No app/server framework is defined; repository is configuration-driven (`zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`).

**Testing:**
- Not detected - No test runner configuration in repository files; `AGENTS.md` states no automated test/build system.

**Build/Dev:**
- `install.sh` symlink workflow (version Not detected) - Local installation and backup process in `install.sh`.
- `vim-plug` plugin bootstrap (version Not detected) - Plugin installation/update orchestration in `vim/.vimrc`.
- `fzf` install hook via `Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }` in `vim/.vimrc`.

## Key Dependencies

**Critical:**
- `aliasr` (version Not detected) - Core launcher integration via `alias a='aliasr'` in `zsh/.zshrc` and pane bindings in `tmux/.tmux.conf`.
- `curl` (version Not detected) - External IP lookup commands in `zsh/.zshrc`.
- `python3` (version Not detected) - Local HTTP/HTTPS server aliases and URL helpers in `zsh/.zshrc` and tmux binding in `tmux/.tmux.conf`.
- `nmap` (version Not detected) - Scan helper aliases/functions in `zsh/.zshrc` and tmux prompt binding in `tmux/.tmux.conf`.
- `zsh-syntax-highlighting` + `zsh-autosuggestions` (versions Not detected) - Optional runtime plugins sourced in `zsh/.zshrc`.

**Infrastructure:**
- `asciinema` (version Not detected) - Pane recording integration in `tmux/.tmux.conf`.
- `fzf` (version Not detected) - Session switch integration in `tmux/.tmux.conf` and plugin dependency in `vim/.vimrc`.
- Network/system CLIs (`lsof`, `ipconfig`, `route`, `scutil`, `awk`) (versions Not detected) - Helper command dependencies in `zsh/.zshrc`.
- Optional external env loader script `/opt/VanguardForge/load_env_from_secrets.sh` sourced conditionally in `zsh/.zshrc`.

## Configuration

**Environment:**
- Runtime behavior configured through exported shell variables in `zsh/.zshrc` (PATH/HOMEBREW/CPPFLAGS/history/prompt settings).
- Local machine overrides loaded from `$HOME/.zshrc.local` in `zsh/.zshrc`; operator guidance and example keys are in `README.md`.
- Optional secret bootstrap from `/opt/VanguardForge/load_env_from_secrets.sh` in `zsh/.zshrc`.
- Project semantic version is stored in `VERSION`.

**Build:**
- Installation/symlink logic is defined in `install.sh`.
- No build system config detected (`package.json`, `requirements.txt`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Makefile`, `.nvmrc`, `.python-version`, `.env*` all Not detected in repository scan).

## Platform Requirements

**Development:**
- Cross-platform target is documented as macOS/Linux/WSL2 in `README.md`.
- Required interactive tooling is documented in `README.md`: `zsh`, `tmux`, `vim`.
- Several commands are macOS-first with Linux fallbacks in `zsh/.zshrc` (for example `ipconfig` fallback to `ip route`).

**Production:**
- Not applicable - No deployed production service is defined in repository files.
- Operational target is local user dotfile installation in `$HOME` using symlinks from `install.sh` (for `~/.zshrc`, `~/.tmux.conf`, `~/.vimrc`).

---

*Stack analysis: 2026-02-25*
