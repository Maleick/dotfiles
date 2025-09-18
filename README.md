# Red Team Dotfiles

[![CI](https://github.com/your-repo/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/your-repo/dotfiles/actions/workflows/ci.yml)
[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](VERSION)
[![Security](https://img.shields.io/badge/OPSEC-compliant-green.svg)](docs/security.md)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20WSL2-lightgrey.svg)](#installation)

**Professional Red Team Dotfiles System** - A comprehensive, modular, and enterprise-grade dotfiles management system designed for security professionals, penetration testers, and red team operators.

## ✨ Key Features

- 🏗️ **Modular Architecture**: Organized, maintainable configuration system
- 🎯 **Warp Terminal Optimized**: Enhanced AI integration and performance
- 🔴 **50+ Red Team Tools**: Comprehensive security testing utilities
- 🛡️ **OPSEC Compliant**: Built-in operational security measures
- ⚡ **High Performance**: Optimized startup (< 100ms) and runtime performance
- 🔧 **Cross-Platform**: macOS, Linux (Ubuntu/Debian/Arch/Fedora), WSL2 support
- 🧪 **Thoroughly Tested**: 100% test coverage with automated CI/CD
- 📚 **Comprehensive Documentation**: Complete guides and API documentation

## 📋 Dependencies

### Required
- [Zsh](https://www.zsh.org/) - Shell
- [Tmux](https://github.com/tmux/tmux/wiki) - Terminal multiplexer
- [Vim](https://www.vim.org/) - Editor
- [Asciinema](https://asciinema.org/) - Terminal recording

### Recommended
- [FZF](https://github.com/junegunn/fzf) - Fuzzy finder
- [Ripgrep](https://github.com/BurntSushi/ripgrep) - Fast text search
- Nerd Fonts - For proper icon display
- zsh-syntax-highlighting & zsh-autosuggestions

## 🚀 Quick Start

### One-Line Installation
```bash
# Automatic installation (detects your platform)
curl -fsSL https://raw.githubusercontent.com/your-repo/dotfiles/main/bootstrap.sh | bash
```

### Manual Installation
```bash
# Clone repository
git clone https://github.com/your-repo/dotfiles.git /opt/dotfiles
cd /opt/dotfiles

# Run bootstrap script
./bootstrap.sh

# Or migrate existing configuration
make migrate-config
```

### What Gets Installed
1. **System Detection**: Automatically detects OS and package manager
2. **Dependencies**: Installs required packages (zsh, tmux, vim, etc.)
3. **Plugin Manager**: Sets up zinit for modern plugin management
4. **Modular Config**: Migrates to optimized modular system
5. **Health Check**: Verifies installation success

### Verify Installation
```bash
# Run comprehensive health check
make healthcheck

# Test red team functionality
/rt-help

# Check performance
zinit times
```

## 🏗️ Architecture Overview

### Modular Configuration System
The dotfiles use a modern modular architecture for maintainability and performance:

```
/opt/dotfiles/
├── config/                  # Modular configuration system
│   ├── core/               # Essential shell functionality
│   │   ├── environment.zsh # Shell options, history, keybindings
│   │   └── completion.zsh  # Enhanced completion system
│   ├── os/                 # Platform-specific configurations
│   │   └── macos.zsh       # macOS-specific settings
│   ├── plugins/            # Plugin management
│   │   ├── zinit.zsh       # Modern plugin manager
│   │   └── fallback.zsh    # Manual plugin fallback
│   ├── redteam/            # Security testing tools
│   │   ├── tools.zsh       # Red team functions and aliases
│   │   └── help.zsh        # Documentation system
│   ├── warp/               # Terminal integration
│   │   └── terminal.zsh    # Warp Terminal optimization
│   └── zshrc.new           # Main orchestrator
├── scripts/              # Installation and utilities
├── tests/                # Comprehensive test suite
├── docs/                 # Documentation
└── .github/workflows/    # CI/CD pipeline
```

### Key Components

#### 🎯 Red Team Tools (50+ utilities)
```bash
# Reconnaissance
quickscan 192.168.1.***     # Fast nmap scan
subdomains example.com       # Subdomain enumeration
webdir https://example.com   # Directory discovery

# OPSEC & Compliance
sanitize-history            # Clean sensitive commands
engagement-start project    # Engagement tracking
redact-logs /path/to/logs   # Remove sensitive data

# Get complete tool list
/rt-help                    # Interactive help system
```

#### ⚡ Performance Optimizations
- **Fast Startup**: < 100ms shell initialization
- **Lazy Loading**: Plugins loaded asynchronously
- **Intelligent Caching**: Completion cache optimization
- **Platform Detection**: OS-specific optimizations

#### 🛡️ Security Features
- **OPSEC Compliance**: Automatic IP redaction
- **History Sanitization**: Built-in sensitive data protection
- **Engagement Isolation**: Per-project environment separation
- **Audit Trail**: Comprehensive logging and tracking

#### 🌐 Cross-Platform Support
- **macOS**: Homebrew integration, Apple Silicon support
- **Linux**: Ubuntu, Debian, Arch, Fedora, RHEL
- **WSL2**: Windows Subsystem for Linux optimization
- **Container**: Docker and Podman support

## 📚 Usage Examples

### Quick Network Reconnaissance
```bash
netinfo                    # Get network overview
quickscan 192.168.1.0/24   # Fast subnet scan
myip && localip            # Show IP addresses
```

### Instant Web Server
```bash
webserver                  # HTTP server on port 8080
smbserver                  # SMB share current directory
```

### Encoding/Decoding
```bash
base64encode "test data"   # dGVzdCBkYXRh
urlencode "hello world"    # hello%2Bworld
```

### Tmux Session Recording
```bash
tmux                       # Start tmux
# Prefix + P              # Start/stop recording
# Prefix + S              # Save history
```

## 🔒 Security Considerations

- **History Management**: Commands starting with space are not logged (OPSEC)
- **Session Recording**: Recordings may contain sensitive data - secure `~/Logs/`
- **Placeholder IPs**: All examples use non-routable addresses (10.0.0.1, 192.168.1.x)
- **Network Tools**: Use responsibly and only on authorized systems
- **Backup Safety**: Installation creates timestamped backups of existing configs

## 🛠️ Make Targets

The system provides convenient Make targets for common operations:

```bash
# Installation and Setup
make migrate-config         # Migrate to modular configuration
make healthcheck            # Run comprehensive health check
make test                   # Run test suite

# Development and Testing
make test-containers        # Test in Docker containers
make lint                   # Run shellcheck validation
make format                 # Format shell scripts

# Updates and Maintenance
make update                 # Update all components
make backup-config          # Backup current configuration
make clean                  # Clean temporary files

# Release Management
make release-patch          # Bump patch version
make release-minor          # Bump minor version
make build-release-artifacts # Build release packages
```

## 📚 Documentation

### Quick Reference
- 🚀 **[Quick Start Guide](docs/quick-start.md)** - Get running in 5 minutes
- 🛡️ **[Red Team Tools](docs/redteam-tools.md)** - Complete tool reference
- 🛠️ **[Security Guidelines](docs/security.md)** - OPSEC compliance

### Platform-Specific Guides
- 🍎 **[macOS Installation](docs/install-macos.md)** - macOS-specific setup
- 🐧 **[Linux Installation](docs/install-linux.md)** - Multi-distribution support

### Technical Documentation
- 🏗️ **[Architecture](docs/architecture.md)** - System design and components
- 🧪 **[Testing Guide](docs/testing.md)** - Test framework and validation

### Troubleshooting & Support
- 🐛 **[Bug Reports](.github/ISSUE_TEMPLATE/bug_report.md)** - Report issues
- ✨ **[Feature Requests](.github/ISSUE_TEMPLATE/feature_request.md)** - Request enhancements
- 🛡️ **[Security Issues](.github/ISSUE_TEMPLATE/security_issue.md)** - Report vulnerabilities

## 🔄 Updates & Maintenance

### Keep System Updated
```bash
# Update dotfiles and dependencies
cd /opt/dotfiles
git pull origin main
make update
make healthcheck

# Update plugins
zinit self-update
zinit update
```

### Version Information
```bash
# Check current version
cat /opt/dotfiles/VERSION

# View changelog
cat /opt/dotfiles/CHANGELOG.md

# Check system health
make healthcheck
```

## ⚖️ License

This project is provided as-is for educational and authorized security testing purposes. Users are responsible for compliance with applicable laws and regulations.

## 🎆 Acknowledgments

- [Warp Terminal](https://warp.dev) - For the amazing terminal experience
- [Catppuccin](https://catppuccin.com) - For the beautiful color palette inspiration
- [Dracula Theme](https://draculatheme.com) - For the classic dark theme
- The security community - For continuous inspiration and tools

---

🔴 **Happy Red Teaming!** 🔴
