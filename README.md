# Red Team Dotfiles

This repository contains a set of dotfiles for `zsh`, `tmux`, and `vim`, tailored for red team operations. These configurations provide a powerful and efficient command-line environment with aliases, functions, and tools commonly used in penetration testing and red teaming.

## Dependencies

These dotfiles require the following tools to be installed on your system:

*   [Zsh](https://www.zsh.org/)
*   [Tmux](https://github.com/tmux/tmux/wiki)
*   [Vim](https://www.vim.org/)
*   [Asciinema](https://asciinema.org/)

## Installation

To install these dotfiles, run the following command:

```bash
./install.sh
```

This will create symbolic links to the dotfiles in your home directory and back up any existing dotfiles to a timestamped directory (e.g., `~/.dotfiles_backup_YYYYMMDDHHMMSS`).

## Features

### Zsh (`.zshrc`)

*   **Automated Tool Installation:** The shell will automatically check for and prompt you to install missing tools using Homebrew, Pip, and Gem.
*   **Automated Homebrew Maintenance:** The shell will automatically run `brew update`, `brew upgrade`, and `brew cleanup -s` once a day to keep your Homebrew packages up-to-date.
*   **Custom Prompt:** The prompt is customized to show the `tun0` IP address, if available.
*   **Web Servers:** Aliases for starting simple HTTP and HTTPS servers.
*   **Nmap:** An alias for running a quick scan on the top 1000 TCP ports.
*   **Reverse Shells:** A function to generate various reverse shell one-liners (`bash`, `nc`, `python`, `perl`, `php`).
*   **Help Command:** A `/help` command to display a list of all the custom aliases, functions, and key bindings.

### Tmux (`.tmux.conf`)

*   **Manual `asciinema` Recording:** Press `Prefix + P` to start an `asciinema` recording of the current pane.
    *   Recordings (`.cast` files) are saved in the `~/Logs` directory.
    *   To stop recording, exit the pane or press `Prefix + P` again.
    *   You can play back these recordings with `asciinema play <filename>`. For example: `asciinema play ~/Logs/asciinema-mywindow-20250812123456.cast`.

### Vim (`.vimrc`)

*   **Custom Theme:** A custom color scheme for better readability.
*   **Syntax Highlighting:** Syntax highlighting for common red team file types (`PowerShell`, `Python`, `Perl`, `Ruby`, `PHP`).
*   **Go Development:** Configuration for Go language server protocol (LSP) and common Go commands.