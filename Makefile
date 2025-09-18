# Dotfiles Makefile
# Automation for development, testing, and deployment

.PHONY: help install test lint format clean backup verify security update-deps

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Default target
help: ## Show this help message
	@echo "$(GREEN)Red Team Dotfiles - Development Commands$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BLUE)%-20s$(NC) %s\n", $$1, $$2}'

install: ## Install dotfiles to home directory
	@echo "$(YELLOW)Installing dotfiles...$(NC)"
	@bash install.sh
	@echo "$(GREEN)✓ Installation complete$(NC)"

migrate-config: ## Migrate to modular configuration system
	@echo "$(YELLOW)Migrating to modular configuration...$(NC)"
	@bash scripts/migrate-config.sh
	@echo "$(GREEN)✓ Migration complete$(NC)"

backup: ## Create backup of current dotfiles
	@echo "$(YELLOW)Creating backup...$(NC)"
	@mkdir -p ~/.dotfiles_backup_$$(date +%Y%m%d%H%M%S)
	@for file in .zshrc .tmux.conf .vimrc; do \
		if [ -f ~/"$$file" ]; then \
			cp ~/"$$file" ~/.dotfiles_backup_$$(date +%Y%m%d%H%M%S)/; \
			echo "  Backed up $$file"; \
		fi \
	done
	@echo "$(GREEN)✓ Backup complete$(NC)"

test: ## Run all tests
	@echo "$(YELLOW)Running tests...$(NC)"
	@make test-shellcheck
	@make test-install
	@make test-bats
	@echo "$(GREEN)✓ All tests passed$(NC)"

test-shellcheck: ## Run shellcheck on all shell scripts
	@echo "$(BLUE)Running shellcheck...$(NC)"
	@find . -name "*.sh" -o -name "*.bash" | while read file; do \
		if [ -f "$$file" ]; then \
			echo "  Checking: $$file"; \
			shellcheck -S warning "$$file" || exit 1; \
		fi \
	done
	@echo "$(GREEN)  ✓ Shellcheck passed$(NC)"

test-install: ## Test installation in temporary directory
	@echo "$(BLUE)Testing installation...$(NC)"
	@export TEST_HOME=$$(mktemp -d) && \
	export HOME="$$TEST_HOME" && \
	bash install.sh && \
	test -L "$$HOME/.zshrc" && \
	test -L "$$HOME/.tmux.conf" && \
	test -L "$$HOME/.vimrc" && \
	rm -rf "$$TEST_HOME" && \
	echo "$(GREEN)  ✓ Installation test passed$(NC)"

