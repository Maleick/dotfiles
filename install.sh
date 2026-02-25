#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

DOTFILES_DIR="$(pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d%H%M%S)"

echo "Creating backup directory at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Function to create a symlink and backup the old file if needed.
link_file() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        local current_target
        current_target="$(readlink "$dest")"
        if [ "$current_target" = "$src" ]; then
            echo "[already linked] $dest -> $src"
            return 0
        fi
    fi

    if [ -L "$dest" ] || [ -e "$dest" ]; then
        echo "[backed up] $dest -> $BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR/"
    fi

    ln -s "$src" "$dest"
    echo "[linked] $dest -> $src"
}

echo "Copying dotfiles to home directory..."

# Symlink the main dotfiles directory
ln -sfn "$DOTFILES_DIR" "$HOME/.dotfiles"
echo "[linked] $HOME/.dotfiles -> $DOTFILES_DIR"

# Symlink individual configuration files
link_file "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

echo "Done."
