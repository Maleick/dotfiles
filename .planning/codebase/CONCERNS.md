# Codebase Concerns

**Analysis Date:** 2026-02-25

## Tech Debt

**Documentation and Runtime Drift (`README.md`, `AGENTS.md`, `CHANGELOG.md` vs runtime configs):**
- Files: `README.md`, `AGENTS.md`, `CHANGELOG.md`, `zsh/.zshrc`, `tmux/.tmux.conf`
- Current status: Partially mitigated by `scripts/verify-suite.sh` docs-anchor checks and refreshed `AGENTS.md` tmux/install guidance.
- Remaining risk: Historical planning and changelog records may intentionally describe older behavior; do not treat them as current runtime contracts without checking source files.
- Impact: Operators and future maintainers can implement against incorrect assumptions if stale historical notes are read as live guidance.
- Fix approach: Keep current contracts in `README.md`, `AGENTS.md`, source configs, and `.planning/codebase/*`; preserve older phase evidence as history unless intentionally re-baselined.

**Monolithic Configuration Surface (`zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`):**
- Files: `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`
- Issue: Most runtime behavior is centralized in three large files, so unrelated changes share the same failure domain.
- Why: Single-file dotfiles are simpler to distribute and reason about initially.
- Impact: Higher regression risk and slower review/debug cycles for incremental edits.
- Fix approach: Keep top-level files as entry points, but split optional sections into sourced fragments (for example `zsh/includes/*.zsh`, `tmux/conf.d/*.conf`, `vim/after/*.vim`) with section-level smoke checks.

**Resolved: Workspace Backup Artifact in Active Tree (`zsh/.zshrc.bak`):**
- Files: `.gitignore`
- Resolution: No `zsh/.zshrc.bak` file is present in the repo tree; backup suffixes remain ignored.
- Guard: Future backup snapshots should stay outside tracked source files.

## Known Bugs

**`base64decode` portability break on GNU systems:**
- Files: `zsh/.zshrc:258`
- Symptoms: `base64decode` fails on Linux with GNU `base64` because `-D` is unsupported.
- Trigger: Run `base64decode "<value>"` on non-macOS hosts.
- Workaround: Use `echo -n "<value>" | base64 -d`.
- Root cause: macOS-specific decode flag is hardcoded in shared shell config.
- Blocked by: Not applicable.

**Resolved: tmux copy-mode yank binding was macOS-only:**
- Files: `tmux/.tmux.conf`
- Resolution: Copy-mode `y` now selects the first available clipboard tool from `pbcopy`, `wl-copy`, `xclip`, `clip.exe`, then falls back to `tmux load-buffer -`.
- Guard: `scripts/verify-suite.sh` includes `req.tmux_clipboard_fallback`.

## Security Considerations

**Automatic sourcing of local shell overrides:**
- Files: `zsh/.zshrc`
- Risk: Arbitrary code execution or secret exfiltration if `$HOME/.zshrc.local` is tampered with.
- Current mitigation: Tracked shell config only sources `$HOME/.zshrc.local`; host-specific external loaders belong there and are excluded from git.
- Recommendations: Enforce strict file ownership/permissions checks before sourcing and document local override hygiene for sensitive hosts.

**Network-exposed helper servers with no guardrails:**
- Files: `zsh/.zshrc:242`, `zsh/.zshrc:279`, `zsh/.zshrc:282`, `tmux/.tmux.conf:143`
- Risk: Accidental exposure of local files/services on untrusted networks.
- Current mitigation: Operator awareness only.
- Recommendations: Default bind to loopback (`127.0.0.1`) and require explicit opt-in for remote exposure.

**Operational history artifacts can capture sensitive activity:**
- Files: `tmux/.tmux.conf:116`, `tmux/.tmux.conf:121`
- Risk: Pane history dumps in `$HOME/Logs` can retain credentials, target data, and command history.
- Current mitigation: Not detected.
- Recommendations: Create `$HOME/Logs` with restrictive permissions (`0700`), add redaction guidance, and consider optional encryption/rotation.

**Third-party IP lookup dependencies leak metadata:**
- Files: `zsh/.zshrc:229`, `zsh/.zshrc:231`, `zsh/.zshrc:232`, `zsh/.zshrc:342`
- Risk: External lookup services (`ifconfig.me`, `ipinfo.io`, `icanhazip.com`) can observe operator IP and request timing.
- Current mitigation: Multiple services for availability only.
- Recommendations: Provide a local/offline fallback mode and document privacy implications in `README.md`.

## Performance Bottlenecks

**Shell startup does work on every interactive launch:**
- Files: `zsh/.zshrc:31`, `zsh/.zshrc:72`, `zsh/.zshrc:133`, `zsh/.zshrc:265`
- Problem: Banner rendering, completion initialization, and plugin sourcing happen during startup.
- Measurement: Not detected.
- Cause: Startup path favors immediate feature availability over lazy loading.
- Improvement path: Gate heavy features behind interactive checks and lazy-load optional components after first prompt.

**Vim startup depends on many external plugins and hooks:**
- Files: `vim/.vimrc:63`, `vim/.vimrc:74`, `vim/.vimrc:78`, `vim/.vimrc:82`, `vim/.vimrc:83`, `vim/.vimrc:84`
- Problem: Plugin count and initialization complexity can increase startup latency and failure surfaces.
- Measurement: Not detected.
- Cause: Broad plugin set is loaded at editor startup via `vim-plug`.
- Improvement path: Defer nonessential plugins, pin versions, and periodically prune unused entries.

## Fragile Areas

