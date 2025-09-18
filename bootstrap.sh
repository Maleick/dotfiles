#!/usr/bin/env bash

# Red Team Dotfiles Bootstrap Script
# Cross-platform installer with automatic OS detection

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# Script configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d%H%M%S)"
LOG_FILE="/tmp/dotfiles_install_$(date +%Y%m%d%H%M%S).log"

# Logging functions
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

log_info() {
    log "${CYAN}[INFO]${NC} $1"
}

log_success() {
    log "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    log "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    log "${RED}[ERROR]${NC} $1"
}

# Banner
print_banner() {
    echo -e "${RED}"
    cat << "EOF"
    ____           __   ______                    
   / __ \___  ____/ /  /_  __/__  ____ _____ ___  
  / /_/ / _ \/ __  /    / / / _ \/ __ `/ __ `__ \ 
 / _, _/  __/ /_/ /    / / /  __/ /_/ / / / / / / 
/_/ |_|\___/\__,_/    /_/  \___/\__,_/_/ /_/ /_/  
                                                   
    ____        __  _____ __         
   / __ \____  / /_/ __(_) /__  _____
  / / / / __ \/ __/ /_/ / / _ \/ ___/
 / /_/ / /_/ / /_/ __/ / /  __(__  ) 
/_____/\____/\__/_/ /_/_/\___/____/  
EOF
    echo -e "${NC}"
    echo -e "${CYAN}Cross-Platform Installer v2.0${NC}"
    echo -e "${YELLOW}===========================================${NC}\n"
}

# OS Detection
detect_os() {
    local os=""
    local distro=""
    local version=""
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        os="linux"
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            distro="$ID"
            version="$VERSION_ID"
        elif command -v lsb_release &> /dev/null; then
            distro=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
            version=$(lsb_release -sr)
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        os="macos"
        version=$(sw_vers -productVersion)
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        os="windows"
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        os="freebsd"
    else
        os="unknown"
    fi
    
    echo "${os}:${distro}:${version}"
}

# Check if running in WSL
is_wsl() {
    if grep -qi microsoft /proc/version 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Install dependencies based on OS
install_dependencies() {
    local os_info="$1"
    local os
    local distro
    os=$(echo "$os_info" | cut -d: -f1)
    distro=$(echo "$os_info" | cut -d: -f2)
    
    log_info "Installing dependencies for ${os} ${distro}..."
    
    case "$os" in
        "macos")
            install_macos_deps
            ;;
        "linux")
            case "$distro" in
                "ubuntu"|"debian")
                    install_debian_deps
                    ;;
                "fedora"|"rhel"|"centos")
                    install_fedora_deps
                    ;;
                "arch"|"manjaro")
                    install_arch_deps
                    ;;
                *)
                    log_warning "Unknown Linux distribution: $distro"
                    install_generic_linux_deps
                    ;;
            esac
            ;;
        *)
            log_error "Unsupported OS: $os"
            exit 1
            ;;
    esac
}

# macOS dependency installation
install_macos_deps() {
    log_info "Setting up macOS dependencies..."
    
    # Install Homebrew if not present
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Install required packages
    log_info "Installing required packages via Homebrew..."
    brew update
    brew install zsh tmux vim git fzf ripgrep shellcheck shfmt
    
    # Install optional packages
    log_info "Installing optional packages..."
    brew install asciinema figlet lolcat || true
    
    log_success "macOS dependencies installed"
}

# Debian/Ubuntu dependency installation
install_debian_deps() {
    log_info "Setting up Debian/Ubuntu dependencies..."
    
    # Update package list
    sudo apt-get update
    
    # Install required packages
    log_info "Installing required packages..."
    sudo apt-get install -y \
        zsh \
        tmux \
        vim \
        git \
        curl \
        wget \
        build-essential
    
    # Install optional packages
    log_info "Installing optional packages..."
    sudo apt-get install -y \
        fzf \
        ripgrep \
        shellcheck \
        asciinema \
        figlet \
        lolcat || true
    
    log_success "Debian/Ubuntu dependencies installed"
}

# Fedora/RHEL dependency installation
install_fedora_deps() {
    log_info "Setting up Fedora/RHEL dependencies..."
    
    # Install required packages
    log_info "Installing required packages..."
    sudo dnf install -y \
        zsh \
        tmux \
        vim \
        git \
        curl \
        wget \
        make \
        gcc
    
    # Install optional packages
    log_info "Installing optional packages..."
    sudo dnf install -y \
        fzf \
        ripgrep \
        ShellCheck \
        asciinema \
        figlet || true
    
    log_success "Fedora/RHEL dependencies installed"
}

# Arch Linux dependency installation
install_arch_deps() {
    log_info "Setting up Arch Linux dependencies..."
    
    # Update package database
    sudo pacman -Sy
    
    # Install required packages
    log_info "Installing required packages..."
    sudo pacman -S --noconfirm \
        zsh \
        tmux \
        vim \
        git \
        curl \
        wget \
        base-devel
    
    # Install optional packages from AUR if yay is available
    if command -v yay &> /dev/null; then
        log_info "Installing optional packages from AUR..."
        yay -S --noconfirm \
            fzf \
            ripgrep \
            shellcheck-bin \
            shfmt \
            asciinema \
            figlet \
            lolcat || true
    fi
    
    log_success "Arch Linux dependencies installed"
}

