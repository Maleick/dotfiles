# macOS Specific Configuration
# Platform-specific settings and optimizations for macOS

# Only load if running on macOS
if [[ "$OSTYPE" == darwin* ]]; then
    
    # Homebrew Configuration
    # Auto-configure Homebrew environment on macOS systems
    if [[ -d "/opt/homebrew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d "/usr/local/Homebrew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    # macOS-specific aliases
    alias localip='ipconfig getifaddr en0 2>/dev/null || echo "No en0 interface found"'
    alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
    
    # macOS networking tools
    alias gateway='route -n get default | grep gateway | awk "{print \$2}"'
    alias dnsinfo='scutil --dns | grep nameserver | awk "{print \$3}" | sort -u'
    
    # macOS-specific base64 handling (uses -D for decode instead of -d)
    function base64decode() { echo -n "$1" | base64 -D; }
    
    # macOS system information
    sysinfo() {
        echo "=== macOS System Information ==="
        echo "System Version: $(sw_vers -productVersion)"
        echo "Build: $(sw_vers -buildVersion)"
        echo "Architecture: $(uname -m)"
        echo "Kernel: $(uname -r)"
        echo "Uptime: $(uptime | awk -F, '{print $1}' | awk '{print $3,$4}')"
        echo "Memory: $(vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+):\s+(\d+)/ and printf("%-16s % 16.2f MB\n", "$1:", $2 * $size / 1048576);')"
    }
    
    # Quick access to system logs
    alias syslog='log stream --predicate "processID == 0" --info'
    alias seclog='log show --predicate "category contains \"Security\"" --info --last 1h'
    
    # Network interface information
    netfaces() {
        echo "=== Network Interfaces ==="
        networksetup -listallhardwareports 2>/dev/null || ifconfig -l | tr ' ' '\n' | while read iface; do
            echo "Interface: $iface"
            ifconfig "$iface" 2>/dev/null | grep -E "inet |ether " | sed 's/^/  /'
        done
    }
    
    # macOS-specific path additions
    export PATH="/usr/local/sbin:$PATH"
    export PATH="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources:$PATH"
    
    # Homebrew environment (repeated for reliability)
    if command -v brew &> /dev/null; then
        eval "$(brew shellenv)"
    fi
    
fi