**Resolved: installer path resolution depended on current directory:**
- Files: `install.sh`, `scripts/verify-suite.sh`
- Resolution: `DOTFILES_DIR` now resolves from `${BASH_SOURCE[0]}` so the installer can be invoked from any current directory.
- Guard: `scripts/verify-suite.sh` includes `req.install_script_dir`.

**Platform-sensitive shell commands embedded in common aliases/functions:**
- Files: `zsh/.zshrc:233`, `zsh/.zshrc:240`, `zsh/.zshrc:258`, `zsh/.zshrc:343`, `zsh/.zshrc:345`
- Why fragile: Mixed macOS/Linux command assumptions (`ipconfig`, `scutil`, `lsof`, `base64 -D`) increase portability risk.
- Common failures: Commands silently fail or produce empty output on unsupported hosts.
- Safe modification: Add command capability checks and per-platform branches per function/alias.
- Test coverage: Not detected.

**Resolved: complex tmux command quoting in session-switch and capture logic:**
- Files: `tmux/.tmux.conf`, `scripts/verify-suite.sh`
- Resolution: Removed external capture and fuzzy session-switch pipelines; session switching now uses built-in `choose-tree`, and history capture uses tmux buffer commands.
- Guard: `scripts/verify-suite.sh` includes `req.tmux_no_asciinema_fzf`.

## Scaling Limits

**Manual command catalog maintenance in `zsh/.zshrc`:**
- Files: `zsh/.zshrc`, `README.md`, `CHANGELOG.md`, `AGENTS.md`
- Current capacity: Not detected.
- Limit: Maintaining parity between aliases/functions and docs does not scale as command count grows.
- Symptoms at limit: Feature drift and stale operator guidance.
- Scaling path: Generate docs/help output from a single source-of-truth command registry.

**Single-user, manual dependency bootstrap model:**
- Files: `README.md:20`, `install.sh`, `tmux/.tmux.conf`, `vim/.vimrc`
- Current capacity: Not detected.
- Limit: Onboarding many hosts/operators requires repeated manual dependency installs (`tmux`, `vim-plug`, `aliasr`, `nmap`).
- Symptoms at limit: Environment inconsistencies and setup failures across machines.
- Scaling path: Add a non-destructive preflight checker for required binaries and plugin prerequisites.

## Dependencies at Risk

**Unpinned Vim plugin sources and legacy plugin identifiers:**
- Files: `vim/.vimrc:74`, `vim/.vimrc:82`, `vim/.vimrc:83`, `vim/.vimrc:84`
- Risk: Upstream changes, deprecations, or repository moves can break installs/startup unexpectedly.
- Impact: Editing workflows and language tooling fail or degrade.
- Migration plan: Pin plugin commits and replace legacy references with maintained equivalents where needed.

**External binary/runtime assumptions for core workflows:**
- Files: `zsh/.zshrc`, `tmux/.tmux.conf`, `README.md`
- Risk: Missing tools (`aliasr`, `nmap`, `python3`) cause command/keybinding failures.
- Impact: Inconsistent operator experience and troubleshooting overhead.
- Migration plan: Add startup/preflight dependency checks with clear remediation hints.

## Missing Critical Features

**Automated validation for dotfile changes:**
- Files: `scripts/verify-suite.sh`, `README.md`, `AGENTS.md`
- Current status: Present. The wrapper checks install syntax/path contract, zsh syntax, host-specific zsh tail absence, tmux config load, tmux clipboard fallback, absence of removed optional tmux/Vim dependencies, Vim startup, docs anchors, and public docs surface files.
- Remaining gap: The wrapper is still a smoke suite, not a full unit/integration framework for every helper behavior.
- Implementation complexity for broader coverage: Medium.

**Non-destructive compatibility test command:**
- Files: `install.sh`, `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`
- Problem: No single command verifies dependencies and platform compatibility before adoption.
- Current workaround: Trial-and-error after install.
- Blocks: Predictable onboarding and repeatable environment setup.
- Implementation complexity: Medium.

**Documentation consistency guard:**
- Files: `README.md`, `AGENTS.md`, `CHANGELOG.md`, `zsh/.zshrc`, `tmux/.tmux.conf`
- Problem: Runtime/doc drift is not detected automatically.
- Current workaround: Manual review discipline.
- Blocks: Trustworthy operator documentation.
- Implementation complexity: Low to Medium.

## Test Coverage Gaps

**Installer safety and idempotency paths:**
- Files: `install.sh`
- What's not tested: Repeated installs and backup correctness under varied destination states. Non-root invocation path behavior is guarded by `req.install_script_dir`.
- Risk: Symlink mis-targeting or unintended file moves can go unnoticed.
- Priority: High.
- Difficulty to test: Medium.

**Cross-platform command compatibility in shell helpers:**
- Files: `zsh/.zshrc`
- What's not tested: macOS/Linux behavior differences for `base64decode`, `localip`, `netinfo`, clipboard/network helpers.
- Risk: Commands fail on some hosts despite cross-platform claims in docs.
- Priority: High.
- Difficulty to test: Medium.

**Tmux keybinding behavior with optional dependencies:**
- Files: `tmux/.tmux.conf`
- What's not tested: `Prefix + S`, `Prefix + s`, `Prefix + U`, and `Prefix + K` behavior across environments. Clipboard fallback presence is guarded by `req.tmux_clipboard_fallback`.
- Risk: Silent failures in core workflows.
- Priority: Medium.
- Difficulty to test: Medium.

---

*Concerns audit: 2026-02-25*
*Update as issues are fixed or new ones discovered*
