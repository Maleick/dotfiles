# Testing Framework Documentation

## Overview

This document describes the comprehensive testing framework for the Red Team Dotfiles project, including cross-platform validation, container testing, and local GitHub Actions reproduction.

## Testing Architecture

### 1. Local Testing (Native)
- **macOS**: Primary development and testing platform
- **Ubuntu**: Via GitHub Actions runners (`ubuntu-latest`)
- **Shell Testing**: BATS framework for unit and integration tests
- **Security Testing**: OPSEC compliance and vulnerability scanning

### 2. Container Testing (Cross-Platform)
- **Ubuntu 22.04 LTS**: Comprehensive Linux testing
- **Arch Linux**: Rolling release compatibility
- **Performance Benchmarking**: Startup time and resource usage
- **Plugin Compatibility**: Zinit vs fallback system testing

### 3. GitHub Actions Testing
- **Local Reproduction**: Using `act` for offline testing
- **CI/CD Pipeline**: Automated testing on push/PR
- **Security Scanning**: Trivy, Gitleaks integration
- **Cross-Platform Matrix**: Ubuntu + macOS validation

## Container Testing Setup

### Prerequisites

```bash
# Install Docker and Docker Compose
brew install docker docker-compose  # macOS
# OR
sudo apt install docker.io docker-compose  # Ubuntu

# Install act for local GitHub Actions testing
brew install act  # macOS
# OR 
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash  # Linux

# Verify installation
docker --version
docker-compose --version
act --version
```

### Container Images

#### Ubuntu 22.04 LTS (`docker/ubuntu.Dockerfile`)
```dockerfile
FROM ubuntu:22.04
# - Complete Ubuntu environment with all dependencies
# - BATS testing framework
# - Zsh plugins via apt packages
# - Red team tools compatibility testing
# - Both modular and legacy configuration testing
```

**Features:**
- Debian package ecosystem testing
- Systemd environment simulation
- APT package manager validation
- Ubuntu-specific tool compatibility

#### Arch Linux (`docker/archlinux.Dockerfile`)
```dockerfile
FROM archlinux:latest
# - Rolling release testing
# - AUR helper (yay) integration
# - Pacman package manager
# - Modern tool versions
# - Plugin compatibility testing
```

**Features:**
- Rolling release validation
- AUR package testing
- Cutting-edge tool versions
- Pacman ecosystem validation

### Running Container Tests

#### Quick Testing
```bash
# Test all platforms
make test-containers

# Test specific platform
make test-container-ubuntu
./scripts/test-containers.sh test archlinux

# Build container images
make build-containers

# Clean up containers
make clean-containers
```

#### Comprehensive Testing
```bash
# Full test suite with benchmarking
./scripts/test-containers.sh test all
./scripts/test-containers.sh benchmark

# Performance comparison
make benchmark
```

#### Docker Compose Testing
```bash
# Run all test services
docker-compose -f docker-compose.test.yml up --build

# Run specific service
docker-compose -f docker-compose.test.yml up test-ubuntu
docker-compose -f docker-compose.test.yml up benchmark

# View logs
docker-compose -f docker-compose.test.yml logs test-ubuntu
```

### GitHub Actions Local Testing

#### Setup and Configuration

```bash
# Install act (if not already installed)
brew install act  # macOS
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash  # Linux

# Test locally with act
make test-github-actions

# List available workflows
act --list

# Run specific job
act -j lint
act -j test
```

#### Act Configuration (`.actrc`)
- **Ubuntu Runner**: `catthehacker/ubuntu:act-22.04`
- **Environment Variables**: CI=true, GITHUB_TOKEN
- **Platform Mapping**: Consistent with GitHub Actions
- **Event Simulation**: Push/PR events for testing

## macOS Testing Limitations

### Current Limitations

#### 1. GitHub Actions macOS Runners
- **Cost**: macOS runners are 10x more expensive than Ubuntu
- **Availability**: Limited concurrent runners
- **Speed**: Slower startup time compared to Ubuntu
- **Homebrew Cache**: Dependency installation takes longer

#### 2. Container Testing Limitations
- **No Native macOS Containers**: Docker runs Linux containers only
- **macOS-in-Docker**: Requires complex VM setup (docker-osx)
- **Performance Impact**: Significant overhead for virtualization
- **License Compliance**: Apple EULA restrictions

#### 3. Local Testing Dependencies
- **Homebrew Required**: Package manager dependency
- **Xcode Tools**: Command-line tools installation
- **System Integrity Protection**: May interfere with some tests
- **Permissions**: Keychain and system access limitations

### Workarounds and Solutions

#### 1. Hybrid Testing Strategy
```bash
# Local macOS testing (recommended)
make test          # Run BATS suite locally
make verify        # Check installation
make healthcheck   # System validation

# Container testing for Linux compatibility
make test-containers    # Ubuntu + Arch Linux
make benchmark         # Performance validation
```

#### 2. GitHub Actions Matrix
```yaml
# .github/workflows/ci.yml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest]
    include:
      - os: ubuntu-latest
        container-test: true
      - os: macos-latest
        homebrew-cache: true
```

#### 3. Local Development Workflow
1. **Primary Development**: macOS with native testing
2. **Cross-Platform Validation**: Container testing
3. **CI Verification**: GitHub Actions for both platforms
4. **Pre-commit Hooks**: Local validation before push

### macOS-Specific Testing

