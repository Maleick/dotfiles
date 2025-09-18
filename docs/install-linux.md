# Linux Installation Guide

## Quick Start

```bash
# One-line installation
curl -fsSL https://raw.githubusercontent.com/your-repo/dotfiles/main/bootstrap.sh | bash
```

## Supported Distributions

- **Ubuntu/Debian** (18.04+)
- **Arch Linux** (latest)
- **Fedora/RHEL** (8+)
- **WSL2** (Ubuntu, Debian, Arch)

## Prerequisites

### System Requirements
- Linux kernel 4.0+
- Git 2.20+
- Curl or wget
- sudo privileges

### Install Prerequisites

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install -y git curl zsh build-essential
```

#### Arch Linux
```bash
sudo pacman -Syu
sudo pacman -S git curl zsh base-devel
```

#### Fedora/RHEL
```bash
sudo dnf update
sudo dnf install -y git curl zsh gcc make
```

## Installation Methods

### Method 1: Bootstrap Script (Recommended)

The bootstrap script automatically detects your distribution:

```bash
# Clone repository
git clone https://github.com/your-repo/dotfiles.git /opt/dotfiles

# Run bootstrap script
cd /opt/dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

### Method 2: Manual Installation

#### Ubuntu/Debian Manual Install

```bash
# 1. Clone repository
git clone https://github.com/your-repo/dotfiles.git /opt/dotfiles
cd /opt/dotfiles

# 2. Install dependencies
sudo apt update
sudo apt install -y zsh git tmux vim wget curl build-essential

# 3. Install additional security tools
sudo apt install -y nmap netcat-openbsd dnsutils whois

# 4. Set zsh as default shell
chsh -s $(which zsh)

# 5. Install zinit plugin manager
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# 6. Migrate to modular configuration
make migrate-config

# 7. Reload shell configuration
exec zsh
```

#### Arch Linux Manual Install

```bash
# 1. Clone repository
git clone https://github.com/your-repo/dotfiles.git /opt/dotfiles
cd /opt/dotfiles

# 2. Install dependencies
sudo pacman -S zsh git tmux vim wget curl

# 3. Install AUR helper (yay)
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si
    cd /opt/dotfiles
fi

# 4. Install additional tools
yay -S nmap netcat whois bind-tools

# 5. Set zsh as default shell
chsh -s $(which zsh)

# 6. Install zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# 7. Migrate configuration
make migrate-config && exec zsh
```

#### Fedora/RHEL Manual Install

```bash
# 1. Clone repository
git clone https://github.com/your-repo/dotfiles.git /opt/dotfiles
cd /opt/dotfiles

# 2. Install dependencies
sudo dnf install -y zsh git tmux vim wget curl gcc make

# 3. Install additional tools
sudo dnf install -y nmap netcat whois bind-utils

# 4. Set zsh as default shell
chsh -s $(which zsh)

# 5. Install zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# 6. Migrate configuration
make migrate-config && exec zsh
```

## Post-Installation

### Verify Installation

```bash
# Run health check
make healthcheck

# Run verification script
./verify_install.sh

# Test red team functionality
/rt-help
```

### Expected Output

A successful installation should show:
- ✅ Distribution detected correctly
- ✅ Package manager configured
- ✅ Zsh set as default shell
- ✅ Zinit plugin manager active
- ✅ All red team tools available
- ✅ Cross-platform compatibility verified

## Linux-Specific Features

### Distribution Detection
Automatic detection and configuration for:
- **Ubuntu/Debian**: APT package manager, dpkg tools
- **Arch Linux**: Pacman/AUR, makepkg tools
- **Fedora/RHEL**: DNF/YUM package manager, RPM tools

### Package Manager Integration
Smart package management based on distribution:

```bash
# Universal install function (automatically detects package manager)
install_package git vim tmux

# Distribution-specific commands available
apt_install package-name     # Ubuntu/Debian
pacman_install package-name  # Arch Linux
dnf_install package-name     # Fedora/RHEL
```

### System Tools
Linux-specific aliases and functions:

```bash
# System information
sysinfo
uname -a
lscpu
free -h

# Network tools
ss -tuln
ip route show
```

## WSL2 Specific Setup

### Prerequisites
- Windows 10 build 19041+ or Windows 11
- WSL2 installed and configured
- Ubuntu, Debian, or Arch WSL distribution

### Installation

```bash
# WSL2 is automatically detected by bootstrap script
# No special configuration needed

# Verify WSL environment
uname -r  # Should show WSL2 kernel

# Windows interoperability features will be configured
```

### WSL2 Features
- **Windows PATH Integration**: Access to Windows executables
- **Cross-filesystem Operations**: Seamless file access
- **Performance Optimization**: WSL2-specific optimizations

