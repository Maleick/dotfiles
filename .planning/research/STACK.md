# Stack Research

**Domain:** Dotfiles reliability automation and compatibility coverage
**Researched:** 2026-02-25
**Confidence:** HIGH

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| POSIX shell (`bash`) | 3.2+ | Primary wrapper runtime for cross-host checks | Already used by `install.sh`; broad portability across macOS/Linux |
| `zsh` | 5.8+ | Shell syntax and behavior verification target | `zsh/.zshrc` is a core runtime contract |
| `tmux` | 3.2+ | Session startup/config verification target | `tmux/.tmux.conf` behavior must stay stable |
| `vim` | 8.2+ | Editor startup/config verification target | `vim/.vimrc` fallback behavior is milestone-critical |

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `mktemp` | system | Isolated temp-home checks for deterministic startup tests | Required for safe vim/zsh checks without mutating user state |
| `awk`/`sed`/`grep` | system | Lightweight check output shaping and summary formatting | Use for report aggregation in wrapper output |
| `rg` (ripgrep) | latest available | Fast contract/pattern checks in docs and configs | Use when validating docs/runtime parity and keybinding presence |

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| `shellcheck` | Lint verification wrapper scripts | Optional but useful before release |
| `bats-core` | Script-level smoke tests | Optional if wrapper complexity grows |

## Installation

```bash
# Core runtime dependencies are already expected in operator environments.
# Optional tooling for script quality gates:
brew install shellcheck bats-core ripgrep || true
```

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| POSIX shell wrapper | Python wrapper | Use Python only if orchestration needs structured JSON output and richer parsing |
| Inline command list | Makefile task runner | Use `make` only if broader build/test workflows are reintroduced |

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| Interactive-only prompts in verification wrapper | Breaks automation and CI execution | Non-interactive flags and deterministic exit codes |
| Hardcoded host-specific paths | Fails across systems | Parameterized paths with `$HOME` and repo-root detection |
| Silent failure for optional checks | Hides drift and regressions | Fail-soft messages with explicit skipped-state output |

## Stack Patterns by Variant

**If running on macOS:**
- Prefer Homebrew-provided tools when present
- Keep BSD/GNU flag differences explicit in helper checks

**If running on Linux:**
- Prefer distro-native utilities first
- Keep command probes (`command -v`) before execution for optional tools

## Version Compatibility

| Package A | Compatible With | Notes |
|-----------|-----------------|-------|
| `zsh` 5.8+ | Current `zsh/.zshrc` patterns | `zsh -n` and sourced checks expected to pass |
| `tmux` 3.2+ | Current `tmux/.tmux.conf` contracts | Truecolor and keybinding checks rely on modern tmux options |
| `vim` 8.2+ | Current `vim/.vimrc` fallback logic | Guarded startup path should still work with missing plugins |

## Sources

- Local runtime contracts: `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, `install.sh`
- Existing verification guidance: `README.md`, `.planning/phases/01-installation-baseline/01-VERIFICATION-CHECKLIST.md`
- Prior milestone outcomes: `.planning/MILESTONES.md`, `.planning/milestones/v1.0-ROADMAP.md`

---
*Stack research for: dotfiles reliability automation milestone*
*Researched: 2026-02-25*
