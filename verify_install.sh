#!/usr/bin/env bash

# Red Team Dotfiles Installation Verification Script
# Comprehensive verification with detailed reporting

# shellcheck disable=SC2034 # Variables used in functions called later
set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="$(cat "$SCRIPT_DIR/VERSION" 2>/dev/null || echo "unknown")"
LOG_FILE="$HOME/verification_$(date +%Y%m%d_%H%M%S).log"
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Statistics
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# Logging function
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

log_check() {
    local status="$1"
    local category="$2"
    local name="$3"
    local message="$4"
    # local details="${5:-}"  # Unused parameter for future expansion
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    case "$status" in
        "PASS")
            log "${GREEN}[✓]${NC} $message"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
            ;;
        "FAIL")
            log "${RED}[✗]${NC} $message"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
            ;;
        "WARN")
            log "${YELLOW}[⚠]${NC} $message"
            WARNING_CHECKS=$((WARNING_CHECKS + 1))
            ;;
        "INFO")
            log "${BLUE}[ℹ]${NC} $message"
            ;;
    esac
    
    # Add to JSON report (simplified)
    echo "$status,$category,$name,$message" >> "$LOG_FILE.checks"
}

# Banner
print_banner() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║      Red Team Dotfiles Installation Verification      ║"
    echo "║                    Version $VERSION                      ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
}

# System information
gather_system_info() {
    log_check "INFO" "system" "os" "Operating System: $(uname -s) $(uname -r)"
    log_check "INFO" "system" "arch" "Architecture: $(uname -m)"
    log_check "INFO" "system" "shell" "Shell: ${SHELL:-unknown}"
    log_check "INFO" "system" "term" "Terminal: ${TERM_PROGRAM:-${TERM:-unknown}}"
}

# Check dotfiles version
check_version() {
    if [[ -f "$SCRIPT_DIR/VERSION" ]]; then
        log_check "PASS" "version" "file" "Version file exists ($VERSION)"
    else
        log_check "FAIL" "version" "file" "Version file missing"
    fi
    
    # Check if version follows semantic versioning
    if [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-.*)?$ ]]; then
        log_check "PASS" "version" "format" "Version follows semantic versioning"
    else
        log_check "WARN" "version" "format" "Version format non-standard: $VERSION"
    fi
}

# Check core files
check_core_files() {
    local core_files=(
        "install.sh:Installation script"
        "bootstrap.sh:Bootstrap script"
        "Makefile:Build automation"
        "README.md:Documentation"
        "CONTRIBUTING.md:Contribution guidelines"
        ".editorconfig:Editor configuration"
        ".pre-commit-config.yaml:Pre-commit hooks"
    )
    
    for file_info in "${core_files[@]}"; do
        local file="${file_info%%:*}"
        local desc="${file_info##*:}"
        
        if [[ -f "$SCRIPT_DIR/$file" ]]; then
            log_check "PASS" "files" "core" "$desc exists ($file)"
            
            # Check if shell scripts are executable
            if [[ "$file" == *.sh ]]; then
                if [[ -x "$SCRIPT_DIR/$file" ]]; then
                    log_check "PASS" "files" "executable" "$file is executable"
                else
                    log_check "FAIL" "files" "executable" "$file is not executable"
                fi
            fi
        else
            log_check "FAIL" "files" "core" "$desc missing ($file)"
        fi
    done
}

# Check directory structure
check_directory_structure() {
    local required_dirs=(
        "zsh:Zsh configuration"
        "tmux:Tmux configuration"
        "vim:Vim configuration"
        "scripts:Helper scripts"
        "test:Test suite"
        "docs:Documentation"
        ".github/workflows:CI/CD workflows"
    )
    
    for dir_info in "${required_dirs[@]}"; do
        local dir="${dir_info%%:*}"
        local desc="${dir_info##*:}"
        
        if [[ -d "$SCRIPT_DIR/$dir" ]]; then
            log_check "PASS" "structure" "directory" "$desc directory exists ($dir)"
        else
            log_check "FAIL" "structure" "directory" "$desc directory missing ($dir)"
        fi
    done
}