# Generic Linux fallback
install_generic_linux_deps() {
    log_warning "Attempting generic Linux installation..."
    log_info "Please install the following packages manually:"
    echo "  - zsh"
    echo "  - tmux"
    echo "  - vim"
    echo "  - git"
    echo "  - fzf (optional)"
    echo "  - ripgrep (optional)"
}

# Create backup of existing dotfiles
create_backup() {
    log_info "Creating backup directory at $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    local files=(".zshrc" ".tmux.conf" ".vimrc" ".bashrc" ".bash_profile")
    for file in "${files[@]}"; do
        if [ -e "$HOME/$file" ]; then
            log_info "Backing up $file"
            cp -r "$HOME/$file" "$BACKUP_DIR/" 2>/dev/null || true
        fi
    done
    
    log_success "Backup created at $BACKUP_DIR"
}

# Install dotfiles
install_dotfiles() {
    log_info "Installing dotfiles..."
    
    # Create symlink to dotfiles directory
    if [ -e "$HOME/.dotfiles" ]; then
        rm -rf "$HOME/.dotfiles"
    fi
    ln -sf "$DOTFILES_DIR" "$HOME/.dotfiles"
    
    # Install individual configuration files
    link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    link_file "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
    link_file "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
    
    # Install zsh lib if it exists
    if [ -d "$DOTFILES_DIR/zsh/lib" ]; then
        mkdir -p "$HOME/.config/zsh"
        link_file "$DOTFILES_DIR/zsh/lib" "$HOME/.config/zsh/lib"
    fi
    
    log_success "Dotfiles installed"
}

# Create symlink helper
link_file() {
    local src=$1
    local dest=$2
    
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        log_warning "$dest exists and is not a symlink, backing up..."
        mv "$dest" "$BACKUP_DIR/$(basename "$dest").backup"
    fi
    
    if [ -L "$dest" ]; then
        rm "$dest"
    fi
    
    ln -sf "$src" "$dest"
    log_info "Linked $src -> $dest"
}

# Post-installation setup
post_install() {
    log_info "Running post-installation setup..."
    
    # Install Vim plugins
    if [ -f "$HOME/.vimrc" ]; then
        log_info "Installing Vim plugins..."
        vim +PlugInstall +qall 2>/dev/null || true
    fi
    
    # Install tmux plugin manager
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        log_info "Installing tmux plugin manager..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" 2>/dev/null || true
    fi
    
    # Set zsh as default shell if not already
    if [ "$SHELL" != "$(which zsh)" ]; then
        log_info "Setting zsh as default shell..."
        if command -v chsh &> /dev/null; then
            chsh -s "$(which zsh)" || true
        fi
    fi
    
    log_success "Post-installation complete"
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    local success=true
    
    # Check symlinks
    for file in .zshrc .tmux.conf .vimrc; do
        if [ -L "$HOME/$file" ]; then
            log_success "✓ $file linked correctly"
        else
            log_error "✗ $file not linked"
            success=false
        fi
    done
    
    # Check required commands
    for cmd in zsh tmux vim git; do
        if command -v $cmd &> /dev/null; then
            log_success "✓ $cmd installed"
        else
            log_error "✗ $cmd not found"
            success=false
        fi
    done
    
    if $success; then
        log_success "Installation verified successfully!"
    else
        log_warning "Some issues were found. Please check the log at $LOG_FILE"
    fi
}

# Main installation flow
main() {
    print_banner
    
    log_info "Starting installation at $(date)"
    log_info "Dotfiles directory: $DOTFILES_DIR"
    log_info "Log file: $LOG_FILE"
    
    # Detect OS
    OS_INFO=$(detect_os)
    log_info "Detected OS: $OS_INFO"
    
    if is_wsl; then
        log_info "WSL environment detected"
    fi
    
    # Ask for confirmation
    echo -e "${YELLOW}This will install Red Team dotfiles and dependencies.${NC}"
    echo -e "${YELLOW}Existing files will be backed up to $BACKUP_DIR${NC}"
    read -p "Continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled by user"
        exit 0
    fi
    
    # Create backup
    create_backup
    
    # Install dependencies
    read -p "Install system dependencies? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_dependencies "$OS_INFO"
    fi
    
    # Install dotfiles
    install_dotfiles
    
    # Post-installation setup
    post_install
    
    # Verify installation
    verify_installation
    
    echo
    log_success "Installation complete!"
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${CYAN}Red Team Dotfiles installed successfully!${NC}"
    echo -e "${YELLOW}Please restart your terminal or run:${NC}"
    echo -e "${WHITE}  source ~/.zshrc${NC}"
    echo
    echo -e "${MAGENTA}Type /help for a list of red team commands${NC}"
    echo -e "${GREEN}=========================================${NC}"
    
    log_info "Installation finished at $(date)"
}

# Run main function
main "$@"