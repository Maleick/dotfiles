#!/usr/bin/env bash

# Red Team Dotfiles - BATS Test Helper

# Set up test environment
DOTFILES_ROOT="${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
TEST_DIR="${TEST_DIR:-$(mktemp -d)}"

# Export for use in tests
export DOTFILES_ROOT
export TEST_DIR

# Clean up function
teardown_test_dir() {
    if [[ -n "$TEST_DIR" && "$TEST_DIR" != "/" ]]; then
        rm -rf "$TEST_DIR"
    fi
}

# Create test home directory
setup_test_home() {
    export HOME="$TEST_DIR/home"
    mkdir -p "$HOME"
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.ssh"
    
    # Create minimal shell environment
    export SHELL="/bin/bash"
    export TERM="xterm-256color"
    export PATH="/usr/local/bin:/usr/bin:/bin"
}

# Create test dotfiles
setup_test_dotfiles() {
    local test_dotfiles_dir="$TEST_DIR/dotfiles"
    mkdir -p "$test_dotfiles_dir"
    
    # Copy current dotfiles to test location
    if [[ -d "$DOTFILES_ROOT" ]]; then
        cp -r "$DOTFILES_ROOT"/* "$test_dotfiles_dir/"
    fi
    
    export TEST_DOTFILES_DIR="$test_dotfiles_dir"
}

# Mock external commands that might not exist in test environment
mock_command() {
    local cmd="$1"
    local mock_script="$2"
    
    mkdir -p "$TEST_DIR/bin"
    cat > "$TEST_DIR/bin/$cmd" << EOF
#!/bin/bash
$mock_script
EOF
    chmod +x "$TEST_DIR/bin/$cmd"
    export PATH="$TEST_DIR/bin:$PATH"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Skip test if command not available
skip_if_no_command() {
    local cmd="$1"
    if ! command_exists "$cmd"; then
        skip "Command '$cmd' not available"
    fi
}

# Skip test on specific OS
skip_on_os() {
    local os="$1"
    case "$OSTYPE" in
        darwin*)
            if [[ "$os" == "macos" ]]; then
                skip "Skipping on macOS"
            fi
            ;;
        linux*)
            if [[ "$os" == "linux" ]]; then
                skip "Skipping on Linux"
            fi
            ;;
    esac
}

# Assert file exists
assert_file_exists() {
    local file="$1"
    [[ -f "$file" ]] || fail "File '$file' does not exist"
}

# Assert file is symlink
assert_symlink() {
    local file="$1"
    [[ -L "$file" ]] || fail "File '$file' is not a symlink"
}

# Assert file contains string
assert_file_contains() {
    local file="$1"
    local pattern="$2"
    
    assert_file_exists "$file"
    grep -q "$pattern" "$file" || fail "File '$file' does not contain '$pattern'"
}

# Assert output contains string (BATS variables)
assert_output_contains() {
    local pattern="$1"
    # Note: $output is provided by BATS framework
    # shellcheck disable=SC2154
    [[ "$output" == *"$pattern"* ]] || fail "Output does not contain '$pattern'. Got: $output"
}

# Assert exit status (BATS variables)
assert_success() {
    # Note: $status is provided by BATS framework
    # shellcheck disable=SC2154
    [[ "$status" -eq 0 ]] || fail "Expected success (exit 0), got exit $status"
}

assert_failure() {
    # Note: $status is provided by BATS framework
    # shellcheck disable=SC2154
    [[ "$status" -ne 0 ]] || fail "Expected failure (non-zero exit), got exit $status"
}

# Mock network commands for testing
setup_network_mocks() {
    # Mock curl
    mock_command "curl" 'echo "192.0.2.1"'
    
    # Mock nmap
    mock_command "nmap" 'echo "Starting Nmap scan"; echo "Host is up"'
    
    # Mock netstat
    mock_command "netstat" 'echo "tcp 0 0 0.0.0.0:80 0.0.0.0:* LISTEN"'
}

# Create fake log files for testing
create_test_logs() {
    mkdir -p "$HOME/Logs"
    echo "Test log entry $(date)" > "$HOME/Logs/test.log"
    echo "Another entry" >> "$HOME/Logs/test.log"
}

# Test OPSEC compliance - check for sensitive data
check_opsec_compliance() {
    local file="$1"
    
    # Check for real IP addresses (not RFC1918 or documentation ranges)
    if grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" "$file" | grep -v -E "(127\.0\.|192\.168\.|10\.|172\.(1[6-9]|2[0-9]|3[01])\.|0\.0\.0\.0|255\.255\.255\.255)"; then
        fail "File '$file' contains non-RFC1918 IP addresses"
    fi
    
    # Check for common secret patterns
    if grep -iE "(password|passwd|secret|token|key)=" "$file"; then
        fail "File '$file' contains potential secrets"
    fi
    
    # Check for hostnames that might be real
    if grep -E "\.(com|org|net|edu|gov)($|[^a-zA-Z])" "$file" | grep -v "example\."; then
        fail "File '$file' contains potential real hostnames"
    fi
}

# Validate shell script syntax
validate_shell_script() {
    local script="$1"
    
    assert_file_exists "$script"
    
    if [[ "$script" == *.sh || "$script" == *.bash ]]; then
        bash -n "$script" || fail "Script '$script' has syntax errors"
    elif [[ "$script" == *.zsh ]]; then
        zsh -n "$script" 2>/dev/null || fail "Script '$script' has syntax errors"
    fi
}

# Color output for better test readability
red() { echo -e "\033[0;31m$*\033[0m"; }
green() { echo -e "\033[0;32m$*\033[0m"; }
yellow() { echo -e "\033[0;33m$*\033[0m"; }
blue() { echo -e "\033[0;34m$*\033[0m"; }

# Test setup hook
setup_test_environment() {
    setup_test_home
    setup_network_mocks
    
    # Ensure clean state
    unset HISTFILE
    export HISTSIZE=0
}

# Test teardown hook
cleanup_test_environment() {
    teardown_test_dir
    
    # Reset environment
    unset TEST_DIR
    unset TEST_DOTFILES_DIR
}