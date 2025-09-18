# Warp Terminal Optimizations and Integration
# Configuration specific to Warp Terminal features

# Detect if we're running in Warp
if [[ "$TERM_PROGRAM" == "WarpTerminal" ]]; then
    export WARP_TERMINAL=1
    
    # Optimize for Warp's features
    export DISABLE_AUTO_TITLE="true"
    
    # Warp-specific prompt (simplified since Warp handles directory display)
    PROMPT='%F{red}⚡%f %F{%(#.red.green)}%n%f@%F{blue}%m%f %F{red}$%f '
    
    # Warp Terminal banner
    if command -v figlet &> /dev/null && command -v lolcat &> /dev/null; then
        figlet -f slant "Red Team Shell" | lolcat
    elif command -v figlet &> /dev/null; then
        figlet -f slant "Red Team Shell"
    else
        echo "🔴 Red Team Shell Ready (Warp Terminal Detected)"
    fi
    
    # Warp-specific optimizations
    # Enable mouse support for better integration
    if [[ -n "$WARP_TERMINAL" ]]; then
        # Warp handles mouse integration natively
        export MOUSE_SUPPORT=1
    fi
    
    # Warp AI integration hints
    echo "💡 Tip: Use Warp AI with Ctrl+\` for command assistance"
    echo "📚 Type /help for red team command reference"
    
else
    # Standard terminal prompt with full path
    PROMPT='%F{red}⚡%f %F{%(#.red.green)}%n%f@%F{blue}%m%f %F{cyan}%~%f %F{red}$%f '
    
    # Standard banner for non-Warp terminals
    if command -v figlet &> /dev/null && command -v lolcat &> /dev/null; then
        figlet -f slant "Red Team Shell" | lolcat
    elif command -v figlet &> /dev/null; then
        figlet -f slant "Red Team Shell"
    else
        echo "🔴 Red Team Shell Ready"
    fi
fi

# Common prompt features (right prompt with exit code and job count)
RPROMPT='%(?.. %? %F{red}%B✘%b%f)%(1j. %j %F{yellow}%B⚙%b%f.)'

# Color prompt detection and setup
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Fallback prompt for non-color terminals
if [ "$color_prompt" != yes ]; then
    PROMPT='%n@%m:%~%# '
fi

unset color_prompt force_color_prompt