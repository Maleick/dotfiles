#!/usr/bin/env bash

# Migration Script: Monolithic to Modular Configuration
# Safely transitions from legacy zsh/.zshrc to modular config system

set -euo pipefail

# Configuration
DOTFILES_ROOT="/opt/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_migration_backup_$(date +%Y%m%d_%H%M%S)"
CONFIG_DIR="$DOTFILES_ROOT/config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if running from correct directory
    if [[ ! -d "$DOTFILES_ROOT" ]]; then
        log_error "Dotfiles directory not found at $DOTFILES_ROOT"
        exit 1
    fi
    
    # Check if modular config exists
    if [[ ! -f "$CONFIG_DIR/zshrc.new" ]]; then
        log_error "Modular configuration not found at $CONFIG_DIR/zshrc.new"
        exit 1
    fi
    
    # Check if we're on a supported platform
    case "$OSTYPE" in
        darwin*|linux*)
            log_success "Platform $OSTYPE supported"
            ;;
        *)
            log_warning "Platform $OSTYPE may not be fully supported"
            ;;
    esac
}

# Create backup of current configuration
create_backup() {
    log_info "Creating backup at $BACKUP_DIR..."
    
    mkdir -p "$BACKUP_DIR"
    
    # Backup current dotfiles
    if [[ -f "$HOME/.zshrc" ]]; then
        cp "$HOME/.zshrc" "$BACKUP_DIR/.zshrc"
        log_success "Backed up ~/.zshrc"
    fi
    
    if [[ -f "$HOME/.zsh_history" ]]; then
        cp "$HOME/.zsh_history" "$BACKUP_DIR/.zsh_history"
        log_success "Backed up ~/.zsh_history"
    fi
    
    # Backup any existing symlinks
    for file in .zshrc .tmux.conf .vimrc; do
        if [[ -L "$HOME/$file" ]]; then
            readlink "$HOME/$file" > "$BACKUP_DIR/${file}_symlink_target"
            log_success "Backed up $file symlink target"
        fi
    done
}

# Test modular configuration
test_modular_config() {
    log_info "Testing modular configuration..."
    
    # Test syntax
    if ! zsh -n "$CONFIG_DIR/zshrc.new"; then
        log_error "Syntax error in modular configuration"
        return 1
    fi
    
    # Test loading in subshell
    if ! zsh -c "source '$CONFIG_DIR/zshrc.new' && /help >/dev/null 2>&1"; then
        log_error "Modular configuration failed to load properly"
        return 1
    fi
    
    log_success "Modular configuration passed tests"
}

# Install required dependencies
install_dependencies() {
    log_info "Installing dependencies..."
    
    # Detect package manager and install zsh plugins
    if command -v brew >/dev/null 2>&1; then
        # macOS with Homebrew
        if ! brew list zsh-syntax-highlighting >/dev/null 2>&1; then
            log_info "Installing zsh-syntax-highlighting via Homebrew..."
            brew install zsh-syntax-highlighting
        fi
        
        if ! brew list zsh-autosuggestions >/dev/null 2>&1; then
            log_info "Installing zsh-autosuggestions via Homebrew..."
            brew install zsh-autosuggestions
        fi
    elif command -v apt-get >/dev/null 2>&1; then
        # Ubuntu/Debian
        log_warning "Please install zsh-syntax-highlighting and zsh-autosuggestions manually:"
        log_warning "  sudo apt-get install zsh-syntax-highlighting zsh-autosuggestions"
    elif command -v dnf >/dev/null 2>&1; then
        # Fedora/RHEL
        log_warning "Please install zsh plugins manually:"
        log_warning "  sudo dnf install zsh-syntax-highlighting zsh-autosuggestions"
    elif command -v pacman >/dev/null 2>&1; then
        # Arch Linux
        log_warning "Please install zsh plugins manually:"
        log_warning "  sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions"
    fi
}

# Update symlinks to use modular configuration
update_symlinks() {
    log_info "Updating configuration symlinks..."
    
    # Remove existing zshrc symlink
    if [[ -L "$HOME/.zshrc" ]]; then
        rm "$HOME/.zshrc"
        log_success "Removed existing .zshrc symlink"
    elif [[ -f "$HOME/.zshrc" ]]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        log_success "Moved existing .zshrc to backup"
    fi
    
    # Create new symlink to modular configuration
    ln -sf "$CONFIG_DIR/zshrc.new" "$HOME/.zshrc"
    log_success "Created symlink: ~/.zshrc -> $CONFIG_DIR/zshrc.new"
}

# Verify migration
verify_migration() {
    log_info "Verifying migration..."
    
    # Start new shell and test basic functionality
    if zsh -c "source ~/.zshrc && command -v /help >/dev/null"; then
        log_success "Migration successful - help system available"
    else
        log_error "Migration verification failed"
        return 1
    fi
    
    # Test red team functions
    if zsh -c "source ~/.zshrc && command -v quickscan >/dev/null"; then
        log_success "Red team functions loaded correctly"
    else
        log_warning "Some red team functions may not be available"
    fi
    
    # Test OS-specific functions
    if [[ "$OSTYPE" == darwin* ]]; then
        if zsh -c "source ~/.zshrc && command -v sysinfo >/dev/null"; then
            log_success "macOS-specific functions loaded correctly"
        else
            log_warning "macOS-specific functions may not be available"
        fi
    fi
}

# Print migration summary
print_summary() {
    echo
    log_success "Migration completed successfully!"
    echo
    echo "📋 Migration Summary:"
    echo "  • Backup created: $BACKUP_DIR"
    echo "  • Configuration: ~/.zshrc -> $CONFIG_DIR/zshrc.new"
    echo "  • Architecture: Modular system with lazy loading"
    echo "  • Plugin manager: zinit (auto-installed) with fallback"
    echo
    echo "🚀 Next Steps:"
    echo "  1. Start a new shell session or run: source ~/.zshrc"
    echo "  2. Run /help to see available commands"
    echo "  3. Test red team functions: quickscan, netinfo, etc."
    echo "  4. Check performance with: time zsh -c 'source ~/.zshrc'"
    echo
    echo "📚 Documentation:"
    echo "  • Architecture: $DOTFILES_ROOT/docs/architecture.md"
    echo "  • Security: $DOTFILES_ROOT/docs/security.md"
    echo "  • Project rules: $DOTFILES_ROOT/WARP.md"
    echo
    echo "🔧 Customization:"
    echo "  • Local overrides: ~/.zshrc.local"
    echo "  • Module configs: $CONFIG_DIR/"
    echo
    if [[ -n "${BACKUP_DIR:-}" ]]; then
        echo "🔄 Rollback (if needed):"
        echo "  rm ~/.zshrc && cp $BACKUP_DIR/.zshrc ~/.zshrc"
    fi
    echo
}

# Main execution
main() {
    log_info "Starting Red Team Dotfiles migration to modular architecture..."
    echo
    
    # Run migration steps
    check_prerequisites
    create_backup
    install_dependencies
    test_modular_config
    update_symlinks
    verify_migration
    
    print_summary
}

# Handle interruption gracefully
trap 'log_error "Migration interrupted"; exit 1' INT TERM

# Run main function
main "$@"