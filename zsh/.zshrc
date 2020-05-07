# .zshrc
# maleick
# 05/06/20
#
# Path to your oh-my-zsh installation.
export ZSH="/home/maleick/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="dracula-pro" 

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(fast-syntax-highlighting zsh-autosuggestions) 

source $ZSH/oh-my-zsh.sh
 
# Custom cd
chpwd() ls

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
