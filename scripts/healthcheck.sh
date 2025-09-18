#!/usr/bin/env bash

# Red Team Dotfiles Health Check Script
# Verifies installation integrity and system compatibility

# shellcheck disable=SC2155 # Prefer compact variable declarations for readability
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
LOG_FILE="${LOG_FILE:-$HOME/.dotfiles_healthcheck.log}"
VERBOSE="${VERBOSE:-false}"
EXIT_CODE=0

# Version information
HEALTHCHECK_VERSION="1.0.0"
REQUIRED_BASH_VERSION="4.0"
REQUIRED_ZSH_VERSION="5.0"

# Start logging
exec 2> >(tee -a "$LOG_FILE" >&2)

# Helper functions
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

log_info() {
    log "${CYAN}[INFO]${NC} $1"
}

log_success() {
    log "${GREEN}[✓]${NC} $1"
}

log_warning() {
    log "${YELLOW}[⚠]${NC} $1"
    EXIT_CODE=1
}

log_error() {
    log "${RED}[✗]${NC} $1"
    EXIT_CODE=1
}

verbose_log() {
    if [[ "$VERBOSE" == "true" ]]; then
        log_info "$1"
    fi
}

# Print banner
print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║     Red Team Dotfiles Health Check v$HEALTHCHECK_VERSION    ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Check bash version
check_bash_version() {
    local current_version="${BASH_VERSION%%[^0-9.]*}"
    local required_version="$REQUIRED_BASH_VERSION"
    
    if [[ "$(printf '%s\n' "$required_version" "$current_version" | sort -V | head -n1)" == "$required_version" ]]; then
        log_success "Bash version: $current_version (>= $required_version required)"
    else
        log_warning "Bash version: $current_version (< $required_version required)"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check required tools
check_required_tools() {
    echo -e "\n${CYAN}Checking Required Tools:${NC}"
    
    local required_tools=("zsh" "tmux" "vim" "git" "curl")
    
    for tool in "${required_tools[@]}"; do
        if command_exists "$tool"; then
            local version=$($tool --version 2>&1 | head -n1 || echo "unknown")
            log_success "$tool: installed ($version)"
        else
            log_error "$tool: not installed"
        fi
    done
}

# Check optional tools
check_optional_tools() {
    echo -e "\n${CYAN}Checking Optional Tools:${NC}"
    
    local optional_tools=("fzf" "rg" "asciinema" "shellcheck" "shfmt" "figlet" "lolcat")
    
    for tool in "${optional_tools[@]}"; do
        if command_exists "$tool"; then
            log_success "$tool: installed"
        else
            log_warning "$tool: not installed (optional)"
        fi
    done
}

# Check symlinks
check_symlinks() {
    echo -e "\n${CYAN}Checking Dotfile Symlinks:${NC}"
    
    local dotfiles=(".zshrc" ".tmux.conf" ".vimrc")
    
    for file in "${dotfiles[@]}"; do
        if [[ -L "$HOME/$file" ]]; then
            local target=$(readlink "$HOME/$file")
            if [[ -f "$target" ]]; then
                log_success "$file: linked to $target"
            else
                log_error "$file: broken symlink (target: $target)"
            fi
        elif [[ -f "$HOME/$file" ]]; then
            log_warning "$file: exists but is not a symlink"
        else
            log_error "$file: not found"
        fi
    done
}

# Check environment variables
check_environment() {
    echo -e "\n${CYAN}Checking Environment Variables:${NC}"
    
    # Check shell
    if [[ -n "${SHELL:-}" ]]; then
        log_success "SHELL: $SHELL"
    else
        log_warning "SHELL: not set"
    fi
    
    # Check terminal
    if [[ -n "${TERM:-}" ]]; then
        log_success "TERM: $TERM"
    else
        log_warning "TERM: not set"
    fi
    
    # Check Warp detection
    if [[ "${TERM_PROGRAM:-}" == "WarpTerminal" ]]; then
        log_success "Warp Terminal: detected"
    else
        log_info "Warp Terminal: not detected (using ${TERM_PROGRAM:-standard terminal})"
    fi
    
    # Check PATH for common directories
    if echo "$PATH" | grep -q "/usr/local/bin"; then
        log_success "PATH: includes /usr/local/bin"
    else
        log_warning "PATH: missing /usr/local/bin"
    fi
    
    if [[ -d "/opt/homebrew" ]] && echo "$PATH" | grep -q "/opt/homebrew"; then
        log_success "PATH: includes Homebrew (ARM)"
    elif [[ -d "/usr/local/Homebrew" ]] && echo "$PATH" | grep -q "/usr/local/bin"; then
        log_success "PATH: includes Homebrew (Intel)"
    fi
}

# Check Zsh configuration
check_zsh_config() {
    echo -e "\n${CYAN}Checking Zsh Configuration:${NC}"
    
    if [[ -f "$HOME/.zshrc" ]]; then
        # Check if .zshrc is sourced correctly
        if zsh -c 'source ~/.zshrc 2>/dev/null' ; then
            log_success ".zshrc: loads without errors"
        else
            log_error ".zshrc: has syntax errors"
        fi
        
        # Check for custom functions
        if grep -q "function\|alias" "$HOME/.zshrc" 2>/dev/null; then
            log_success ".zshrc: contains custom functions/aliases"
        else
            log_warning ".zshrc: no custom functions/aliases found"
        fi
    else
        log_error ".zshrc: not found"
    fi
    
    # Check Zsh version
    if command_exists zsh; then
        local zsh_version=$(zsh --version | awk '{print $2}')
        if [[ "$(printf '%s\n' "$REQUIRED_ZSH_VERSION" "$zsh_version" | sort -V | head -n1)" == "$REQUIRED_ZSH_VERSION" ]]; then
            log_success "Zsh version: $zsh_version (>= $REQUIRED_ZSH_VERSION required)"
        else
            log_warning "Zsh version: $zsh_version (< $REQUIRED_ZSH_VERSION required)"
        fi
    fi
}

# Check Tmux configuration
check_tmux_config() {
    echo -e "\n${CYAN}Checking Tmux Configuration:${NC}"
    
    if [[ -f "$HOME/.tmux.conf" ]]; then
        # Check if tmux.conf is valid
        if tmux -f "$HOME/.tmux.conf" list-sessions 2>/dev/null || [[ $? -eq 1 ]]; then
            log_success ".tmux.conf: valid configuration"
        else
            log_error ".tmux.conf: has errors"
        fi
        
        # Check for TPM
        if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
            log_success "Tmux Plugin Manager: installed"
        else
            log_warning "Tmux Plugin Manager: not installed"
        fi
    else
        log_error ".tmux.conf: not found"
    fi
}

# Check Vim configuration
check_vim_config() {
    echo -e "\n${CYAN}Checking Vim Configuration:${NC}"
    
    if [[ -f "$HOME/.vimrc" ]]; then
        # Check if .vimrc is valid
        if vim -N -u "$HOME/.vimrc" +q 2>/dev/null; then
            log_success ".vimrc: valid configuration"
        else
            log_warning ".vimrc: may have issues"
        fi
        
        # Check for vim-plug
        if [[ -f "$HOME/.vim/autoload/plug.vim" ]]; then
            log_success "vim-plug: installed"
        else
            log_warning "vim-plug: not installed"
        fi
        
        # Check for plugin directory
        if [[ -d "$HOME/.vim/plugged" ]] && [[ "$(ls -A $HOME/.vim/plugged 2>/dev/null)" ]]; then
            log_success "Vim plugins: installed"
        else
            log_warning "Vim plugins: not installed"
        fi
    else
        log_error ".vimrc: not found"
    fi
}

# Check Git configuration
check_git_config() {
    echo -e "\n${CYAN}Checking Git Configuration:${NC}"
    
    if command_exists git; then
        local user_name=$(git config --global user.name 2>/dev/null)
        local user_email=$(git config --global user.email 2>/dev/null)
        
        if [[ -n "$user_name" ]]; then
            log_success "Git user.name: $user_name"
        else
            log_warning "Git user.name: not set"
        fi
        
        if [[ -n "$user_email" ]]; then
            log_success "Git user.email: $user_email"
        else
            log_warning "Git user.email: not set"
        fi
        
        # Check for GPG signing
        if git config --global commit.gpgsign 2>/dev/null | grep -q true; then
            log_success "Git commit signing: enabled"
        else
            log_info "Git commit signing: disabled"
        fi
    else
        log_error "Git: not installed"
    fi
}

# Check system resources
check_system_resources() {
    echo -e "\n${CYAN}Checking System Resources:${NC}"
    
    # Check disk space
    local disk_usage=$(df -h "$HOME" | awk 'NR==2 {print $5}' | sed 's/%//')
    if [[ "$disk_usage" -lt 90 ]]; then
        log_success "Disk usage: ${disk_usage}% (healthy)"
    else
        log_warning "Disk usage: ${disk_usage}% (high)"
    fi
    
    # Check memory (macOS specific)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        local mem_pressure=$(memory_pressure | grep "System-wide memory free percentage" | awk '{print $5}' | sed 's/%//')
        if [[ -n "$mem_pressure" ]] && [[ "$mem_pressure" -gt 10 ]]; then
            log_success "Memory free: ${mem_pressure}% (healthy)"
        else
            log_warning "Memory free: ${mem_pressure}% (low)"
        fi
    fi
}

# Check for security issues
check_security() {
    echo -e "\n${CYAN}Checking Security:${NC}"
    
    # Check for plaintext passwords in history
    if history 2>/dev/null | grep -q "password=\|passwd=\|pwd=" 2>/dev/null; then
        log_warning "History: contains potential passwords (consider clearing)"
    else
        log_success "History: no obvious passwords found"
    fi
    
    # Check SSH key permissions
    if [[ -f "$HOME/.ssh/id_rsa" ]]; then
        local perms=$(stat -f %A "$HOME/.ssh/id_rsa" 2>/dev/null || stat -c %a "$HOME/.ssh/id_rsa" 2>/dev/null)
        if [[ "$perms" == "600" ]]; then
            log_success "SSH key permissions: correct (600)"
        else
            log_warning "SSH key permissions: $perms (should be 600)"
        fi
    fi
    
    # Check for .env files
    if find "$HOME" -maxdepth 3 -name ".env" 2>/dev/null | grep -q ".env"; then
        log_warning ".env files found in home directory (review for secrets)"
    else
        log_success "No .env files in immediate home directories"
    fi
}

# Generate report
generate_report() {
    echo -e "\n${CYAN}═══════════════════════════════════════${NC}"
    echo -e "${CYAN}           Health Check Summary         ${NC}"
    echo -e "${CYAN}═══════════════════════════════════════${NC}\n"
    
    if [[ $EXIT_CODE -eq 0 ]]; then
        echo -e "${GREEN}✓ All checks passed successfully!${NC}"
        echo -e "${GREEN}Your Red Team Dotfiles are healthy.${NC}"
    else
        echo -e "${YELLOW}⚠ Some issues were found.${NC}"
        echo -e "${YELLOW}Review the warnings above and consider fixing them.${NC}"
    fi
    
    echo -e "\n${CYAN}Report saved to: $LOG_FILE${NC}"
    echo -e "${CYAN}Run with VERBOSE=true for more details${NC}"
}

# Main execution
main() {
    print_banner
    
    log_info "Starting health check at $(date)"
    log_info "System: $(uname -a)"
    
    check_bash_version
    check_required_tools
    check_optional_tools
    check_symlinks
    check_environment
    check_zsh_config
    check_tmux_config
    check_vim_config
    check_git_config
    check_system_resources
    check_security
    
    generate_report
    
    log_info "Health check completed at $(date)"
    
    exit $EXIT_CODE
}

# Run main function
main "$@"