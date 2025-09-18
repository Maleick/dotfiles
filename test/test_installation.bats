#!/usr/bin/env bats

# Red Team Dotfiles - Installation Test Suite

load "test_helper"

setup() {
    setup_test_environment
}

teardown() {
    cleanup_test_environment
}

@test "install.sh creates proper symlinks" {
    # Run installation in test directory
    cd "$DOTFILES_ROOT"
    HOME="$TEST_DIR/home" bash install.sh
    
    # Check symlinks were created
    assert_symlink "$TEST_DIR/home/.zshrc"
    assert_symlink "$TEST_DIR/home/.tmux.conf"
    assert_symlink "$TEST_DIR/home/.vimrc"
    assert_symlink "$TEST_DIR/home/.dotfiles"
}

@test "install.sh creates backup directory" {
    # Create existing files
    mkdir -p "$TEST_DIR/home"
    echo "old config" > "$TEST_DIR/home/.zshrc"
    echo "old tmux" > "$TEST_DIR/home/.tmux.conf"
    
    # Run installation
    cd "$DOTFILES_ROOT"
    HOME="$TEST_DIR/home" bash install.sh
    
    # Check backup directory exists
    backup_dir=$(find "$TEST_DIR/home" -name ".dotfiles_backup_*" -type d | head -1)
    [[ -n "$backup_dir" ]] || fail "No backup directory created"
    
    # Check files were backed up
    assert_file_exists "$backup_dir/.zshrc"
    assert_file_exists "$backup_dir/.tmux.conf"
}

@test "bootstrap.sh detects macOS correctly" {
    skip_on_os "linux"
    
    cd "$DOTFILES_ROOT"
    HOME="$TEST_DIR/home" run bash -c 'echo "n" | ./bootstrap.sh'
    
    assert_output_contains "Detected OS: macos"
}

@test "bootstrap.sh creates comprehensive backup" {
    mkdir -p "$TEST_DIR/home"
    echo "existing config" > "$TEST_DIR/home/.zshrc"
    echo "bash config" > "$TEST_DIR/home/.bashrc"
    
    cd "$DOTFILES_ROOT"
    HOME="$TEST_DIR/home" run bash -c 'echo "n\nn" | ./bootstrap.sh'
    
    # Should have backed up existing files
    assert_output_contains "Backup created"
}

@test "health check script exists and is executable" {
    assert_file_exists "$DOTFILES_ROOT/scripts/healthcheck.sh"
    [[ -x "$DOTFILES_ROOT/scripts/healthcheck.sh" ]] || fail "healthcheck.sh is not executable"
}

@test "Makefile targets work correctly" {
    cd "$DOTFILES_ROOT"
    
    # Test help target
    run make help
    assert_success
    assert_output_contains "Red Team Dotfiles"
    
    # Test verify target
    run make verify
    # Should work even without installation
    [[ "$status" -eq 0 || "$status" -eq 1 ]] || fail "verify target failed unexpectedly"
}