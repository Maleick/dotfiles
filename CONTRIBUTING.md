# Contributing to Red Team Dotfiles

🔴 **Thank you for contributing to Red Team Dotfiles!** 🔴

This document provides guidelines and instructions for contributing to this repository. By participating in this project, you agree to abide by its terms.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Security Considerations](#security-considerations)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include:

- **Clear title and description**
- **Steps to reproduce**
- **Expected behavior**
- **Actual behavior**
- **OS and environment details** (use `make verify` output)
- **Relevant logs or screenshots**

### Suggesting Enhancements

Enhancement suggestions are welcome! Please provide:

- **Use case description**
- **Proposed solution**
- **Alternative solutions considered**
- **Additional context**

### Contributing Code

1. **Small fixes** (typos, documentation): Direct PRs are welcome
2. **Features**: Please open an issue first to discuss
3. **Security tools**: Must follow OPSEC guidelines

## Development Setup

### Prerequisites

```bash
# Install development tools
brew install shellcheck shfmt yamllint  # macOS
# or
sudo apt-get install shellcheck shfmt yamllint  # Ubuntu/Debian

# Install pre-commit hooks
pip install pre-commit
pre-commit install

# Verify setup
make dev-setup
```

### Local Development

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles

# Create a feature branch
git checkout -b feature/your-feature-name

# Make changes and test
make test
make lint

# Run full CI locally
make ci-local
```

## Coding Standards

### Shell Scripts

- **Use Bash 4+** for scripts, Zsh for interactive shells
- **Follow Google Shell Style Guide** with exceptions:
  - 4-space indentation
  - Function names in `snake_case`
- **Always use:**
  ```bash
  set -euo pipefail  # For scripts
  setopt PIPE_FAIL   # For Zsh
  ```
- **Quote variables** unless you have a specific reason not to
- **Use `[[ ]]` over `[ ]`** for conditionals
- **Provide helpful error messages**

### File Organization

```
dotfiles/
├── zsh/
│   ├── .zshrc           # Main config
│   └── lib/
│       ├── aliases.zsh   # Aliases
│       ├── functions.zsh # Functions
│       └── redteam.zsh   # Red team specific
├── tmux/
│   ├── .tmux.conf       # Main config
│   └── themes/          # Theme files
├── vim/
│   └── .vimrc          # Vim configuration
├── scripts/            # Helper scripts
├── test/              # Test files
└── docs/              # Documentation
```

### Documentation

- **Update README.md** for user-facing changes
- **Add inline comments** for complex logic
- **Document functions** with usage examples
- **Include OPSEC warnings** for sensitive operations

## Commit Guidelines

We use [Conventional Commits](https://www.conventionalcommits.org/):

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvement
- `test`: Adding missing tests
- `chore`: Changes to build process or auxiliary tools
- `security`: Security improvements or fixes

### Examples

```bash
feat(zsh): add reverse shell generator function

- Supports bash, python, perl, php, nc
- Includes OPSEC warning for production use
- Auto-detects available interpreters

Closes #123

security(tmux): sanitize pane logging output

Remove potentially sensitive environment variables from logged output.
This prevents accidental credential exposure in saved logs.

BREAKING CHANGE: LOG_SENSITIVE env var no longer controls filtering
```

### Commit Signing

We recommend signing commits:

```bash
git config --global user.signingkey YOUR_GPG_KEY
git config --global commit.gpgsign true
```

## Pull Request Process

1. **Update documentation** for any changed functionality
2. **Add tests** for new features
3. **Ensure CI passes** - all checks must be green
4. **Update CHANGELOG.md** following Keep a Changelog format
5. **Request review** from maintainers
6. **Squash commits** before merge if requested

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Security fix
- [ ] Documentation update

## Testing
- [ ] Tested on macOS
- [ ] Tested on Linux
- [ ] Tested on WSL
- [ ] Added unit tests
- [ ] All tests pass locally

## Checklist
- [ ] My code follows the project style guidelines
- [ ] I have performed a self-review
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing unit tests pass locally
- [ ] Any dependent changes have been merged

## OPSEC Considerations
- [ ] No hardcoded credentials or sensitive data
- [ ] No IP addresses or hostnames from real environments
- [ ] Commands are safe for public repositories
- [ ] Logging doesn't expose sensitive information
```

## Security Considerations

### OPSEC Guidelines

1. **Never commit:**
   - Real IP addresses (use RFC1918 or documentation ranges)
   - Actual hostnames or domains
   - API keys, tokens, or passwords
   - Client/employer information
   - Proprietary tools or exploits

2. **Always:**
   - Use placeholder values in examples
   - Add warnings for potentially dangerous commands
   - Consider logging implications
   - Review for information leakage

### Reporting Security Issues

**DO NOT** open public issues for security vulnerabilities. Instead:

1. Email security concerns to: [security@example.com]
2. Use PGP encryption if possible
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Testing

### Running Tests

```bash
# Run all tests
make test

# Run specific test suites
make test-shellcheck  # Linting
make test-install    # Installation tests
make test-security   # Security scans

# Run CI pipeline locally
make ci-local
```

### Writing Tests

- Place tests in `test/` directory
- Use `bats` for shell testing
- Name test files `test_*.bats`
- Include both positive and negative test cases

Example test:

```bash
#!/usr/bin/env bats

@test "reverse shell generator creates valid bash payload" {
    source "${BATS_TEST_DIRNAME}/../zsh/lib/functions.zsh"
    result=$(rev-shell bash 10.10.10.10 4444)
    [[ "$result" == *"bash"* ]]
    [[ "$result" == *"10.10.10.10"* ]]
    [[ "$result" == *"4444"* ]]
}
```

## Release Process

1. Maintainers will handle releases
2. We follow semantic versioning (MAJOR.MINOR.PATCH)
3. Releases are automated via GitHub Actions
4. Changelog is automatically generated from commits

## Getting Help

- 📖 Check the [documentation](docs/)
- 💬 Open a [discussion](https://github.com/yourusername/dotfiles/discussions)
- 🐛 Report [issues](https://github.com/yourusername/dotfiles/issues)
- 📧 Contact maintainers

## Recognition

Contributors will be recognized in:
- [AUTHORS.md](AUTHORS.md)
- Release notes
- Project README

Thank you for helping make Red Team Dotfiles better! 🎯