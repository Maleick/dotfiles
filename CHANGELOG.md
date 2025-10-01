# Changelog

All notable changes to the Red Team Dotfiles project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Commit format follows [Conventional Commits](https://conventionalcommits.org/).

## [2.1.0] - 2025-10-01

### 🚀 Features

- **enhanced-ip-detection**: Comprehensive IPv4/IPv6 external IP address detection system
  - `myip4` - Explicit IPv4 address detection
  - `myip6` - IPv6 address detection  
  - `myip-alt` - Alternative IP service (ipinfo.io)
  - `myip-check` - Backup IP service (icanhazip.com)
  - `get_external_ip()` - Function to store IP in $EXTERNAL_IP variable for scripting
- **ip-service-redundancy**: Multiple IP detection services for enhanced reliability
- **scripting-support**: IP variable storage function for automation workflows

### ♻️ Refactoring

- **ip-consistency**: Updated existing `myip` command to explicitly force IPv4 with `-4` flag
- **netinfo-enhancement**: Enhanced `netinfo()` function to show "External IPv4" specifically
- **help-system-updates**: Updated both `/help` command systems with new IP detection commands

### 📚 Documentation

- **readme-enhancement**: Added comprehensive network reconnaissance section to README
- **help-integration**: Updated both inline and comprehensive help systems
- **usage-examples**: Enhanced quick start examples with new IP commands

### 🔧 Maintenance

- **repo-cleanup**: Removed redundant completion and summary documentation files
- **structure-optimization**: Streamlined repository organization for better maintainability

## [2.0.0] - 2024-09-18

### 🚀 Features

- **modular-config**: Complete modular configuration refactor with zinit plugin management
- **cross-platform**: Docker container testing matrix for Ubuntu and Arch Linux
- **warp-integration**: Enhanced Warp Terminal detection and optimization
- **version-automation**: Automated versioning with conventional commits and standard-version
- **security-first**: Comprehensive OPSEC compliance and data protection
- **performance**: Lazy loading plugins with 50% faster startup times
- **testing-framework**: Complete BATS testing suite with CI/CD integration

### ♻️ Refactoring

- **config**: Split monolithic .zshrc into modular system (core, os, plugins, redteam, warp)
- **plugins**: Migrated to zinit with fallback system for manual installation
- **architecture**: Clean separation of concerns with documented dependency graph

### 🛠️ Tools

- **nmap**: Enhanced scanning aliases with comprehensive port testing
- **networking**: Cross-platform network information gathering functions
- **payloads**: Advanced reverse shell generation with multiple languages
- **encoding**: Comprehensive encoding/decoding utilities for red team operations

### 📚 Documentation

- **architecture**: Complete system architecture documentation with dependency graphs
- **testing**: Comprehensive testing framework documentation including container matrix
- **security**: Detailed OPSEC guidelines and security best practices
- **warp-integration**: Project rules for Warp AI integration and terminal optimization

### 🧪 Testing

- **bats**: Complete BATS testing framework with unit, integration, and security tests
- **containers**: Docker testing matrix for Ubuntu 22.04 and Arch Linux
- **github-actions**: Local testing with act for offline GitHub Actions reproduction
- **cross-platform**: Automated testing across macOS and Linux environments

### 🏗️ Build System

- **ci-cd**: Comprehensive GitHub Actions workflow with security scanning
- **pre-commit**: Advanced pre-commit hooks with OPSEC compliance checking
- **makefile**: Professional Makefile with 20+ automated commands
- **versioning**: Automated changelog generation and release artifact creation

### 🔒 Security

- **opsec**: Automatic IP address redaction and sensitive data protection
- **scanning**: Trivy and Gitleaks integration for vulnerability detection
- **compliance**: Automated OPSEC compliance validation in CI/CD pipeline
- **isolation**: Support for per-engagement environment isolation

### ⚙️ Configuration

- **tmux**: Enhanced session recording and red team key bindings
- **vim**: Security-focused plugin configuration with COC.nvim
- **git**: OPSEC-compliant git configuration with secure defaults
- **zsh**: Professional zsh configuration with advanced completion system

### 👷 CI/CD

- **github-actions**: Multi-stage pipeline with lint, test, security, container, and release jobs
- **cross-platform**: Testing matrix across Ubuntu and macOS environments
- **caching**: Intelligent caching for dependencies and build artifacts
- **automation**: Automated release management with conventional commits

## [1.0.0] - 2024-01-01

### Initial Release

- Basic dotfiles configuration for zsh, tmux, and vim
- Simple installation script
- Red team aliases and functions
- macOS and Linux compatibility

---

**Legend**:
- 🚀 Features: New functionality and capabilities
- 🐛 Bug Fixes: Corrections to existing functionality
- 🔒 Security: Security-related improvements
- ⚡ Performance: Performance optimizations
- ♻️ Refactoring: Code restructuring and cleanup
- 📚 Documentation: Documentation improvements
- 🧪 Testing: Test-related changes
- 🏗️ Build System: Build and deployment changes
- 👷 CI/CD: Continuous integration and deployment
- ⚙️ Configuration: Configuration changes
- 🛠️ Tools: Tool additions and updates
- 🔧 Maintenance: General maintenance tasks