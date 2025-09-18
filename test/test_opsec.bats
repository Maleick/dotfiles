#!/usr/bin/env bats

# Red Team Dotfiles - OPSEC Compliance Test Suite

load "test_helper"

@test "README.md contains no real IP addresses" {
    check_opsec_compliance "$DOTFILES_ROOT/README.md"
}

@test "security documentation exists and is comprehensive" {
    assert_file_exists "$DOTFILES_ROOT/docs/security.md"
    assert_file_contains "$DOTFILES_ROOT/docs/security.md" "OPSEC"
    assert_file_contains "$DOTFILES_ROOT/docs/security.md" "Environment Isolation"
    assert_file_contains "$DOTFILES_ROOT/docs/security.md" "Data Protection"
}

@test "all shell scripts use safe placeholder IPs" {
    # Check all shell scripts for IP address patterns
    find "$DOTFILES_ROOT" -name "*.sh" -o -name "*.bash" -o -name "*.zsh" | while read -r file; do
        # Allow scripts in test directory to have test IPs
        if [[ "$file" == */test/* ]]; then
            continue
        fi
        check_opsec_compliance "$file"
    done
}

@test "configuration files contain no secrets" {
    local config_files=(
        "$DOTFILES_ROOT/zsh/.zshrc"
        "$DOTFILES_ROOT/tmux/.tmux.conf"
        "$DOTFILES_ROOT/vim/.vimrc"
    )
    
    for file in "${config_files[@]}"; do
        if [[ -f "$file" ]]; then
            # Check for password patterns
            if grep -iE "(password|passwd|secret|token|key|api)=" "$file"; then
                fail "Config file '$file' contains potential secrets"
            fi
        fi
    done
}

@test "aliases use safe placeholder values" {
    assert_file_exists "$DOTFILES_ROOT/zsh/lib/aliases.zsh"
    
    # Check that network-related aliases don't have real IPs
    check_opsec_compliance "$DOTFILES_ROOT/zsh/lib/aliases.zsh"
    
    # Ensure myip uses safe service
    assert_file_contains "$DOTFILES_ROOT/zsh/lib/aliases.zsh" "ifconfig.me"
}

@test "history configuration prevents sensitive command logging" {
    assert_file_exists "$DOTFILES_ROOT/zsh/.zshrc"
    
    # Check for OPSEC-compliant history settings
    assert_file_contains "$DOTFILES_ROOT/zsh/.zshrc" "HISTCONTROL"
    assert_file_contains "$DOTFILES_ROOT/zsh/.zshrc" "HISTIGNORE"
}

@test "tmux configuration sanitizes session names" {
    assert_file_exists "$DOTFILES_ROOT/tmux/.tmux.conf"
    
    # Check that tmux config doesn't hardcode sensitive session names
    if grep -E "(client|target|[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})" "$DOTFILES_ROOT/tmux/.tmux.conf" | grep -v -E "(192\.168\.|10\.|127\.0\.)"; then
        fail "Tmux config contains potentially sensitive information"
    fi
}

@test "no hardcoded credentials in any files" {
    # Search for common credential patterns
    if find "$DOTFILES_ROOT" -type f \( -name "*.sh" -o -name "*.bash" -o -name "*.zsh" -o -name "*.conf" -o -name "*.rc" \) -exec grep -l -iE "(password|passwd|secret|token|apikey|api_key)=" {} \; | grep -v test; then
        fail "Found potential hardcoded credentials"
    fi
}

@test "pre-commit hooks prevent IP address leaks" {
    assert_file_exists "$DOTFILES_ROOT/.pre-commit-config.yaml"
    assert_file_contains "$DOTFILES_ROOT/.pre-commit-config.yaml" "check-redacted-ips"
}

@test "bootstrap script sanitizes log files" {
    # Check that bootstrap creates logs in safe location
    assert_file_contains "$DOTFILES_ROOT/bootstrap.sh" "/tmp/dotfiles_install"
    
    # Verify it doesn't log sensitive information
    check_opsec_compliance "$DOTFILES_ROOT/bootstrap.sh"
}

@test "health check script respects privacy" {
    assert_file_exists "$DOTFILES_ROOT/scripts/healthcheck.sh"
    
    # Ensure health check doesn't expose sensitive system info
    if grep -iE "(hostname|whoami|id -u)" "$DOTFILES_ROOT/scripts/healthcheck.sh"; then
        fail "Health check may expose sensitive system information"
    fi
}

@test "documentation examples use safe placeholders" {
    local doc_files=(
        "$DOTFILES_ROOT/README.md"
        "$DOTFILES_ROOT/CONTRIBUTING.md"
        "$DOTFILES_ROOT/docs/security.md"
    )
    
    for file in "${doc_files[@]}"; do
        if [[ -f "$file" ]]; then
            check_opsec_compliance "$file"
        fi
    done
}

@test "CI configuration uses safe test data" {
    assert_file_exists "$DOTFILES_ROOT/.github/workflows/ci.yml"
    check_opsec_compliance "$DOTFILES_ROOT/.github/workflows/ci.yml"
}