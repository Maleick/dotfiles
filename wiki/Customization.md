# Customization

Keep machine-specific paths, secrets, and installer-added shell snippets in `~/.zshrc.local`.

Example:

```bash
export MY_API_KEY="redacted"
export CUSTOM_TOOL_HOME="$HOME/.custom-tool"
export PATH="$CUSTOM_TOOL_HOME/bin:$PATH"
```

The tracked `zsh/.zshrc` automatically sources `~/.zshrc.local` when it exists. Do not commit host-specific paths or secrets into this repo.
