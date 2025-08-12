#!/usr/bin/env bash

echo "Copying dotfiles to home directory..."

cp tmux/.tmux.conf ~/.tmux.conf
cp vim/.vimrc ~/.vimrc
cp zsh/.zshrc ~/.zshrc

echo "Done."
