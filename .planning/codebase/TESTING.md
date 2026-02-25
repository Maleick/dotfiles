# Testing Patterns

**Analysis Date:** 2026-02-25

## Test Framework

**Runner:**
- Automated test runner is `Not detected` in `/opt/dotfiles`.
- Test config files (`jest.config.*`, `vitest.config.*`, BATS config) are `Not detected` in `/opt/dotfiles`.

**Assertion Library:**
- Assertion library is `Not detected` in `/opt/dotfiles`.
- Assertion matcher conventions are `Not applicable` for current repo state.

**Run Commands:**
```bash
cd /opt/dotfiles && bash -n install.sh                                  # Parse-check `install.sh`
cd /opt/dotfiles && zsh -n zsh/.zshrc                                   # Parse-check `zsh/.zshrc`
cd /opt/dotfiles && tmux -f tmux/.tmux.conf start-server \; source-file tmux/.tmux.conf \; kill-server  # Parse-check `tmux/.tmux.conf`
cd /opt/dotfiles && ./install.sh                                         # Manual install smoke test from `README.md`
source ~/.zshrc && /help                                                 # Manual command-surface validation from `README.md`
```

## Test File Organization

**Location:**
- Dedicated automated test directories/files are `Not detected` in `/opt/dotfiles`.
- Current verification is manual and anchored to runtime config files `zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, and install script `install.sh`.

**Naming:**
- Unit test naming convention is `Not detected` in `/opt/dotfiles`.
- Integration test naming convention is `Not detected` in `/opt/dotfiles`.
- E2E test naming convention is `Not detected` in `/opt/dotfiles`.

**Structure:**
```
/opt/dotfiles/
  install.sh
  zsh/.zshrc
  tmux/.tmux.conf
  vim/.vimrc
  README.md
  AGENTS.md
```

## Test Structure

**Suite Organization:**
```text
Automated describe/it suite structure is Not applicable in `/opt/dotfiles`.
Manual validation flow follows docs in `README.md` and `AGENTS.md`:
1) Apply changes in repo files (`zsh/.zshrc`, `tmux/.tmux.conf`, `vim/.vimrc`, `install.sh`).
2) Re-run `./install.sh`.
3) Reload/restart target runtime (`source ~/.zshrc`, tmux reload, new Vim session).
4) Execute affected commands interactively (for example `/help`, `quickscan`, tmux keybinds).
```

**Patterns:**
- Use syntax parsing checks before runtime checks (`bash -n install.sh`, `zsh -n zsh/.zshrc`, tmux source-file parse for `tmux/.tmux.conf`).
- Validate behavior in real sessions as directed by `AGENTS.md` (new shell/tmux/Vim instance).
- Use direct command smoke tests from `README.md` examples (for example `/help`, `myip`, `webserver`) after reload.

## Mocking

**Framework:**
- Mocking framework is `Not detected` in `/opt/dotfiles`.
- Import/module mocking conventions are `Not applicable`.

**Patterns:**
```text
Mocking patterns are Not applicable because automated tests are Not detected in `/opt/dotfiles`.
```

**What to Mock:**
- Automated mock targets are `Not applicable` for current repo state.

**What NOT to Mock:**
- Automated mock exclusions are `Not applicable` for current repo state.

## Fixtures and Factories

**Test Data:**
```text
Shared fixture/factory files are Not detected in `/opt/dotfiles`.
```

**Location:**
- Fixture directories (`tests/fixtures`, `tests/factories`) are `Not detected` in `/opt/dotfiles`.

## Coverage

**Requirements:**
- Coverage threshold policy is `Not detected` in `/opt/dotfiles`.
- Coverage gate enforcement in CI is `Not detected` in `/opt/dotfiles`.

**Configuration:**
- Coverage tool configuration is `Not detected` in `/opt/dotfiles`.
- Coverage exclusions are `Not applicable` without a coverage runner.

**View Coverage:**
```bash
Not applicable in `/opt/dotfiles` (coverage tooling not detected).
```

## Test Types

**Unit Tests:**
- Automated unit tests are `Not detected` in `/opt/dotfiles`.
- Equivalent lightweight checks are syntax/parse commands for `install.sh`, `zsh/.zshrc`, and `tmux/.tmux.conf`.

**Integration Tests:**
- Integration behavior is manually validated by running `./install.sh` and verifying symlinked runtime behavior for `~/.zshrc`, `~/.tmux.conf`, and `~/.vimrc`.
- Manual integration verification steps are documented in `README.md` and `AGENTS.md`.

**E2E Tests:**
- Automated E2E framework is `Not detected` in `/opt/dotfiles`.
- Manual E2E-style validation is opening real shell/tmux/Vim sessions with configs from `zsh/.zshrc`, `tmux/.tmux.conf`, and `vim/.vimrc`.

## Common Patterns

**Async Testing:**
```text
Async test patterns are Not applicable; automated test code is Not detected in `/opt/dotfiles`.
```

**Error Testing:**
```text
Use manual negative-path checks in `zsh/.zshrc` helpers by invoking commands with missing args
(e.g., `quickscan`, `extract`, `findtext`, `rev-shell`) and confirming usage output plus non-zero return.
```

**Snapshot Testing:**
- Snapshot testing usage is `Not detected` in `/opt/dotfiles`.
- Snapshot storage directories (for example `__snapshots__/`) are `Not detected` in `/opt/dotfiles`.

---

*Testing analysis: 2026-02-25*
*Update when test patterns change*
