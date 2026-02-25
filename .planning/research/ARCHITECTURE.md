# Architecture Research

**Domain:** Red-team terminal dotfiles and operator environment management
**Researched:** 2026-02-25
**Confidence:** HIGH

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     User Shell Environment                  │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ zsh runtime │  │ tmux server │  │ vim runtime │         │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
│         │                │                │                │
├─────────┴────────────────┴────────────────┴────────────────┤
│                    Repository Source Layer                 │
├─────────────────────────────────────────────────────────────┤
│  zsh/.zshrc   tmux/.tmux.conf   vim/.vimrc   install.sh    │
├─────────────────────────────────────────────────────────────┤
│                    Planning/Quality Layer                  │
│  .planning/codebase/*  PROJECT/REQUIREMENTS/ROADMAP/STATE  │
└─────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Typical Implementation |
|-----------|----------------|------------------------|
| Installer | Backup + symlink setup | `install.sh` with timestamped backup and link logic |
| Shell config | Aliases, functions, prompt, completion, OPSEC options | `zsh/.zshrc` |
| Tmux config | Session navigation, logging, keybinding automation | `tmux/.tmux.conf` |
| Vim config | Plugin management, mappings, language ergonomics | `vim/.vimrc` |
| Planning docs | Requirements and execution memory | `.planning/*.md` |

## Recommended Project Structure

```
repo-root/
├── zsh/                 # Shell behavior and helper commands
│   └── .zshrc
├── tmux/                # Multiplexer behavior and bindings
│   └── .tmux.conf
├── vim/                 # Editor behavior and plugin setup
│   └── .vimrc
├── install.sh           # Bootstrap and symlink orchestration
├── README.md            # User-facing setup and usage docs
└── .planning/           # Planning, mapping, and execution state
```

### Structure Rationale

- **Tool-domain split:** each runtime config is isolated by subsystem for low-friction updates.
- **Central installer:** one authoritative bootstrap path reduces drift.
- **Planning alongside source:** keeps design intent and execution state close to implementation.

## Architectural Patterns

### Pattern 1: Source-of-Truth Config Repository

**What:** Edit configs only in repository paths and publish via symlink installer.
**When to use:** Any change that should survive across machines/sessions.
**Trade-offs:** Slightly more setup steps than direct `$HOME` editing, but much better consistency.

### Pattern 2: Guarded Optional Integrations

**What:** Conditional enablement for optional tools/plugins.
**When to use:** Features like `aliasr`, `fzf`, syntax-highlighting plugins, or local overrides.
**Trade-offs:** More branching logic, but graceful degradation on hosts missing dependencies.

### Pattern 3: Operator-Centric Shortcut Layer

**What:** Alias/function/keybinding curation around common red-team tasks.
**When to use:** Repetitive operational commands needing speed and consistency.
**Trade-offs:** Requires documentation and drift checks as command surface grows.

## Data Flow

### Request Flow

```
Operator command
    ↓
zsh alias/function
    ↓
local CLI or tmux/vim action
    ↓
terminal output/log artifact
```

### State Management

```
Repository files
    ↓ install.sh symlink
$HOME runtime config
    ↓ reload/session restart
active shell/tmux/vim state
```

### Key Data Flows

1. **Bootstrap flow:** repo config files → `install.sh` symlinks → `$HOME` configs.
2. **Execution flow:** operator input → shell/tmux/vim mapping → command execution/log output.

## Scaling Considerations

| Scale | Architecture Adjustments |
|-------|--------------------------|
| Single operator / few hosts | Current monorepo layout is sufficient |
| Multiple host profiles | Add host-profile overlays and compatibility notes |
| Team usage | Introduce stricter validation and role-specific docs |

### Scaling Priorities

1. **First bottleneck:** configuration drift between docs and runtime behavior.
2. **Second bottleneck:** cross-platform command incompatibilities in helper functions.

## Anti-Patterns

### Anti-Pattern 1: Direct Home Config Editing

**What people do:** Edit `~/.zshrc` directly and forget repo mirror.
**Why it's wrong:** Breaks reproducibility and makes troubleshooting inconsistent.
**Do this instead:** Edit repo file then run `./install.sh`.

### Anti-Pattern 2: Unbounded Shortcut Growth

**What people do:** Add aliases/bindings without grouping, docs, or collision checks.
**Why it's wrong:** Raises cognitive load and keybinding conflicts.
**Do this instead:** Add by section with doc sync and quick validation.

## Integration Points

### External Services

| Service | Integration Pattern | Notes |
|---------|---------------------|-------|
| `aliasr` | Shell alias + tmux split bindings | Must preserve `a` alias and `Prefix + U/K` workflow |
| `asciinema` | Tmux pipe-pane recording | Optional, should fail gracefully when absent |
| IP check services | Shell `curl` helpers | Keep multiple fallbacks to reduce service dependency |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| `install.sh` ↔ runtime configs | Symlink and filesystem operations | Must remain idempotent |
| docs ↔ config files | Manual synchronization | Requires explicit release hygiene pass |

## Sources

- `/opt/dotfiles/.planning/codebase/ARCHITECTURE.md`
- `/opt/dotfiles/.planning/codebase/STRUCTURE.md`
- `/opt/dotfiles/AGENTS.md`

---
*Architecture research for: red-team terminal dotfiles*
*Researched: 2026-02-25*