test-bats: ## Run BATS test suite
	@echo "$(BLUE)Running BATS tests...$(NC)"
	@command -v bats >/dev/null 2>&1 || { echo "$(YELLOW)BATS not installed, skipping tests$(NC)"; exit 0; }
	@bats test/*.bats
	@echo "$(GREEN)  ✓ BATS tests passed$(NC)"

test-opsec: ## Run OPSEC compliance tests
	@echo "$(BLUE)Running OPSEC compliance tests...$(NC)"
	@command -v bats >/dev/null 2>&1 || { echo "$(YELLOW)BATS not installed, skipping tests$(NC)"; exit 0; }
	@bats test/test_opsec.bats
	@echo "$(GREEN)  ✓ OPSEC compliance verified$(NC)"

lint: ## Lint all configuration files
	@echo "$(YELLOW)Linting files...$(NC)"
	@command -v shellcheck >/dev/null 2>&1 || { echo "$(RED)shellcheck not installed$(NC)"; exit 1; }
	@make test-shellcheck
	@command -v yamllint >/dev/null 2>&1 && yamllint -d relaxed .github/ || echo "$(YELLOW)yamllint not installed, skipping YAML linting$(NC)"
	@echo "$(GREEN)✓ Linting complete$(NC)"

format: ## Format shell scripts with shfmt
	@echo "$(YELLOW)Formatting shell scripts...$(NC)"
	@command -v shfmt >/dev/null 2>&1 || { echo "$(RED)shfmt not installed$(NC)"; exit 1; }
	@shfmt -w -i 4 -ci .
	@echo "$(GREEN)✓ Formatting complete$(NC)"

healthcheck: ## Run comprehensive health check
	@echo "$(YELLOW)Running health check...$(NC)"
	@./scripts/healthcheck.sh

verify: ## Verify installation and dependencies
	@echo "$(YELLOW)Verifying installation...$(NC)"
	@echo "Checking required tools:"
	@command -v zsh >/dev/null 2>&1 && echo "$(GREEN)  ✓ zsh$(NC)" || echo "$(RED)  ✗ zsh$(NC)"
	@command -v tmux >/dev/null 2>&1 && echo "$(GREEN)  ✓ tmux$(NC)" || echo "$(RED)  ✗ tmux$(NC)"
	@command -v vim >/dev/null 2>&1 && echo "$(GREEN)  ✓ vim$(NC)" || echo "$(RED)  ✗ vim$(NC)"
	@command -v git >/dev/null 2>&1 && echo "$(GREEN)  ✓ git$(NC)" || echo "$(RED)  ✗ git$(NC)"
	@echo ""
	@echo "Checking optional tools:"
	@command -v fzf >/dev/null 2>&1 && echo "$(GREEN)  ✓ fzf$(NC)" || echo "$(YELLOW)  ○ fzf (recommended)$(NC)"
	@command -v rg >/dev/null 2>&1 && echo "$(GREEN)  ✓ ripgrep$(NC)" || echo "$(YELLOW)  ○ ripgrep (recommended)$(NC)"
	@command -v asciinema >/dev/null 2>&1 && echo "$(GREEN)  ✓ asciinema$(NC)" || echo "$(YELLOW)  ○ asciinema (optional)$(NC)"
	@echo ""
	@echo "Checking dotfile links:"
	@test -L ~/.zshrc && echo "$(GREEN)  ✓ .zshrc linked$(NC)" || echo "$(RED)  ✗ .zshrc not linked$(NC)"
	@test -L ~/.tmux.conf && echo "$(GREEN)  ✓ .tmux.conf linked$(NC)" || echo "$(RED)  ✗ .tmux.conf not linked$(NC)"
	@test -L ~/.vimrc && echo "$(GREEN)  ✓ .vimrc linked$(NC)" || echo "$(RED)  ✗ .vimrc not linked$(NC)"

security: ## Run security scans
	@echo "$(YELLOW)Running security scans...$(NC)"
	@command -v trivy >/dev/null 2>&1 && trivy fs . || echo "$(YELLOW)Trivy not installed, skipping container scan$(NC)"
	@command -v gitleaks >/dev/null 2>&1 && gitleaks detect --source . -v || echo "$(YELLOW)Gitleaks not installed, skipping secret scan$(NC)"
	@echo "$(GREEN)✓ Security scan complete$(NC)"

clean: ## Remove backup directories older than 30 days
	@echo "$(YELLOW)Cleaning old backups...$(NC)"
	@find ~ -maxdepth 1 -name ".dotfiles_backup_*" -type d -mtime +30 -exec rm -rf {} \; 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup complete$(NC)"

update-deps: ## Update dependencies and submodules
	@echo "$(YELLOW)Updating dependencies...$(NC)"
	@git submodule update --init --recursive
	@echo "$(GREEN)✓ Dependencies updated$(NC)"

dev-setup: ## Setup development environment
	@echo "$(YELLOW)Setting up development environment...$(NC)"
	@command -v pre-commit >/dev/null 2>&1 || pip install --user pre-commit
	@pre-commit install || true
	@echo "$(GREEN)✓ Development environment ready$(NC)"

ci-local: ## Run CI tests locally
	@echo "$(YELLOW)Running CI tests locally...$(NC)"
	@make lint
	@make test
	@make security
	@echo "$(GREEN)✓ All CI checks passed locally$(NC)"

test-containers: ## Test dotfiles in Linux containers
	@echo "$(YELLOW)Running container tests...$(NC)"
	@./scripts/test-containers.sh test all
	@echo "$(GREEN)✓ Container tests completed$(NC)"

test-container-ubuntu: ## Test dotfiles in Ubuntu container
	@echo "$(YELLOW)Testing Ubuntu container...$(NC)"
	@./scripts/test-containers.sh test ubuntu

build-containers: ## Build all container images
	@echo "$(YELLOW)Building container images...$(NC)"
	@./scripts/test-containers.sh build all
	@echo "$(GREEN)✓ Container images built$(NC)"

test-github-actions: ## Test GitHub Actions locally with act
	@echo "$(YELLOW)Testing GitHub Actions locally...$(NC)"
	@./scripts/test-containers.sh actions

benchmark: ## Run performance benchmarks
	@echo "$(YELLOW)Running performance benchmarks...$(NC)"
	@./scripts/test-containers.sh benchmark

clean-containers: ## Clean up container images and artifacts
	@echo "$(YELLOW)Cleaning up containers...$(NC)"
	@./scripts/test-containers.sh clean

build-release-artifacts: ## Build release artifacts (zip, configs, checksums)
	@echo "$(YELLOW)Building release artifacts...$(NC)"
	@./scripts/build-release-artifacts.sh
	@echo "$(GREEN)✓ Release artifacts built$(NC)"

release-dry: ## Dry run of release process
	@echo "$(YELLOW)Performing release dry run...$(NC)"
	@command -v npx >/dev/null 2>&1 || { echo "$(RED)Node.js/npm required for releases$(NC)"; exit 1; }
	@npx standard-version --dry-run

release-patch: ## Create patch release (x.x.X)
	@echo "$(YELLOW)Creating patch release...$(NC)"
	@command -v npx >/dev/null 2>&1 || { echo "$(RED)Node.js/npm required for releases$(NC)"; exit 1; }
	@npx standard-version --release-as patch

release-minor: ## Create minor release (x.X.x)
	@echo "$(YELLOW)Creating minor release...$(NC)"
	@command -v npx >/dev/null 2>&1 || { echo "$(RED)Node.js/npm required for releases$(NC)"; exit 1; }
	@npx standard-version --release-as minor

release-major: ## Create major release (X.x.x)
	@echo "$(YELLOW)Creating major release...$(NC)"
	@command -v npx >/dev/null 2>&1 || { echo "$(RED)Node.js/npm required for releases$(NC)"; exit 1; }
	@npx standard-version --release-as major

release: ## Create release (auto-detect version bump)
	@echo "$(YELLOW)Creating release...$(NC)"
	@command -v npx >/dev/null 2>&1 || { echo "$(RED)Node.js/npm required for releases$(NC)"; exit 1; }
	@npx standard-version

commit-conventional: ## Create conventional commit with commitizen
	@echo "$(YELLOW)Creating conventional commit...$(NC)"
	@command -v npx >/dev/null 2>&1 || { echo "$(RED)Node.js/npm required for conventional commits$(NC)"; exit 1; }
	@npx git-cz

.DEFAULT_GOAL := help
