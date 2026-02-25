# External Integrations

**Analysis Date:** 2026-02-25

## APIs & External Services

**Public IP Lookup Services:**
- `ifconfig.me` - External IPv4/IPv6 lookup for operator utility commands in `zsh/.zshrc` (`myip`, `myip6`, `get_external_ip`, `netinfo`).
  - SDK/Client: `curl` invocations in `zsh/.zshrc`.
  - Auth: Not applicable.
  - Endpoints used: `ifconfig.me` over HTTPS via `curl` in `zsh/.zshrc`.
- `ipinfo.io` - Alternate IP lookup endpoint for redundancy in `zsh/.zshrc` (`myip-alt`).
  - SDK/Client: `curl` invocation in `zsh/.zshrc`.
  - Auth: Not applicable.
  - Endpoints used: `ipinfo.io/ip` in `zsh/.zshrc`.
- `icanhazip.com` - Backup IP lookup endpoint in `zsh/.zshrc` (`myip-check`).
  - SDK/Client: `curl` invocation in `zsh/.zshrc`.
  - Auth: Not applicable.
  - Endpoints used: `icanhazip.com` in `zsh/.zshrc`.

**Plugin Source Hosting:**
- GitHub-hosted Vim plugins - Plugin retrieval/update source for entries declared in `vim/.vimrc` with `Plug 'owner/repo'`.
  - Integration method: `vim-plug` plugin declarations in `vim/.vimrc`.
  - Auth: Not detected.
  - Rate limits: Not detected.

## Data Storage

**Databases:**
- Not detected in repository files (`zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, `install.sh`).
  - Connection: Not detected.
  - Client: Not detected.
  - Migrations: Not applicable.

**File Storage:**
- Local filesystem only.
  - Shell history file in `zsh/.zshrc`: `~/.zsh_history`.
  - Completion cache in `zsh/.zshrc`: `~/.cache/zcompdump`.
  - Vim persistent undo directory in `vim/.vimrc`: `~/.vim/undodir`.
  - Tmux logs and recordings in `tmux/.tmux.conf`: `$HOME/Logs/*.txt` and `$HOME/Logs/*.cast`.
  - Dotfile backups in `install.sh`: `~/.dotfiles_backup_<timestamp>`.

**Caching:**
- Local zsh completion cache via `compinit -d ~/.cache/zcompdump` in `zsh/.zshrc`.
  - Connection: Not applicable.
  - Client: Built-in `zsh` completion subsystem in `zsh/.zshrc`.

## Authentication & Identity

**Auth Provider:**
- Not detected in `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, and `README.md`.
  - Implementation: Not applicable.
  - Token storage: Not applicable.
  - Session management: Not applicable.

**OAuth Integrations:**
- Not detected in `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, and `README.md`.
  - Credentials: Not detected.
  - Scopes: Not applicable.

## Monitoring & Observability

**Error Tracking:**
- None detected in `README.md`, `AGENTS.md`, `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`.
  - DSN: Not detected.
  - Release tracking: Not detected.

**Analytics:**
- None detected in `README.md`, `AGENTS.md`, `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`.

**Logs:**
- Local session/pane capture via `asciinema` and tmux buffers in `tmux/.tmux.conf` (`$HOME/Logs`).
  - Integration: local CLI pipeline (`pipe-pane`, `save-buffer`) in `tmux/.tmux.conf`.

## CI/CD & Deployment

**Hosting:**
- Not applicable - Repository configures local dotfiles only (`install.sh` symlink flow into `$HOME`).
  - Deployment: Manual/local execution of `./install.sh` documented in `README.md`.
  - Environment vars: Not applicable.

**CI Pipeline:**
- None detected.
  - Workflows: Not detected (`.github/` not present in repository listing; `.gitignore` excludes `.github/`).
  - Secrets: Not detected.

## Environment Configuration

**Development:**
- Required env vars: Not detected as required in `README.md`, `zsh/.zshrc`, `install.sh`, and `AGENTS.md`.
- Secrets location: Local override file `$HOME/.zshrc.local` sourced in `zsh/.zshrc`; example variable names are documented in `README.md`.
- Additional secret source: Optional `/opt/VanguardForge/load_env_from_secrets.sh` loader in `zsh/.zshrc`.
- Mock/stub services: Not applicable.

**Staging:**
- Environment-specific differences: Not applicable in the local-only installation model defined by `install.sh` and `README.md`.
- Data: Not applicable in repository-managed files (`zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`).

**Production:**
- Secrets management: Not applicable (no production service deployment detected in `README.md`, `AGENTS.md`, and `install.sh`).
- Failover/redundancy: Not applicable in repository files (`zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, `install.sh`).

## Webhooks & Callbacks

**Incoming:**
- None detected in `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, and `install.sh`.

**Outgoing:**
- Outbound HTTP requests to IP lookup providers are triggered by operator commands in `zsh/.zshrc` (`ifconfig.me`, `ipinfo.io/ip`, `icanhazip.com`).
  - Endpoint: Defined inline in `zsh/.zshrc` aliases/functions.
  - Retry logic: Not detected.

---

*Integration audit: 2026-02-25*
