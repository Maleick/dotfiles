# Red Team Tools Guide

Comprehensive guide to the security testing tools and utilities built into the Red Team Dotfiles system.

## Overview

The Red Team configuration provides a curated collection of tools, aliases, and functions designed specifically for security professionals, penetration testers, and red team operators.

## Getting Started

### Show All Commands
```bash
# Display all available red team tools
/rt-help

# Show specific category
/rt-help recon      # Reconnaissance tools
/rt-help web        # Web application tools
/rt-help post       # Post-exploitation tools
```

## Tool Categories

### 🔍 Reconnaissance & Information Gathering

#### Network Discovery
```bash
# Quick network scan (uses nmap with common ports)
quickscan 192.168.1.***

# Full TCP port scan
fullscan 192.168.1.***

# UDP scan for common services
udpscan 192.168.1.***

# Live host discovery
discover 192.168.1.***/24
```

#### DNS & Domain Intelligence
```bash
# Subdomain enumeration
subdomains example.com

# DNS record enumeration
dnsenum example.com

# DNS bruteforcing
dnsbrute example.com

# Reverse DNS lookup
rdns 192.168.1.***
```

#### Web Application Reconnaissance
```bash
# Directory enumeration
webdir https://example.com

# Technology detection
webtech https://example.com

# CMS detection and scanning
cmsscan https://example.com

# SSL/TLS information
sslscan example.com
```

### 🌐 Web Application Testing

#### Content Discovery
```bash
# Common file/directory discovery
dirsearch https://example.com

# Admin panel finder
adminpanel https://example.com

# Backup file discovery
backups https://example.com

# Configuration file hunting
configs https://example.com
```

#### Vulnerability Assessment
```bash
# Nikto web scanner
webscan https://example.com

# XSS detection
xsstest https://example.com

# SQL injection testing
sqltest "https://example.com/page?id=1"

# Command injection testing
cmdtest "https://example.com/exec?cmd=id"
```

### 🔓 Exploitation & Post-Exploitation

#### Payload Generation
```bash
# Generate reverse shells
revshell 192.168.1.*** 4444

# Create web shells
webshell php

# Generate encoded payloads
encode "payload here" base64

# PowerShell payloads
psrevshell 192.168.1.*** 4444
```

#### Privilege Escalation
```bash
# Linux privilege escalation checks
privesc-linux

# Windows privilege escalation
privesc-windows

# SUID binary finder
findsuid

# Capability enumeration
getcaps
```

#### Persistence & Lateral Movement
```bash
# SSH key management
ssh-keygen-rt

# Create SSH tunnel
tunnel 192.168.1.*** 22 8080

# Port forwarding
portforward 8080 192.168.1.***:80

# Proxy chains setup
proxychains-setup
```

### 📊 Data Analysis & Processing

#### Log Analysis
```bash
# Parse log files for interesting data
logparse /path/to/logfile

# Extract IPs from text
extract-ips file.txt

# Find credentials in files
credgrep /path/to/search

# Hash identification
hashid "hash-here"
```

#### Network Traffic Analysis
```bash
# Monitor network connections
netmon

# Capture traffic
tcpdump-rt interface

# Analyze pcap files
pcap-analysis capture.pcap

# Extract files from pcap
pcap-extract capture.pcap
```

## OPSEC & Operational Security

### History Management
```bash
# Clean sensitive commands from history
sanitize-history

# Disable history for current session
history-off

# Re-enable history
history-on

# Show history sanitization rules
show-sanitize-rules
```

### Data Sanitization
```bash
# Remove IP addresses from files
redact-ips file.txt

# Clean logs of sensitive data
clean-logs /path/to/logs/

# Sanitize screenshots/images
redact-image screenshot.png

# Secure file deletion
secure-delete file.txt
```

### Engagement Management
```bash
# Start new engagement
engagement-start "client-project-2024"

# Switch engagement context
engagement-switch "different-project"

# End engagement (archive data)
engagement-end

# List all engagements
engagement-list
```

## Advanced Features

### Custom Tool Integration

#### Adding Custom Tools
```bash
# Add custom reconnaissance script
echo 'alias mycustomscan="/path/to/custom/scanner.py"' >> ~/.zshrc.local

# Create tool wrapper function
custom-tool() {
    echo "Running custom tool against $1"
    /path/to/tool "$1" | tee -a engagement-logs/$(date +%Y%m%d)-custom.log
}
```

#### Tool Chaining
```bash
# Chain reconnaissance tools
recon-chain() {
    local target="$1"
    echo "Starting reconnaissance chain against $target"
    quickscan "$target"
    subdomains "$target"
    webdir "https://$target"
}
```

### Automation & Scripting

#### Automated Scans
```bash
# Full automated reconnaissance
auto-recon example.com

# Web application assessment
webapp-assess https://example.com

# Network assessment
network-assess 192.168.1.***/24

# Infrastructure assessment
infra-assess example.com
```