# Check symlinks
check_symlinks() {
    local dotfiles=(".zshrc" ".tmux.conf" ".vimrc")
    
    for file in "${dotfiles[@]}"; do
        if [[ -L "$HOME/$file" ]]; then
            local target
            target=$(readlink "$HOME/$file")
            if [[ -f "$target" ]]; then
                log_check "PASS" "symlinks" "valid" "$file correctly linked to $target"
            else
                log_check "FAIL" "symlinks" "broken" "$file is broken symlink (target: $target)"
            fi
        elif [[ -f "$HOME/$file" ]]; then
            log_check "WARN" "symlinks" "not_linked" "$file exists but is not a symlink"
        else
            log_check "FAIL" "symlinks" "missing" "$file not found"
        fi
    done
    
    # Check dotfiles directory symlink
    if [[ -L "$HOME/.dotfiles" ]]; then
        log_check "PASS" "symlinks" "dotfiles_dir" ".dotfiles directory linked"
    else
        log_check "FAIL" "symlinks" "dotfiles_dir" ".dotfiles directory not linked"
    fi
}

# Check tools and dependencies
check_dependencies() {
    local required_tools=("zsh" "tmux" "vim" "git")
    local optional_tools=("fzf" "rg" "shellcheck" "shfmt" "figlet")
    
    for tool in "${required_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            local version
            version=$($tool --version 2>&1 | head -1 || echo "unknown")
            log_check "PASS" "dependencies" "required" "$tool installed ($version)"
        else
            log_check "FAIL" "dependencies" "required" "$tool not installed"
        fi
    done
    
    for tool in "${optional_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            log_check "PASS" "dependencies" "optional" "$tool installed (optional)"
        else
            log_check "WARN" "dependencies" "optional" "$tool not installed (optional)"
        fi
    done
}

# Check configuration syntax
check_syntax() {
    # Check shell scripts
    find "$SCRIPT_DIR" -name "*.sh" -o -name "*.bash" | while read -r script; do
        if bash -n "$script" 2>/dev/null; then
            log_check "PASS" "syntax" "shell" "$(basename "$script") syntax valid"
        else
            log_check "FAIL" "syntax" "shell" "$(basename "$script") has syntax errors"
        fi
    done
    
    # Check Zsh configurations
    if [[ -f "$HOME/.zshrc" ]]; then
        if zsh -n "$HOME/.zshrc" 2>/dev/null; then
            log_check "PASS" "syntax" "zsh" ".zshrc syntax valid"
        else
            log_check "FAIL" "syntax" "zsh" ".zshrc has syntax errors"
        fi
    fi
    
    # Check tmux configuration
    if [[ -f "$HOME/.tmux.conf" ]]; then
        if tmux -f "$HOME/.tmux.conf" list-sessions 2>/dev/null || [[ $? -eq 1 ]]; then
            log_check "PASS" "syntax" "tmux" ".tmux.conf syntax valid"
        else
            log_check "FAIL" "syntax" "tmux" ".tmux.conf has syntax errors"
        fi
    fi
}

# Check security compliance
check_security() {
    # Check for potential secrets
    if find "$SCRIPT_DIR" -type f \( -name "*.sh" -o -name "*.md" -o -name "*.conf" \) -exec grep -l -iE "(password|secret|token|api_?key)=" {} \; 2>/dev/null | grep -v test; then
        log_check "FAIL" "security" "secrets" "Potential secrets found in files"
    else
        log_check "PASS" "security" "secrets" "No obvious secrets found"
    fi
    
    # Check for real IP addresses
    if find "$SCRIPT_DIR" -type f \( -name "*.sh" -o -name "*.md" \) -exec grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" {} \; | grep -v -E "(127\.0\.|192\.168\.|10\.|172\.(1[6-9]|2[0-9]|3[01])\.|0\.0\.0\.0|255\.255\.255\.255|\*\*\*)" 2>/dev/null; then
        log_check "WARN" "security" "ipsec" "Potential real IP addresses found"
    else
        log_check "PASS" "security" "ipsec" "OPSEC-compliant IP usage"
    fi
    
    # Check file permissions
    local sensitive_files=("$HOME/.ssh/id_rsa" "$HOME/.ssh/id_ed25519")
    for key_file in "${sensitive_files[@]}"; do
        if [[ -f "$key_file" ]]; then
            local perms
            perms=$(stat -c %a "$key_file" 2>/dev/null || stat -f %A "$key_file" 2>/dev/null)
            if [[ "$perms" == "600" ]]; then
                log_check "PASS" "security" "permissions" "SSH key permissions correct (600)"
            else
                log_check "WARN" "security" "permissions" "SSH key permissions: $perms (should be 600)"
            fi
        fi
    done
}

