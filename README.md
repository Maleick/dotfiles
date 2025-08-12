# Red Team Dotfiles

This repository contains a set of dotfiles for `zsh`, `tmux`, and `vim`, tailored for red team operations. These configurations provide a powerful and efficient command-line environment with aliases, functions, and tools commonly used in penetration testing and red teaming.

## Installation

To install these dotfiles, run the following command:

```bash
./install.sh
```

This will copy the dotfiles to your home directory.

## Features

### Zsh (`.zshrc`)

*   **Custom Prompt:** The prompt is customized to show the `tun0` IP address, if available.
*   **Web Servers:** Aliases for starting simple HTTP and HTTPS servers.
*   **Nmap:** An alias for running a quick scan on the top 1000 TCP ports.
*   **Reverse Shells:** A function to generate various reverse shell one-liners (`bash`, `nc`, `python`, `perl`, `php`).
*   **Tool Check:** A function to check for the presence of common red team tools.

### Tmux (`.tmux.conf`)

*   **Custom Prefix:** The prefix is set to `C-a` (can be easily changed).
*   **Mouse Mode:** Mouse mode is enabled for easier navigation.
*   **Pane Logging:** A key binding to log pane output to a file.
*   **Session Management:** Key bindings for creating and switching between sessions and windows.

### Vim (`.vimrc`)

*   **Custom Theme:** A custom color scheme for better readability.
*   **Syntax Highlighting:** Syntax highlighting for common red team file types (`PowerShell`, `Python`, `Perl`, `Ruby`, `PHP`).
*   **Go Development:** Configuration for Go language server protocol (LSP) and common Go commands.