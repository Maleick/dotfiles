# Core Completion System Configuration
# Enhanced completion features for red team tools

# Enable completion features
autoload -Uz compinit

# Speed up compinit by checking cache once per day
if [[ -n ~/.cache/zcompdump(#qN.mh+24) ]]; then
    compinit -d ~/.cache/zcompdump
else
    compinit -C -d ~/.cache/zcompdump
fi

# Completion styling
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}" # colorize completions
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format 'No matches found'
zstyle ':completion:*' group-name ''

# Red team tool specific completions
zstyle ':completion:*:*:nmap:*' file-patterns '*.xml:xml-files *.gnmap:gnmap-files *:all-files'
zstyle ':completion:*:*:gobuster:*' file-patterns '*.txt:wordlists *:all-files'
zstyle ':completion:*:*:ffuf:*' file-patterns '*.txt:wordlists *:all-files'
zstyle ':completion:*:*:wfuzz:*' file-patterns '*.txt:wordlists *:all-files'
zstyle ':completion:*:*:hydra:*' file-patterns '*.txt:wordlists *:all-files'
zstyle ':completion:*:*:john:*' file-patterns '*.txt:wordlists *.hash:hash-files *:all-files'