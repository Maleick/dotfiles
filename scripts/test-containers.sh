#!/usr/bin/env bash

# Container Testing Script
# Cross-platform validation using Docker containers

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(dirname "$SCRIPT_DIR")"
DOCKER_COMPOSE_FILE="$DOTFILES_ROOT/docker-compose.test.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v docker >/dev/null 2>&1; then
        log_error "Docker not found. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose >/dev/null 2>&1; then
        log_error "Docker Compose not found. Please install Docker Compose first."
        exit 1
    fi
    
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        log_error "Docker daemon is not running. Please start Docker."
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Clean up existing containers and images
cleanup() {
    log_info "Cleaning up existing containers and images..."
    
    # Stop and remove containers
    docker-compose -f "$DOCKER_COMPOSE_FILE" down --remove-orphans 2>/dev/null || true
    
    # Remove test images
    docker images --filter "reference=redteam-dotfiles:*" -q | xargs -r docker rmi -f 2>/dev/null || true
    
    log_success "Cleanup completed"
}

# Build container images
build_images() {
    local platform="$1"
    
    log_info "Building $platform container image..."
    
    case "$platform" in
        ubuntu)
            docker build -f docker/ubuntu.Dockerfile -t redteam-dotfiles:ubuntu . || {
                log_error "Failed to build Ubuntu image"
                return 1
            }
            ;;
        archlinux)
            docker build -f docker/archlinux.Dockerfile -t redteam-dotfiles:archlinux . || {
                log_error "Failed to build Arch Linux image"
                return 1
            }
            ;;
        all)
            build_images ubuntu && build_images archlinux
            return $?
            ;;
        *)
            log_error "Unknown platform: $platform"
            return 1
            ;;
    esac
    
    log_success "Successfully built $platform image"
}

# Run tests on specific platform
test_platform() {
    local platform="$1"
    
    log_info "Running tests on $platform..."
    
    case "$platform" in
        ubuntu)
            docker-compose -f "$DOCKER_COMPOSE_FILE" up --build test-ubuntu || {
                log_error "Ubuntu tests failed"
                return 1
            }
            ;;
        archlinux)
            docker-compose -f "$DOCKER_COMPOSE_FILE" up --build test-archlinux || {
                log_error "Arch Linux tests failed"
                return 1
            }
            ;;
        benchmark)
            docker-compose -f "$DOCKER_COMPOSE_FILE" up --build benchmark || {
                log_error "Benchmark tests failed"
                return 1
            }
            ;;
        all)
            docker-compose -f "$DOCKER_COMPOSE_FILE" up --build || {
                log_error "One or more platform tests failed"
                return 1
            }
            ;;
        *)
            log_error "Unknown platform: $platform"
            return 1
            ;;
    esac
    
    log_success "$platform tests completed successfully"
}

# Run local GitHub Actions with act
test_github_actions() {
    log_info "Testing GitHub Actions locally with act..."
    
    if ! command -v act >/dev/null 2>&1; then
        log_warning "act not found. Install with: brew install act"
        log_warning "Skipping GitHub Actions testing"
        return 0
    fi
    
    cd "$DOTFILES_ROOT"
    
    # Test the CI workflow
    if act -n --list >/dev/null 2>&1; then
        log_info "Available workflows:"
        act --list
        
        log_info "Running CI workflow..."
        act -j lint -j test --platform ubuntu-latest=catthehacker/ubuntu:act-22.04 || {
            log_error "GitHub Actions testing failed"
            return 1
        }
    else
        log_warning "No GitHub Actions workflows found or act configuration issue"
        return 0
    fi
    
    log_success "GitHub Actions testing completed"
}

# Performance comparison
performance_comparison() {
    log_info "Running performance comparison..."
    
    # Build benchmark image
    docker build -f docker/ubuntu.Dockerfile -t redteam-dotfiles:benchmark . || {
        log_error "Failed to build benchmark image"
        return 1
    }
    
    echo
    log_info "=== Performance Results ==="
    
    # Run benchmark
    docker run --rm redteam-dotfiles:benchmark bash -c "
        echo '=== Modular Configuration Startup Time ==='
        time zsh -c 'source config/zshrc.new'
        echo
        echo '=== Legacy Configuration Startup Time ==='
        time zsh -c 'source zsh/.zshrc'
        echo
        echo '=== Memory Usage Comparison ==='
        echo 'Modular config:'
        zsh -c 'source config/zshrc.new' &
        sleep 1
        ps -o pid,vsz,rss,comm --pid \$! 2>/dev/null || true
        wait
        echo 'Legacy config:'
        zsh -c 'source zsh/.zshrc' &
        sleep 1
        ps -o pid,vsz,rss,comm --pid \$! 2>/dev/null || true
        wait
    " || {
        log_error "Performance comparison failed"
        return 1
    }
    
    log_success "Performance comparison completed"
}

# Print help
usage() {
    cat << EOF
Container Testing Script - Red Team Dotfiles

USAGE:
    $0 [COMMAND] [OPTIONS]

COMMANDS:
    build PLATFORM     Build container image for platform (ubuntu|archlinux|all)
    test PLATFORM      Run tests on platform (ubuntu|archlinux|benchmark|all)
    actions             Test GitHub Actions locally with act
    benchmark           Run performance comparison
    clean               Clean up containers and images
    help                Show this help message

EXAMPLES:
    $0 build ubuntu                 # Build Ubuntu test image
    $0 test all                     # Test all platforms
    $0 actions                      # Test GitHub Actions locally
    $0 benchmark                    # Run performance comparison
    $0 clean                        # Clean up test containers

EOF
}

# Main execution
main() {
    local command="${1:-help}"
    
    case "$command" in
        build)
            check_prerequisites
            local platform="${2:-ubuntu}"
            build_images "$platform"
            ;;
        test)
            check_prerequisites
            local platform="${2:-all}"
            test_platform "$platform"
            ;;
        actions)
            test_github_actions
            ;;
        benchmark)
            check_prerequisites
            performance_comparison
            ;;
        clean)
            cleanup
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            log_error "Unknown command: $command"
            echo
            usage
            exit 1
            ;;
    esac
}

# Handle interruption gracefully
trap cleanup INT TERM

# Run main function
main "$@"