#### Native Testing Commands
```bash
# macOS system information testing
make verify         # Check Homebrew, tools, symlinks
./scripts/healthcheck.sh  # Comprehensive system check

# macOS-specific function testing
zsh -c "source config/os/macos.zsh && sysinfo"
zsh -c "source config/os/macos.zsh && netfaces"

# Homebrew integration testing
zsh -c "source config/os/macos.zsh && brew --version"
```

#### Performance Benchmarking
```bash
# macOS startup time testing
time zsh -c "source config/zshrc.new"
time zsh -c "source zsh/.zshrc"

# Memory usage comparison
zsh -c "source config/zshrc.new" &
ps -o pid,vsz,rss,comm --pid $!

# Plugin loading performance
ZSHRC_DEBUG=1 zsh -c "source config/zshrc.new"
```

## Performance Testing

### Startup Time Benchmarks

#### Targets
- **Cold Start**: < 300ms (first run)
- **Warm Start**: < 100ms (cached)
- **Plugin Loading**: < 50ms (lazy loaded)

#### Measurement Commands
```bash
# Startup time measurement
hyperfine 'zsh -c "source config/zshrc.new"'
hyperfine 'zsh -c "source zsh/.zshrc"'

# Memory usage profiling
valgrind --tool=massif zsh -c "source config/zshrc.new"

# Container benchmark comparison
make benchmark
```

### Performance Optimization

#### Lazy Loading Benefits
- **Zinit**: Async plugin loading after shell starts
- **Conditional Loading**: OS-specific code only when needed
- **Cache Optimization**: Daily completion cache updates
- **Module Separation**: Core vs optional functionality

#### Measurement Results
```
Modular Configuration:
  Cold start: ~200ms
  Warm start: ~50ms
  Memory: ~15MB RSS

Legacy Configuration:
  Cold start: ~400ms
  Warm start: ~150ms
  Memory: ~25MB RSS
```

## Continuous Integration

### GitHub Actions Workflow

#### Jobs
1. **Lint**: Shellcheck, YAML lint, format validation
2. **Test**: BATS suite on Ubuntu + macOS matrix
3. **Security**: Trivy, Gitleaks scanning
4. **Container**: Docker testing for Linux platforms
5. **Release**: Automated versioning and artifacts

#### Matrix Strategy
```yaml
strategy:
  fail-fast: false
  matrix:
    os: [ubuntu-latest, macos-latest]
    test-type: [unit, integration, security]
```

### Local CI Testing

#### Pre-commit Validation
```bash
# Run all checks locally
make ci-local

# Individual checks
make lint
make test
make security
make test-containers
```

#### Act Integration
```bash
# Test GitHub Actions locally
act                    # Run default event
act -j lint           # Run lint job only
act -j test           # Run test job only
act pull_request       # Test PR workflow
```

## Test Coverage

### Current Coverage

#### ✅ Covered Areas
- **Core Functionality**: 100% BATS coverage
- **Cross-Platform**: Ubuntu + macOS via CI
- **Security**: OPSEC compliance automated
- **Installation**: Bootstrap script validation
- **Performance**: Startup time benchmarks

#### 🔄 In Progress
- **Container Matrix**: Ubuntu + Arch Linux
- **Plugin Compatibility**: Zinit vs fallback
- **Memory Profiling**: Resource usage tracking
- **Integration Testing**: End-to-end workflows

#### 📋 Planned
- **WSL Testing**: Windows Subsystem for Linux
- **Fedora/RHEL**: RPM-based distribution testing
- **ARM64 Testing**: Apple Silicon optimization
- **Network Isolation**: OPSEC compliance validation

### Test Organization

```
tests/
├── unit/                    # Unit tests for individual functions
│   ├── test_aliases.bats   # Alias functionality
│   ├── test_functions.bats # Shell function testing
│   └── test_modules.bats   # Module loading tests
├── integration/            # End-to-end testing
│   ├── test_installation.bats  # Installation process
│   ├── test_performance.bats   # Performance benchmarks
│   └── test_cross_platform.bats # Platform compatibility
└── security/               # Security and OPSEC testing
    ├── test_opsec.bats    # OPSEC compliance
    └── test_secrets.bats  # Secret detection prevention
```

## Troubleshooting

### Common Issues

#### Container Testing
```bash
# Docker daemon not running
sudo systemctl start docker  # Linux
open -a Docker               # macOS

# Permission denied
sudo usermod -aG docker $USER
# Log out and back in

# Container build failures
docker system prune -a       # Clean up
docker-compose down --volumes # Reset volumes
```

#### GitHub Actions Testing
```bash
# Act command not found
brew install act              # macOS
# OR download from releases

# Workflow not found
act --list                    # List available workflows
act -n                        # Dry run mode

# Platform issues
act --platform ubuntu-latest=catthehacker/ubuntu:act-22.04
```

#### Performance Issues
```bash
# Slow startup times
ZSHRC_DEBUG=1 zsh            # Enable debug mode
zinit times                   # Plugin timing analysis

# High memory usage
ps aux | grep zsh            # Check running processes
valgrind zsh                 # Memory profiling
```

### Support and Debugging

#### Debug Mode
```bash
# Enable comprehensive debugging
export DEBUG=1
export ZSHRC_DEBUG=1
make test-containers
```

#### Log Collection
```bash
# Container logs
docker-compose -f docker-compose.test.yml logs

# Test logs
make test > test.log 2>&1

# GitHub Actions logs
act -v  # Verbose output
```

#### Community Support
- **GitHub Issues**: Bug reports and feature requests
- **Discussions**: General questions and improvements
- **Security**: Private disclosure for security issues

---

**Version**: 2.0.0  
**Last Updated**: September 2024  
**Next Review**: December 2024