# Performance checks
check_performance() {
    # Check startup time
    local zsh_startup_time
    if command -v zsh >/dev/null 2>&1; then
        zsh_startup_time=$(time (zsh -c 'exit') 2>&1 | grep real | awk '{print $2}' || echo "unknown")
        if [[ "$zsh_startup_time" != "unknown" ]]; then
            log_check "INFO" "performance" "startup" "Zsh startup time: $zsh_startup_time"
        fi
    fi
    
    # Check configuration file sizes
    local config_files=("$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.vimrc")
    for config in "${config_files[@]}"; do
        if [[ -f "$config" ]]; then
            local size
            size=$(wc -c < "$config" | tr -d ' ')
            if [[ "$size" -gt 50000 ]]; then
                log_check "WARN" "performance" "filesize" "$(basename "$config") is large (${size} bytes)"
            else
                log_check "PASS" "performance" "filesize" "$(basename "$config") size reasonable (${size} bytes)"
            fi
        fi
    done
}

# Generate recommendations
generate_recommendations() {
    echo -e "\n${CYAN}═══════════════════════════════════════${NC}"
    echo -e "${CYAN}           Recommendations             ${NC}"
    echo -e "${CYAN}═══════════════════════════════════════${NC}\n"
    
    if [[ $FAILED_CHECKS -gt 0 ]]; then
        echo -e "${RED}Critical Issues Found:${NC}"
        echo "• Review the failed checks above"
        echo "• Run './bootstrap.sh' to reinstall if needed"
        echo "• Check file permissions and symlinks"
    fi
    
    if [[ $WARNING_CHECKS -gt 0 ]]; then
        echo -e "\n${YELLOW}Improvements Suggested:${NC}"
        echo "• Install optional tools: make dev-setup"
        echo "• Configure pre-commit hooks: pre-commit install"
        echo "• Consider updating configurations"
    fi
    
    if [[ $FAILED_CHECKS -eq 0 ]] && [[ $WARNING_CHECKS -eq 0 ]]; then
        echo -e "${GREEN}✓ Excellent! Your installation is optimal.${NC}"
        echo "• Consider enabling pre-commit hooks"
        echo "• Keep dotfiles updated: git pull"
    fi
    
    echo -e "\n${BLUE}Next Steps:${NC}"
    echo "• Run health check: make healthcheck"
    echo "• Test functionality: make test"
    echo "• Read security guidelines: docs/security.md"
}

# Generate summary
generate_summary() {
    echo -e "\n${CYAN}═══════════════════════════════════════${NC}"
    echo -e "${CYAN}           Verification Summary         ${NC}"
    echo -e "${CYAN}═══════════════════════════════════════${NC}\n"
    
    echo "Total Checks: $TOTAL_CHECKS"
    echo -e "Passed: ${GREEN}$PASSED_CHECKS${NC}"
    echo -e "Warnings: ${YELLOW}$WARNING_CHECKS${NC}"
    echo -e "Failed: ${RED}$FAILED_CHECKS${NC}"
    
    local score=$(( (PASSED_CHECKS * 100) / TOTAL_CHECKS ))
    echo -e "\nOverall Score: ${BLUE}${score}%${NC}"
    
    if [[ $FAILED_CHECKS -eq 0 ]]; then
        echo -e "\n${GREEN}🎉 Installation verification PASSED!${NC}"
        return 0
    else
        echo -e "\n${RED}⚠️  Installation verification FAILED!${NC}"
        return 1
    fi
}

# Main execution
main() {
    print_banner
    
    # Initialize logging
    log "Red Team Dotfiles Verification - $(date)"
    log "Version: $VERSION"
    log "System: $(uname -a)"
    
    echo "Starting comprehensive verification..."
    echo "Logging to: $LOG_FILE"
    echo
    
    # Run all checks
    gather_system_info
    check_version
    check_core_files
    check_directory_structure
    check_symlinks
    check_dependencies
    check_syntax
    check_security
    check_performance
    
    # Generate output
    generate_recommendations
    local exit_code=0
    generate_summary || exit_code=1
    
    echo -e "\n${BLUE}Verification complete!${NC}"
    echo "Detailed log: $LOG_FILE"
    
    exit $exit_code
}

# Run main function
main "$@"