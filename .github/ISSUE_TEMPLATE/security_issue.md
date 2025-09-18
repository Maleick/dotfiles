---
name: Security Issue
about: Report a security vulnerability or OPSEC concern
title: '[SECURITY] '
labels: ['security', 'needs-immediate-triage']
assignees: ''

---

⚠️ **SECURITY DISCLOSURE NOTICE** ⚠️

If this is a critical security vulnerability, please do not file a public issue. Instead, email the maintainers directly.

## Security Issue Description
A clear and concise description of the security concern or vulnerability.

## Issue Type
- [ ] Information disclosure (IP addresses, hostnames, sensitive data in logs)
- [ ] Code injection vulnerability
- [ ] Privilege escalation
- [ ] Unsafe defaults
- [ ] OPSEC violation
- [ ] Credential exposure
- [ ] Other: ___________

## Affected Components
Which parts of the dotfiles system are affected?
- [ ] Installation scripts (bootstrap.sh, install scripts)
- [ ] Configuration files (.zshrc, .vimrc, .tmux.conf)
- [ ] Red team tools/aliases
- [ ] CI/CD pipeline
- [ ] Documentation
- [ ] Other: ___________

## Steps to Reproduce
1. Step one
2. Step two
3. Step three

## Impact Assessment
- **Severity**: [Low/Medium/High/Critical]
- **Affected Users**: [All users/Specific configurations/New installations]
- **Data at Risk**: [Personal/Client/System/None]

## Proposed Solution
If you have ideas for how to fix this issue:

```bash
# Proposed fix or mitigation
```

## Workaround
Is there a temporary workaround users can implement while waiting for a fix?

## Environment
- **OS**: [e.g. macOS 14.0, Ubuntu 22.04]
- **Shell**: [e.g. zsh 5.9]
- **Dotfiles Version**: [e.g. 2.0.0]

## Additional Context
Any other context about the security issue.

---

**Please ensure this report does not contain actual client data, real IP addresses, or sensitive information.**