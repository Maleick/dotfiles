# Pitfalls Research

**Domain:** Dotfiles reliability automation and compatibility documentation
**Researched:** 2026-02-25
**Confidence:** HIGH

## Critical Pitfalls

### Pitfall 1: Validation Wrapper Drift from Real Runtime Contracts

**What goes wrong:**
Wrapper checks stop matching actual behavior in `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`.

**Why it happens:**
Checks are copied once, then not updated when runtime contracts evolve.

**How to avoid:**
Define checks directly against current source-of-truth files and keep docs references in the same milestone phase.

**Warning signs:**
Checks pass while operators still hit startup/keybinding regressions.

**Phase to address:**
Phase 5 (wrapper baseline definition).

---

### Pitfall 2: Optional Dependency Failures Treated as Hard Errors

**What goes wrong:**
Absent optional tools (`asciinema`, `fzf`, `rg`) cause full verify command failure.

**Why it happens:**
Command probes are skipped and wrappers assume all tools are installed.

**How to avoid:**
Use command-availability guards and explicit SKIP output with remediation notes.

**Warning signs:**
Wrapper fails on fresh systems before core checks run.

**Phase to address:**
Phase 5 (check-catalog fail-soft semantics).

---

### Pitfall 3: Compatibility Matrix Becomes Static Guesswork

**What goes wrong:**
Matrix lists environments without proving check results, creating false trust.

**Why it happens:**
Matrix is written once from assumptions instead of validated runs.

**How to avoid:**
Tie matrix entries to executed check outcomes and include last-validated date/command set.

**Warning signs:**
Matrix entries do not reference concrete checks or environment notes.

**Phase to address:**
Phase 6 (matrix publication and verification).

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Inline ad hoc checks in README only | Fast initial documentation | No executable contract for regression detection | Never |
| Wrapper without per-check labels | Minimal script code | Debugging failures becomes slow and ambiguous | Never |
| Platform assumptions without explicit branches | Faster first implementation | Breaks on macOS/Linux differences | Only for truly POSIX-identical commands |

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| `tmux` non-interactive check | Using brittle startup command forms | Use deterministic start/kill server flow with dedicated socket |
| `vim` startup check | Running in normal user home state only | Also run temp-home check to catch plugin-manager assumptions |
| Docs parity checks | Checking README only | Validate both `README.md` and `AGENTS.md` contract references |

## Performance Traps

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Running heavyweight checks on every small edit | Slow feedback loop | Add quick-mode subset for common edits | Daily iterative dev loops |
| Re-running installation for every verify | Unnecessary file churn | Separate install tests from read-only runtime checks | Repeated local verification |

## Security Mistakes

| Mistake | Risk | Prevention |
|---------|------|------------|
| Printing secret-like environment values in debug output | Accidental leak in logs/history | Keep wrapper output strictly command/result oriented |
| Executing network-dependent checks by default | External side effects and instability | Default to local/offline checks; make network checks opt-in |

## UX Pitfalls

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| One final "failed" line only | Hard to identify root cause | Print each check with PASS/FAIL/SKIP and command hints |
| Unclear skip semantics | Users assume everything passed | Separate SKIP from PASS and summarize counts |

## "Looks Done But Isn't" Checklist

- [ ] **Wrapper command:** verifies shell, tmux, vim, and docs parity checks end-to-end.
- [ ] **Exit behavior:** returns non-zero when any required check fails.
- [ ] **Optional dependencies:** are reported as SKIP with guidance, not hidden or hard-failed.
- [ ] **Compatibility matrix:** references validated environments and command set version/date.

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Check drift | MEDIUM | Rebaseline check catalog against runtime contracts and rerun full suite |
| Hard optional dependency failures | LOW | Add capability guards and rerun baseline verification |
| Matrix drift | LOW | Revalidate matrix environments and update notes/date |

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Wrapper drift from runtime contracts | Phase 5 | Re-run suite after shell/tmux/vim edits and compare docs references |
| Optional dependency hard failures | Phase 5 | Execute suite on minimal tool host and confirm SKIP semantics |
| Static/unguarded matrix | Phase 6 | Validate matrix entries against current check outcomes |

## Sources

- Prior phase verification artifacts in `.planning/phases/01-*`, `03-*`, `04-*`
- Runtime docs/contracts in `README.md`, `AGENTS.md`, and config files
- Milestone archive evidence in `.planning/milestones/v1.0-ROADMAP.md`

---
*Pitfalls research for: dotfiles reliability automation milestone*
*Researched: 2026-02-25*
