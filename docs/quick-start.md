# Quick Start Guide

Get up and running with Red Team Dotfiles in 5 minutes or less.

## One-Line Installation

### macOS
```bash
curl -fsSL https://raw.githubusercontent.com/your-repo/dotfiles/main/bootstrap.sh | bash
```

### Linux (Ubuntu/Debian/Arch/Fedora)
```bash
curl -fsSL https://raw.githubusercontent.com/your-repo/dotfiles/main/bootstrap.sh | bash
```

### WSL2
```bash
curl -fsSL https://raw.githubusercontent.com/your-repo/dotfiles/main/bootstrap.sh | bash
```

## What Happens During Installation

1. **System Detection**: Automatically detects OS and platform
2. **Dependencies**: Installs required packages (git, zsh, tmux, etc.)
3. **Shell Setup**: Sets zsh as default shell
4. **Plugin Manager**: Installs and configures zinit
5. **Configuration**: Migrates to modular configuration system
6. **Verification**: Runs health checks to ensure everything works

## First Steps After Installation

### 1. Verify Installation
```bash
# Run comprehensive health check
make healthcheck

# Quick verification
/rt-help
```

### 2. Explore Red Team Tools
```bash
# Show all available commands
/rt-help

# Quick network scan (example with placeholder IP)
quickscan 192.168.1.***

# Start engagement tracking
engagement-start "project-alpha"
```

### 3. Customize Configuration
```bash
# Edit local overrides (not version controlled)
vim ~/.zshrc.local

# Add custom aliases
echo 'alias mytools="ls ~/tools"' >> ~/.zshrc.local
```

## Essential Commands

### Red Team Utilities
- `/rt-help` - Show all red team commands
- `quickscan <target>` - Fast network reconnaissance
- `webdir <domain>` - Web directory enumeration
- `subdomains <domain>` - Subdomain discovery

### OPSEC Compliance
- `sanitize-history` - Clean sensitive data from history
- `redact-logs` - Remove IP addresses from log files
- `engagement-start <name>` - Start new engagement tracking

### System Management
- `make healthcheck` - Verify system health
- `make update` - Update all components
- `make backup-config` - Backup current configuration

## Platform-Specific Quick Tips

### macOS
```bash
# Check Homebrew installation
brew doctor

# Update all packages
brew update && brew upgrade

# Install additional security tools
brew install --cask wireshark burp-suite
```

### Linux
```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade

# Arch Linux
sudo pacman -Syu

# Fedora/RHEL
sudo dnf update
```

### Warp Terminal Users
Your terminal is automatically detected and optimized. Features include:
- AI integration for command suggestions
- Enhanced prompt with red team context
- Optimized performance settings

## Configuration Structure

After installation, your setup includes:

```
/opt/dotfiles/
├── config/
│   ├── core/           # Essential shell functions
│   ├── os/            # Platform-specific settings
│   ├── plugins/       # Plugin management
│   ├── redteam/       # Security testing tools
│   └── warp/          # Terminal integration
├── scripts/           # Utility scripts
└── docs/             # Documentation
```

## Troubleshooting

### Installation Issues

#### Permission Denied
```bash
sudo chown -R $USER:$USER /opt/dotfiles
chmod +x /opt/dotfiles/scripts/*.sh
```

#### Shell Not Changing
```bash
# Check available shells
cat /etc/shells

# Change shell manually
chsh -s $(which zsh)

# Restart terminal or run
exec zsh
```

#### Plugin Manager Issues
```bash
# Reinstall zinit
rm -rf ~/.local/share/zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
```

### Performance Issues

#### Slow Startup
```bash
# Debug startup time
ZSHRC_DEBUG=1 zsh -l

# Check plugin loading
zinit times
```

#### Memory Usage
```bash
# Monitor zsh processes
ps aux | grep zsh
```

## Getting Help

### Built-in Documentation
- `/rt-help` - Red team command reference
- `make help` - Available make targets
- `man zsh` - Zsh manual

### Online Resources
- [Full Documentation](README.md)
- [Architecture Guide](docs/architecture.md)
- [Security Guidelines](docs/security.md)
- [Platform-Specific Guides](docs/)

### Reporting Issues
1. Run `make healthcheck` for diagnostics
2. Check logs in `/tmp/dotfiles-install.log`
3. Submit detailed bug report using our [issue template](../.github/ISSUE_TEMPLATE/bug_report.md)

## Next Steps

### Learn More
- **Security Professionals**: Read [Security Guidelines](security.md)
- **Developers**: Check [Testing Documentation](testing.md)
- **Platform Users**: See platform-specific guides:
  - [macOS Installation](install-macos.md)
  - [Linux Installation](install-linux.md)

### Customize Your Setup
- **Local Configuration**: Edit `~/.zshrc.local`
- **Custom Tools**: Add scripts to `~/bin/`
- **Engagement Setup**: Use `engagement-start` for project organization

### Stay Updated
```bash
# Weekly maintenance
cd /opt/dotfiles
git pull origin main
make update
make healthcheck
```

## Security Reminder

⚠️ **OPSEC Notice**: This system includes automated OPSEC compliance features, but always:
- Review commands before execution
- Use placeholder IPs in documentation
- Sanitize logs and history regularly
- Keep client data separate from dotfiles

---

**Need More Help?**
- Platform specific: [macOS](install-macos.md) | [Linux](install-linux.md)
- Full documentation: [README.md](../README.md)
- Architecture details: [architecture.md](architecture.md)
- Security guidelines: [security.md](security.md)

**Quick Reference Card**: Save this command for quick access: `/rt-help`