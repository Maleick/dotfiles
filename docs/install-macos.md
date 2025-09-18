# macOS Installation Guide

## Quick Start

```bash
# One-line installation
curl -fsSL https://raw.githubusercontent.com/your-repo/dotfiles/main/bootstrap.sh | bash
```

## Prerequisites

### System Requirements
- macOS 12.0 (Monterey) or later
- Xcode Command Line Tools
- Admin privileges for Homebrew installation

### Install Prerequisites

```bash
# Install Xcode Command Line Tools
xcode-select --install

# Verify git is available
git --version
```

## Installation Methods

### Method 1: Bootstrap Script (Recommended)

The bootstrap script automatically detects macOS and installs all dependencies:

```bash
# Clone the repository
git clone https://github.com/your-repo/dotfiles.git /opt/dotfiles

# Run the bootstrap script
cd /opt/dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

### Method 2: Manual Installation

If you prefer manual control over the installation process:

```bash
# 1. Clone repository
git clone https://github.com/your-repo/dotfiles.git /opt/dotfiles
cd /opt/dotfiles

# 2. Install Homebrew (if not already installed)
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 3. Install core dependencies
brew install zsh git tmux vim wget curl

# 4. Set zsh as default shell (if needed)
if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/local/bin/zsh" ]; then
    chsh -s $(which zsh)
fi

# 5. Install zinit plugin manager
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# 6. Migrate to modular configuration
make migrate-config

# 7. Source new configuration
source ~/.zshrc
```

## Post-Installation

### Verify Installation

```bash
# Run health check
make healthcheck

# Run verification script
./verify_install.sh

# Test red team aliases
/rt-help
```

### Expected Output

A successful installation should show:
- ✅ Homebrew installed and configured
- ✅ Zsh set as default shell
- ✅ Zinit plugin manager active
- ✅ All red team tools available
- ✅ Warp Terminal integration (if using Warp)

## macOS-Specific Features

### Homebrew Integration
The configuration automatically detects and configures Homebrew paths:
- Intel Macs: `/usr/local/bin/brew`
- Apple Silicon Macs: `/opt/homebrew/bin/brew`

### System Tools
macOS-specific aliases and functions:
```bash
# Quick system information
sysinfo

# Network configuration
networksetup -listallhardwareports

# macOS-specific security tools
system_profiler SPSoftwareDataType
```

### Terminal Integration
Optimized for popular macOS terminals:
- **Warp Terminal**: Enhanced integration with AI features
- **iTerm2**: Custom color schemes and profiles
- **Terminal.app**: Basic compatibility maintained

## Troubleshooting

### Common Issues

#### Homebrew Installation Fails
```bash
# Check system requirements
sw_vers
arch

# Manual Homebrew installation
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
```

#### Shell Not Changing to Zsh
```bash
# Check available shells
cat /etc/shells

# Add zsh if missing
echo $(which zsh) | sudo tee -a /etc/shells

# Change shell
chsh -s $(which zsh)
```

#### Zinit Installation Issues
```bash
# Manual zinit installation
git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git

# Add to zshrc
echo 'source ~/.local/share/zinit/zinit.git/zinit.zsh' >> ~/.zshrc
```

#### Permission Issues
```bash
# Fix common permission issues
sudo chown -R $(whoami):admin /opt/dotfiles
chmod +x /opt/dotfiles/scripts/*.sh
```

### Performance Issues

#### Slow Startup Time
```bash
# Debug startup time
ZSHRC_DEBUG=1 zsh -l

# Profile zsh startup
zsh -xvs 2>&1 | ts -i "%.s" > /tmp/zsh-startup.log

# Check plugin loading
zinit times
```

#### Memory Usage
```bash
# Check zsh memory usage
ps aux | grep zsh

# Profile memory usage during startup
time zsh -c 'source ~/.zshrc; exit'
```

## Advanced Configuration

### Custom Homebrew Casks
Add your preferred applications to `~/.config/Brewfile`:

```ruby
# Essential security tools
cask "wireshark"
cask "burp-suite"
cask "metasploit"

# Development tools
cask "visual-studio-code"
cask "docker"
cask "postman"
```

### macOS Security Settings
Recommended security configurations:

```bash
# Enable FileVault
sudo fdesetup enable

# Configure firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Disable remote login (if not needed)
sudo systemsetup -f -setremotelogin off
```

### Directory Structure
After installation, your dotfiles will be organized as:

```
/opt/dotfiles/
├── config/
│   ├── core/           # Essential shell configuration
│   ├── os/macos.zsh   # macOS-specific settings
│   ├── warp/          # Warp Terminal integration
│   └── redteam/       # Security testing tools
├── scripts/           # Installation and utility scripts
└── docs/             # Documentation and guides
```

## Maintenance

### Keep Updated

```bash
# Update dotfiles
cd /opt/dotfiles
git pull origin main

# Update Homebrew and packages
brew update && brew upgrade

# Update zinit and plugins
zinit self-update
zinit update
```

### Backup Configuration

```bash
# Create backup before major updates
make backup-config

# Backup Homebrew state
brew bundle dump --file=~/Brewfile.backup
```

## Next Steps

- Read the [Architecture Documentation](architecture.md)
- Review [Security Guidelines](security.md) 
- Explore [Red Team Tools Guide](redteam-tools.md)
- Set up [Testing Environment](testing.md)

## Support

If you encounter issues:
1. Check this troubleshooting section
2. Run `make healthcheck` for diagnostics
3. Review logs in `/tmp/dotfiles-install.log`
4. Submit an issue using our [bug report template](../.github/ISSUE_TEMPLATE/bug_report.md)

---

**Version**: 2.0.0  
**Compatible with**: macOS 12.0+  
**Last Updated**: September 2024