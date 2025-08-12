#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

DOTFILES_DIR="$(pwd)"
BACKUP_DIR=~/.dotfiles_backup_$(date +%Y%m%d%H%M%S)

echo "Creating backup directory at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Function to create a symlink and backup the old file if it exists.
link_file() {
    local src=$1
    local dest=$2

    if [ -e "$dest" ]; then
        echo "Backing up $dest to $BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR"
    fi

    echo "Linking $src to $dest"
    ln -s "$(readlink -f "$src")" "$dest"
}

echo "Copying dotfiles to home directory..."

# Symlink the main dotfiles directory
ln -sf "$DOTFILES_DIR" ~/.dotfiles

# Symlink individual configuration files
link_file "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf
link_file "$DOTFILES_DIR/vim/.vimrc" ~/.vimrc
link_file "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc

echo "Done."