#### Report Generation
```bash
# Generate engagement report
generate-report engagement-name

# Create executive summary
exec-summary engagement-name

# Technical findings report
tech-report engagement-name

# Compliance report
compliance-report engagement-name
```

## Tool Configuration

### Environment Variables
```bash
# Set default wordlists location
export RT_WORDLISTS="/usr/share/wordlists"

# Set default output directory
export RT_OUTPUT="$HOME/engagements/current"

# Set default proxy
export RT_PROXY="127.0.0.1:8080"

# Set user agent string
export RT_USER_AGENT="Mozilla/5.0 (compatible; SecurityScanner/1.0)"
```

### Configuration Files
The tools use various configuration files stored in `~/.config/redteam/`:

- `nmap.conf` - Nmap default options
- `gobuster.conf` - Directory enumeration settings
- `nikto.conf` - Web scanner configuration
- `metasploit.rc` - Metasploit resource file

## Platform-Specific Tools

### macOS Specific
```bash
# macOS security assessment
macos-assess

# System information gathering
mac-sysinfo

# Network interface information
mac-netinfo

# Process monitoring
mac-procmon
```

### Linux Specific
```bash
# Linux enumeration
linux-enum

# Container escape checks
container-escape

# Kernel exploit suggestions
kernel-exploits

# Service enumeration
service-enum
```

## Integration with External Tools

### Burp Suite Integration
```bash
# Configure Burp proxy
burp-proxy-setup

# Send to Burp
send-to-burp https://example.com

# Export Burp findings
burp-export findings.xml
```

### Metasploit Integration
```bash
# Quick Metasploit setup
msf-setup

# Generate Metasploit payloads
msf-payload windows/meterpreter/reverse_tcp

# Resource file execution
msf-resource script.rc
```

### Custom Framework Integration
```bash
# Empire integration
empire-setup

# Cobalt Strike integration
cs-setup

# Custom C2 framework
c2-setup framework-name
```

## Security Considerations

### OPSEC Guidelines

1. **Always use placeholder IPs** in examples and documentation
2. **Sanitize logs** before sharing or storing
3. **Use engagement-specific directories** for organization
4. **Clean command history** after sensitive operations
5. **Verify tool output** doesn't contain real client data

### Tool Usage Best Practices

1. **Start with passive reconnaissance**
2. **Progress to active scanning only with authorization**
3. **Document all activities** in engagement logs
4. **Use rate limiting** to avoid detection
5. **Clean up artifacts** after testing

## Troubleshooting

### Common Issues

#### Tool Not Found
```bash
# Check if tool is installed
which nmap

# Install missing tool
install-tool nmap

# Check PATH configuration
echo $PATH
```

#### Permission Issues
```bash
# Fix permissions for custom tools
chmod +x ~/.local/bin/custom-tool

# Check sudo configuration
sudo -l
```

#### Network Issues
```bash
# Test connectivity
connectivity-test

# Check DNS resolution
nslookup example.com

# Verify proxy settings
echo $http_proxy
```

## Tool Updates & Maintenance

### Keeping Tools Updated
```bash
# Update all red team tools
make update-tools

# Update wordlists
update-wordlists

# Refresh tool configurations
refresh-configs

# Check for new tools
check-new-tools
```

### Adding New Tools
```bash
# Install new tool
install-tool toolname

# Configure tool integration
configure-tool toolname

# Test tool integration
test-tool toolname
```

## Examples & Use Cases

### Reconnaissance Workflow
```bash
# Standard recon workflow
target="example.com"
engagement-start "client-$(date +%Y%m%d)"

# Passive reconnaissance
subdomains $target > recon/subdomains.txt
dnsenum $target > recon/dns.txt

# Active scanning (with authorization)
quickscan $target > recon/ports.txt
webdir https://$target > recon/directories.txt

# Generate report
generate-report "initial-recon"
```

### Web Application Testing
```bash
# Web app assessment workflow
webapp="https://example.com"

# Discovery
webdir $webapp
webtech $webapp
adminpanel $webapp

# Vulnerability assessment
webscan $webapp
xsstest $webapp
sqltest "$webapp/page?id=1"

# Generate findings
webapp-report $webapp
```

## Getting Help

### Built-in Help
```bash
# Tool-specific help
/rt-help toolname

# Show all categories
/rt-help categories

# Show OPSEC guidelines
/rt-help opsec

# Show examples
/rt-help examples
```

### Documentation
- [Architecture Documentation](architecture.md)
- [Security Guidelines](security.md)
- [Installation Guides](quick-start.md)
- [Testing Documentation](testing.md)

### Community Resources
- Submit feature requests using our [template](../.github/ISSUE_TEMPLATE/feature_request.md)
- Report security issues using our [security template](../.github/ISSUE_TEMPLATE/security_issue.md)
- Contribute improvements via pull requests

---

**⚠️ LEGAL NOTICE**: These tools are provided for authorized security testing only. Always ensure you have explicit permission before testing any systems you do not own. Unauthorized use of these tools may violate applicable laws.

**Version**: 2.0.0  
**Last Updated**: September 2024  
**Total Tools**: 50+ security testing utilities