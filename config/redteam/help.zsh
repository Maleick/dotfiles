# Red Team Help System
# Command reference and documentation for red team operations

# Display help message with available commands
/help() {
    cat << 'EOF'

🔴 Red Team Shell - Available Commands:

🚀 Web Servers:
    http-server / webserver  Start HTTP server (port 8000/8080)
    https-server            Start HTTPS server (requires cert.pem/key.pem)
    smbserver               Start SMB server in current directory
    phpserver [port]        Start PHP development server (default: 8000)

🔍 Network & Scanning:
    nmap-top-ports <target> Quick nmap scan of top 1000 ports
    quickscan <target>      Fast nmap scan (-T4 -F)
    tcpscan <target> [ports] TCP SYN scan with service detection
    udpscan <target>        UDP scan for common services
    myip                    Show external IP address
    localip                 Show local IP address
    netinfo                 Display comprehensive network information
    get_tun0_ip             Show VPN tunnel IP (tun0)
    ports / listening       Show open ports
    netfaces                List network interfaces (macOS)

📜 Encoding/Decoding:
    base64encode <text>     Base64 encode
    base64decode <text>     Base64 decode
    urlencode <text>        URL encode
    urldecode <text>        URL decode
    rot13                   ROT13 cipher
    hexdump <file>          Hexadecimal dump
    md5hash <text>          Generate MD5 hash
    sha1hash <text>         Generate SHA1 hash
    sha256hash <text>       Generate SHA256 hash

🛠️ Red Team Tools:
    rev-shell <type> <lhost> <lport>    Generate reverse shell
        Types: bash, nc, python, perl, php, powershell
    bind-shell <type> <lport>           Generate bind shell
        Types: bash, nc, python
    extract <file>                      Extract various archive formats
    findtext <term> [dir]               Search for text in files
    randstring [length]                 Generate random string (default: 16)
    psgrep <process>                    Find processes by name

📁 File Operations:
    ll, la, l, lt, lh       Enhanced ls variants with colors
    extract <archive>       Universal archive extraction

🖥️ System Information (macOS):
    sysinfo                 Complete system information
    syslog                  Stream system logs
    seclog                  Show security-related logs
    flushdns                Flush DNS cache
    showfiles/hidefiles     Toggle hidden file visibility
    gateway                 Show default gateway
    dnsinfo                 Show DNS server information

🎥 Tmux (if available):
    Prefix + P              Start/Stop asciinema recording
    Prefix + S              Save pane history to ~/Logs/
    Prefix + Ctrl+n         Quick nmap in new window
    Prefix + Ctrl+s         Start HTTP server in new window

📚 Documentation:
    /help                   This help message
    make help               Show available Make targets
    make test               Run test suite
    make verify             Verify installation
    
⚠️  OPSEC Reminders:
    • Commands starting with space are not logged to history
    • Session recordings in ~/Logs/ may contain sensitive data  
    • The ~/.zsh_history file persists 10,000 commands
    • Use authorized testing environments only
    • Maintain proper documentation and approval

📖 Quick Examples:
    rev-shell bash 192.168.1.100 4444
    quickscan 192.168.1.0/24
    base64encode "secret message"
    findtext "password" /var/log
    extract archive.tar.gz
    tcpscan 192.168.1.1 80,443,22

EOF
}

# Show OPSEC reminders
opsec() {
    cat << 'EOF'

🔒 OPSEC Guidelines:

🚨 Critical Rules:
    • Never use real client IPs, hostnames, or domains in examples
    • Use RFC1918 addresses: 10.x.x.x, 172.16-31.x.x, 192.168.x.x
    • Use example.com, test.local, client-demo.internal for domains
    • Commands starting with SPACE are not logged to history
    • Review and sanitize ~/.zsh_history regularly

📝 Documentation:
    • Session recordings stored in ~/Logs/ - review before sharing
    • Tmux pane history can contain sensitive data
    • Use `Prefix + S` to save pane history for reports
    • Maintain engagement logs with proper timestamps

🔐 Environment Isolation:
    • Separate shell history per engagement (HISTFILE)
    • Use dedicated VPN/proxy chains
    • Isolate browser profiles and temp directories
    • Clear clipboard and temp files after engagements

⚡ Quick OPSEC Commands:
    history -c                      Clear current session history
    export HISTFILE=/dev/null       Disable history for session  
    unset HISTFILE                  Stop logging commands
     command                        Run command without logging (space prefix)

📋 Pre-Engagement Checklist:
    □ VPN/proxy chain active
    □ Dedicated environment prepared
    □ Recording/logging configured
    □ Emergency procedures reviewed
    □ Client authorization confirmed

More details in: docs/security.md

EOF
}

# Show quick command reference
commands() {
    cat << 'EOF'

⚡ Quick Command Reference:

Network Recon:        myip | localip | netinfo | quickscan <target>
Port Scanning:        nmap-top-ports <target> | tcpscan <target>
Web Services:         webserver | http-server | smbserver
Reverse Shells:       rev-shell bash <ip> <port>
Encoding:             base64encode/decode | urlencode/decode
File Operations:      extract <file> | findtext <term> <dir>
System Info:          sysinfo | netfaces | ports

EOF
}

# Initialize help system message
echo "Type /help for a list of commands."