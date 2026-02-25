# Stack Research

**Domain:** Dotfiles verification wrapper expansion and compatibility evidence automation
**Researched:** 2026-02-25
**Confidence:** HIGH

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| POSIX shell (`bash`) | 3.2+ | Wrapper orchestration, mode routing, and deterministic exits | Already the repo automation baseline (`install.sh`, `scripts/verify-suite.sh`) and portable across macOS/Linux targets |
| `zsh`, `tmux`, `vim` CLIs | Existing host versions | Runtime contract checks | Current required checks already validate these contracts directly from source-of-truth config files |
| `date`, `mktemp`, `awk`, `sed`, `grep`/`rg` | system | Stable evidence formatting and check execution helpers | Available by default in terminal-first environments and consistent with current verification strategy |
| `jq` (optional but recommended) | 1.6+ | Validate machine-readable output contract in smoke checks | Simplifies output contract verification without requiring custom parsers |

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `shellcheck` | 0.9+ | Static checks for wrapper scripts | Before release or when mode logic complexity increases |
| `shfmt` | 3.8+ | Formatting consistency for shell scripts | Keep wrapper and helper scripts reviewable as files grow |
| `bats-core` | 1.11+ | Script-level behavior tests | Add when quick/full mode branching and output formats require repeatable assertions |

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| `git` | Milestone-scoped change tracking | Keep wrapper and docs contract changes atomic by phase |
| `node .../gsd-tools.cjs` | Planning-state commits and workflow metadata | Existing docs workflow contracts already depend on this tooling |
| `./scripts/verify-suite.sh` | Canonical behavior probe | Must remain the primary evidence source for compatibility matrix rows |

## Installation

```bash
# Optional quality tooling for wrapper implementation/review
brew install shellcheck shfmt bats-core jq || true
```

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| Plain shell mode flags in `scripts/verify-suite.sh` | Rewriting wrapper in Python/Go | Only if shell complexity becomes unmaintainable and portability constraints are re-approved |
| Markdown matrix as canonical source | DB/JSON-only compatibility registry | Use only if future milestones require machine-driven matrix publication |
| Manual evidence capture plus deterministic command refs | Fully automatic CI-only evidence ingestion | Use only after CI integration becomes in-scope |

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| Auto-install dependencies during verify run | Violates read-only verification contract and can mask host issues | Emit actionable `SKIP` guidance and keep run side-effect free |
| Inferred compatibility status labels | Breaks trust in matrix artifact | Record only observed run evidence with date and command reference |
| One-off ad hoc output formats | Makes downstream parsing brittle | Define stable machine-readable contract and version it in docs |

## Stack Patterns by Variant

**If operator needs fast local checks:**
- Use quick mode in the same wrapper entrypoint.
- Keep a shared required-check subset so quick mode cannot drift from full mode contracts.

**If maintainers need machine parsing:**
- Emit machine-readable summary as an optional mode from the same execution graph.
- Keep human-readable `PASS`/`FAIL`/`SKIP` output unchanged as default.

## Version Compatibility

| Package A | Compatible With | Notes |
|-----------|-----------------|-------|
| `bash` 3.2+ | existing `scripts/verify-suite.sh` style | Compatible with macOS default shell runtime and Linux hosts |
| `jq` 1.6+ | JSON output checks | Optional dependency; wrapper should still run without it |
| `tmux` 3.2+ | current config load smoke command | Existing phase verification uses this baseline |

## Sources

- `scripts/verify-suite.sh` — current wrapper contracts and check taxonomy
- `.planning/phases/05-validation-wrapper-baseline/05-VERIFICATION.md` — evidence for required/optional semantics
- `.planning/compatibility/v1.1-matrix.md` — current matrix schema and evidence model
- `README.md` and `AGENTS.md` — operator/maintainer documentation contracts

---
*Stack research for: v1.2 automation expansion*
*Researched: 2026-02-25*
