# Architecture Research

**Domain:** Dotfiles verification orchestration for milestone updates
**Researched:** 2026-02-25
**Confidence:** HIGH

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                   Operator Invocation Layer                │
├─────────────────────────────────────────────────────────────┤
│  `./install.sh`   `source ~/.zshrc`   `verify wrapper`     │
└───────────────┬─────────────────────────────────────────────┘
                │
┌───────────────▼─────────────────────────────────────────────┐
│                Verification Orchestration Layer             │
├─────────────────────────────────────────────────────────────┤
│  check catalog -> command runner -> result aggregator       │
└───────────────┬─────────────────────────────────────────────┘
                │
┌───────────────▼─────────────────────────────────────────────┐
│                Runtime Contract Layer                       │
├─────────────────────────────────────────────────────────────┤
│  zsh/.zshrc   tmux/.tmux.conf   vim/.vimrc   README/AGENTS  │
└─────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Typical Implementation |
|-----------|----------------|------------------------|
| Verification wrapper entrypoint | Run full suite with deterministic ordering and exit codes | `scripts/verify-suite.sh` style shell command |
| Check catalog | Define executable checks and pass criteria | Ordered shell functions or declarative check list |
| Result formatter | Print per-check result and final summary | Plain text reporter with explicit PASS/FAIL/SKIP |
| Compatibility matrix source | Document supported environments and caveats | Markdown table in `.planning/` and README linkage |

## Recommended Project Structure

```
scripts/
├── verify-suite.sh              # One-command validation wrapper
└── verify/
    ├── checks.sh                # Ordered check catalog
    └── report.sh                # Summary and exit-code handling
.planning/
├── REQUIREMENTS.md              # Milestone requirements + traceability
├── ROADMAP.md                   # Phase structure
└── compatibility/
    └── v1.1-matrix.md           # Environment matrix artifact
README.md                        # Operator entrypoint and usage guidance
AGENTS.md                        # Maintainer contract and architecture notes
```

### Structure Rationale

- **`scripts/verify-suite.sh`:** Single user-facing interface for milestone reliability checks.
- **`scripts/verify/`:** Keeps check logic and output logic isolated for easier updates.
- **`.planning/compatibility/`:** Stores matrix artifacts with planning history rather than runtime config.

## Architectural Patterns

### Pattern 1: Ordered Check Pipeline

**What:** Execute checks in a fixed sequence and aggregate outcomes.
**When to use:** Any reliability run requiring deterministic behavior.
**Trade-offs:** Simple and debuggable, but less parallel execution speed.

**Example:**
```bash
run_check "zsh syntax" "zsh -n zsh/.zshrc"
run_check "tmux config" "tmux -f tmux/.tmux.conf -L verify start-server \; kill-server"
```

### Pattern 2: Fail-Soft Optional Dependency Checks

**What:** Skip optional tools with explicit notes instead of hard failures.
**When to use:** Checks involving `asciinema`, `fzf`, or environment-specific tools.
**Trade-offs:** Better usability, but requires careful PASS/SKIP semantics.

### Pattern 3: Contract-First Verification

**What:** Validate documented behavior and runtime behavior together.
**When to use:** Milestones touching docs and operational workflows.
**Trade-offs:** Slightly more checks, but prevents docs/runtime drift.

## Data Flow

### Request Flow

```
[Operator runs wrapper]
    ↓
[Load check catalog]
    ↓
[Execute command checks]
    ↓
[Capture pass/fail/skip results]
    ↓
[Print summary + return exit code]
```

### Key Data Flows

1. **Runtime validation flow:** command execution against `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`.
2. **Doc parity flow:** grep/path checks against `README.md` and `AGENTS.md` to ensure contract alignment.
3. **Matrix publication flow:** validated command outcomes feed environment compatibility documentation.

## Scaling Considerations

| Scale | Architecture Adjustments |
|-------|--------------------------|
| Solo operator | Simple shell wrapper and markdown matrix are sufficient |
| Multi-host environment | Add host-profile arguments and per-host check subsets |
| Team usage | Add CI wrapper integration and machine-readable output |

### Scaling Priorities

1. **First bottleneck:** drifting checks vs docs; fix by co-locating check definitions and matrix updates.
2. **Second bottleneck:** platform flag differences; fix with explicit platform branches in check catalog.

## Anti-Patterns

### Anti-Pattern 1: Implicit Check Contracts

**What people do:** Keep check commands only in chat/history.
**Why it's wrong:** Behavior drifts and future edits break validation.
**Do this instead:** Store check catalog in repo scripts with documented pass criteria.

### Anti-Pattern 2: Wrapper That Mutates Runtime Config

**What people do:** Auto-edit dotfiles during verify runs.
**Why it's wrong:** Creates side effects and erodes trust.
**Do this instead:** Keep verification read-only and report remediation steps separately.

## Integration Points

### External Services

| Service | Integration Pattern | Notes |
|---------|---------------------|-------|
| Local shell tools (`zsh`, `tmux`, `vim`) | Command invocation with exit-code capture | Required runtime dependencies |
| Optional CLI tools (`rg`, `asciinema`, `fzf`) | Capability probes before use | Must fail soft when absent |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| wrapper -> check catalog | shell function calls | Keep check names stable for docs |
| checks -> docs artifacts | markdown updates | Ensure matrix/docs updated with validated results |

## Sources

- Runtime contracts: `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`
- Existing verification docs: `README.md`, `AGENTS.md`, `.planning/phases/01-installation-baseline/01-VERIFICATION-CHECKLIST.md`
- Milestone history: `.planning/MILESTONES.md`, `.planning/milestones/v1.0-ROADMAP.md`

---
*Architecture research for: dotfiles reliability automation milestone*
*Researched: 2026-02-25*
