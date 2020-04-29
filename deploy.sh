# !/usr/bin/env bash
#
# deploy.sh version: 1.0
# author: Maleick
# date: 4/29/20

# Oh My ZSH install and plugins
# curl all the things
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh-autosuggestions
# Fish-like fast/unobtrusive autosuggestions for zsh.
git clone https://github.com/zsh-users/zsh-autosuggestions.git \
	~ZSH_CUSTOM/plugins/zsh-autosuggestions

# fast-syntax-highlighting
# Feature rich syntax highlighting for Zsh.
git clone https://github.com/zdharma/fast-syntax-highlighting.git \
	~ZSH_CUSTOM/plugins/fast-syntax-highlighting

# dotfiles
git clone https://github.com/Maleick/dotfiles.git \
	/opt/dotfiles

cp /opt/dotfiles/zsh/.zshrc ~
cp /opt/dotfiles/tmux/.tmux.conf ~
cp /opt/dotfiles/vim/.vimrc ~

source ~/.zshrc
