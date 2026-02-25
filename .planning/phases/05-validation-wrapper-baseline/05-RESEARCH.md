# Phase 5: Validation Wrapper Baseline - Research

**Researched:** 2026-02-25
**Domain:** Shell-based reliability verification orchestration for dotfiles
**Confidence:** HIGH

## User Constraints

### Locked Decisions (from 05-CONTEXT.md)
- Wrapper command contract is `./scripts/verify-suite.sh`.
- Wrapper must run non-interactively from repository root.
- Wrapper must not run `install.sh` by default (read-only verification posture).
- Required checks include shell (`zsh/.zshrc`), tmux (`tmux/.tmux.conf`), vim (`vim/.vimrc`), and docs/runtime parity checks (`README.md`, `AGENTS.md`).
- Required checks fail the run; optional checks are fail-soft.
- Output must be deterministic per check (`PASS`/`FAIL`/`SKIP`) with deterministic final summary.
- Exit `0` only if all required checks pass; non-zero if any required check fails.
- Optional tools (`asciinema`, `fzf`) remain optional and must emit actionable `SKIP` guidance when missing.
- README and AGENTS must document and preserve the wrapper contract.

### Claude's Discretion
- Script decomposition (single script vs helper scripts)
- Output formatting details (line shape/color/no-color)
- Internal helper naming and shell structure

### Deferred Ideas (Out of Scope)
- `AUTO-04` quick-mode execution
- `AUTO-05` machine-readable output mode
- Compatibility matrix generation/details (`COMP-01`, `COMP-02`) — Phase 6
- CI-provider-specific integration scaffolding

## Summary

Phase 5 is best implemented as a shell-first verification wrapper that runs existing reliability checks in deterministic order and emits strict status semantics for automation use. The existing repository already defines concrete check commands in `README.md` and `.planning/phases/01-installation-baseline/01-VERIFICATION-CHECKLIST.md`, so implementation risk is low if those commands are codified behind a stable wrapper contract.

A key repository-specific constraint is that `.gitignore` currently ignores `scripts/`. Because the locked entrypoint is `./scripts/verify-suite.sh`, the phase must include an explicit tracked-file strategy (scoped unignore rules) or the wrapper cannot be versioned. This is a blocking planning detail for `AUTO-01`.

**Primary recommendation:** Use a single POSIX-compatible bash wrapper at `scripts/verify-suite.sh` with deterministic `PASS/FAIL/SKIP` lines, required/optional check classification, and an explicit final summary + exit code contract.

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| bash | 3.2+ | Wrapper runtime | Already used for installer and available in target environments |
| zsh CLI | existing | Shell config verification target | Direct contract check for `zsh/.zshrc` |
| tmux CLI | existing | Tmux config verification target | Direct contract check for `tmux/.tmux.conf` |
| vim CLI | existing | Vim startup verification target | Direct contract check for `vim/.vimrc` |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| ripgrep (`rg`) | existing | Fast parity/pattern checks | Preferred when available for docs/runtime contract checks |
| grep/sed/awk | system | Portable fallback checks and formatting | Use if `rg` unavailable |
| mktemp | system | Isolated temp-home validation | Needed for clean vim startup check |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `scripts/verify-suite.sh` | root-level `verify_install.sh` | Violates locked context decision and weakens future multi-script organization |
| shell wrapper | Python wrapper | Better structured output but adds nonessential dependency/complexity for this phase |

**Installation:**
```bash
# No new package installation required for baseline wrapper.
# Optional tool checks remain fail-soft.
```

## Architecture Patterns

### Recommended Project Structure
```text
scripts/
└── verify-suite.sh      # Single user-facing wrapper command (Phase 5)
```

### Pattern 1: Deterministic Check Runner
**What:** Fixed-order list of checks executed through helper functions that normalize status output.
**When to use:** Any required/optional reliability check flow with strict final status needs.
**Example:**
```bash
run_required "shell syntax" "zsh -n zsh/.zshrc"
run_required "tmux config" "tmux -f tmux/.tmux.conf -L gsd-verify-suite start-server \; kill-server"
```

### Pattern 2: Capability Guard for Optional Checks
**What:** Check command availability before running optional validations.
**When to use:** `asciinema`/`fzf` checks and any non-core dependency.
**Example:**
```bash
if command -v asciinema >/dev/null 2>&1; then
  run_optional "asciinema availability" "asciinema --version >/dev/null"
else
  mark_skip "asciinema availability" "Install asciinema to enable recording capability checks"
fi
```

### Anti-Patterns to Avoid
- Silent omission of failed/optional checks (must emit explicit `SKIP` guidance).
- Non-deterministic output ordering (breaks automation trust).
- Implicit success based only on script completion without per-check status lines.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Complex test framework for this phase | Custom test harness/runner framework | Simple shell check orchestrator | Scope is baseline reliability wrapper, not full test platform |
| Custom parser for docs parity | Bespoke parser scripts | Existing `rg`/`grep` checks | Existing commands are already explicit and adequate |

**Key insight:** Phase 5 should codify known checks behind a stable command, not reinvent a generalized QA framework.

## Common Pitfalls

### Pitfall 1: Untracked Wrapper Artifact
**What goes wrong:** `scripts/verify-suite.sh` is created but not committed due `.gitignore`.
**Why it happens:** Repository currently ignores `scripts/` globally.
**How to avoid:** Add scoped unignore rules for `scripts/verify-suite.sh` in `.gitignore`.
**Warning signs:** `git status` never shows wrapper file after creation.

### Pitfall 2: Required/Optional Misclassification
**What goes wrong:** Missing optional tool causes full run failure.
**Why it happens:** Optional checks run as required steps.
**How to avoid:** Explicit required vs optional helper functions.
**Warning signs:** fresh host fails before core checks complete.

### Pitfall 3: Non-Deterministic Output
**What goes wrong:** Summary or statuses differ across runs without real behavior changes.
**Why it happens:** Mixed stderr/stdout ordering or dynamic formatting without stable sort/order.
**How to avoid:** Fixed check order and consistent status line format.
**Warning signs:** flaky parse behavior when wrapper is run multiple times.

## Code Examples

### Required check helper pattern
```bash
run_required() {
  local id="$1"
  local cmd="$2"
  if eval "$cmd" >/dev/null 2>&1; then
    echo "PASS  | ${id}"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo "FAIL  | ${id}"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}
```

### Final exit contract pattern
```bash
echo "SUMMARY | PASS=${PASS_COUNT} FAIL=${FAIL_COUNT} SKIP=${SKIP_COUNT}"
if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
exit 0
```

## Open Questions

1. **Should wrapper enforce repo-root cwd strictly or auto-resolve repo root?**
   - What we know: locked decision says run from repo root.
   - Recommendation: enforce cwd check with actionable failure message.

2. **Should colorized output be enabled by default?**
   - What we know: deterministic output required.
   - Recommendation: keep plain-text default now; optional styling can be deferred.

## Sources

- `05-CONTEXT.md` (locked Phase 5 decisions)
- `README.md` verification sections and existing commands
- `.planning/phases/01-installation-baseline/01-VERIFICATION-CHECKLIST.md`
- `AGENTS.md` runtime contract notes
- `.gitignore` repository constraints for tracked artifacts

---
*Research completed: 2026-02-25*
*Ready for planning: yes*
