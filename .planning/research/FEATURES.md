# Feature Research

**Domain:** Dotfiles reliability validation automation
**Researched:** 2026-02-25
**Confidence:** HIGH

## Feature Landscape

### Table Stakes (Users Expect These)

Features operators should get by default in this milestone.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Single command to run full validation suite | Removes manual command hopping | MEDIUM | Should orchestrate shell, tmux, vim, and docs checks |
| Per-check pass/fail summary with non-zero exit on failure | Required for trust and automation use | MEDIUM | Needs deterministic exit-code contract |
| Compatibility matrix documentation | Helps operators understand environment differences quickly | LOW | Must include macOS/Linux and network/runtime assumptions |
| Clear skip/fail-soft handling for optional tools | Existing workflow uses optional dependencies | LOW | Must preserve tmux/vim fail-soft behavior |

### Differentiators (Competitive Advantage)

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Fast mode for common checks | Speeds pre-flight edits and local iteration | LOW | Optional `--quick` mode can skip heavier checks |
| Structured output mode (plain + concise summary) | Easier CI/log consumption | MEDIUM | Keep human-readable default output |

### Anti-Features (Commonly Requested, Often Problematic)

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Auto-install missing dependencies during verify run | Convenience | Hidden side effects and trust risk | Print actionable install guidance only |
| Automatic config rewriting during validation | Self-healing appeal | Unexpected mutations in operator dotfiles | Keep verification read-only |
| Monolithic "all-or-nothing" silent execution | Simplicity | Hard to debug failures | Show step-by-step status with explicit skipped checks |

## Feature Dependencies

```
[Validation Wrapper Command]
    ├──requires──> [Stable Check Catalog]
    ├──requires──> [Exit Code Contract]
    └──enhances──> [Compatibility Matrix Guidance]

[Compatibility Matrix]
    └──depends on──> [Verified check behavior on each environment]
```

### Dependency Notes

- **Validation wrapper requires stable check catalog:** command list must be explicit and versioned.
- **Compatibility matrix depends on verified behavior:** matrix should reflect actual command outcomes, not assumptions.
- **Exit code contract supports automation:** CI/manual operators rely on strict success/failure signaling.

## MVP Definition

### Launch With (v1.1)

- [ ] One command to run milestone reliability checks end-to-end.
- [ ] Deterministic output and exit-code behavior.
- [ ] Compatibility matrix for supported host/runtime combinations.

### Add After Validation (v1.1.x)

- [ ] Optional quick-mode execution path.
- [ ] Optional machine-readable output mode.

### Future Consideration (v2+)

- [ ] Auto-generated compatibility matrix from repeated check runs.
- [ ] Broader shell/editor matrix beyond zsh/tmux/vim baseline.

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Single command wrapper | HIGH | MEDIUM | P1 |
| Exit-code + summary contract | HIGH | MEDIUM | P1 |
| Compatibility matrix doc | HIGH | LOW | P1 |
| Quick mode | MEDIUM | LOW | P2 |
| Structured output mode | MEDIUM | MEDIUM | P2 |

**Priority key:**
- P1: Must have for this milestone
- P2: Should have, add when possible
- P3: Nice to have, future consideration

## Competitor Feature Analysis

| Feature | Conventional dotfiles repos | Reliability-focused tooling | Our Approach |
|---------|-----------------------------|-----------------------------|--------------|
| Validation entrypoint | Usually ad hoc manual commands | Scripted smoke suites | Add one explicit wrapper command |
| Compatibility guidance | Often implicit or absent | Matrix/checklist docs | Add matrix tied to executed checks |

## Sources

- `.planning/PROJECT.md` active requirements (`AUTO-01`, `AUTO-02`)
- Existing docs/contracts: `README.md`, `AGENTS.md`, `install.sh`, `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`
- Prior verification artifacts from milestone `v1.0`

---
*Feature research for: dotfiles reliability automation milestone*
*Researched: 2026-02-25*
