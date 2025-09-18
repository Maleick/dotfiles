#!/usr/bin/env zsh
# ============================================================================
# Red Team Aliases - Modular Configuration
# ============================================================================

# Enhanced ls aliases with colors
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -altr'  # sort by time, newest last
alias lh='ls -alh'   # human readable sizes

# Red team specific aliases
alias myip='curl -s ifconfig.me'
# Function instead of alias to handle complex command
localip() {
    ipconfig getifaddr en0 2>/dev/null || ip route get 1 | awk '{print $7}' | head -1
}
alias localip='localip'
alias ports='netstat -tuln'
alias listening='netstat -an | grep LISTEN'
alias webserver='python3 -m http.server 8080'
alias smbserver='impacket-smbserver share . -smb2support'

# Encoding/Decoding aliases
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias rot13='tr a-zA-Z n-za-mN-ZA-M'
alias hexdump='xxd'
alias strings='strings -a'

# Color support aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

# Web Servers - Enhanced
alias http-server='python3 -m http.server'
alias https-server='python3 -m http.server --cert-file=cert.pem --key-file=key.pem'

# Nmap shortcuts
alias nmap-top-ports='nmap -sV -sC --top-ports=1000'

# History alias
alias history="history 0"