## Distribution-Specific Notes

### Ubuntu/Debian
- Uses APT package manager
- Snap packages supported
- PPA repositories can be added
- Works with Ubuntu 18.04 LTS through latest releases

### Arch Linux
- Uses Pacman package manager
- AUR (Arch User Repository) integration with yay
- Rolling release model
- Latest packages always available

### Fedora/RHEL
- Uses DNF/YUM package manager
- RPM Fusion repositories supported
- Enterprise Linux compatibility
- SELinux considerations included

## Troubleshooting

### Common Issues

#### Package Manager Issues

**Ubuntu/Debian:**
```bash
# Fix broken packages
sudo apt --fix-broken install

# Update package lists
sudo apt update

# Clear package cache
sudo apt clean
```

**Arch Linux:**
```bash
# Sync package databases
sudo pacman -Syy

# Clear package cache
sudo pacman -Scc

# Fix keyring issues
sudo pacman -S archlinux-keyring
```

**Fedora/RHEL:**
```bash
# Clean dnf cache
sudo dnf clean all

# Update package lists
sudo dnf makecache

# Fix RPM database
sudo rpm --rebuilddb
```

#### Shell Configuration Issues

```bash
# Check current shell
echo $SHELL

# List available shells
cat /etc/shells

# Change shell if needed
chsh -s $(which zsh)

# Reload shell configuration
exec zsh
```

#### Permission Issues

```bash
# Fix ownership
sudo chown -R $USER:$USER /opt/dotfiles

# Make scripts executable
chmod +x /opt/dotfiles/scripts/*.sh

# Fix ~/.local directory
mkdir -p ~/.local/bin
chmod 755 ~/.local/bin
```

#### Network/Connectivity Issues

```bash
# Test internet connectivity
ping -c 4 8.8.8.8

# Test DNS resolution
nslookup github.com

# Check proxy settings
env | grep -i proxy
```

### Performance Issues

#### Slow Startup
```bash
# Profile zsh startup
zsh -xvs 2>&1 | ts -i "%.s" > /tmp/zsh-startup.log

# Check plugin loading times
zinit times

# Debug mode
ZSHRC_DEBUG=1 zsh -l
```

#### Memory Usage
```bash
# Check zsh memory usage
ps aux | grep zsh | awk '{print $4, $11}'

# Monitor resource usage
htop
```

## Advanced Configuration

### Custom Package Lists

Create distribution-specific package lists:

**Ubuntu/Debian** (`~/.config/packages.debian`):
```
nmap
wireshark
burpsuite
metasploit-framework
```

**Arch Linux** (`~/.config/packages.arch`):
```
nmap
wireshark-qt
burpsuite
metasploit
```

### Firewall Configuration

```bash
# Ubuntu/Debian (UFW)
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Arch Linux (iptables)
sudo systemctl enable iptables
# Configure rules as needed

# Fedora/RHEL (firewalld)
sudo systemctl enable firewalld
sudo firewall-cmd --set-default-zone=public
```

### Service Management

```bash
# SystemD services (all distributions)
sudo systemctl status ssh
sudo systemctl enable ssh
sudo systemctl start ssh
```

## Container Integration

### Docker Support
```bash
# Install Docker (Ubuntu/Debian)
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Test container functionality
make test-containers
```

### Podman Support (Fedora/RHEL)
```bash
# Install Podman
sudo dnf install -y podman

# Configure rootless containers
podman system migrate
```

## Maintenance

### Keep Updated

```bash
# Update dotfiles
cd /opt/dotfiles
git pull origin main

# Update system packages
# Ubuntu/Debian:
sudo apt update && sudo apt upgrade

# Arch Linux:
sudo pacman -Syu

# Fedora/RHEL:
sudo dnf update

# Update zinit and plugins
zinit self-update
zinit update
```

### Security Updates

```bash
# Ubuntu/Debian - Security updates only
sudo apt upgrade -s | grep -i security

# Enable automatic security updates
sudo dpkg-reconfigure -plow unattended-upgrades
```

## Next Steps

- Configure [Security Settings](security.md)
- Set up [Development Environment](development.md)
- Explore [Red Team Tools](redteam-tools.md)
- Review [Testing Documentation](testing.md)

## Support

For Linux-specific issues:
1. Check distribution-specific sections above
2. Run `make healthcheck` for diagnostics
3. Check `/tmp/dotfiles-install.log` for detailed logs
4. Submit issues with platform details using our [bug report template](../.github/ISSUE_TEMPLATE/bug_report.md)

---

**Version**: 2.0.0  
**Supported Distributions**: Ubuntu 18.04+, Debian 10+, Arch Linux, Fedora 32+, RHEL 8+  
**Last Updated**: September 2024