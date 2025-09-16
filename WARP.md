# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a red team-focused dotfiles repository that provides a comprehensive terminal environment optimized for penetration testing and security operations. The repository contains configurations for zsh, tmux, and vim with integrated tools, aliases, and automation tailored for cybersecurity professionals.

## Quick Installation

Install the dotfiles using the provided installation script:

```bash
cd /opt/dotfiles
./install.sh
```

The installation script will:
- Create a timestamped backup of existing dotfiles in `~/.dotfiles_backup_YYYYMMDDHHMMSS`
- Create symlinks from the dotfiles to your home directory
- Set up the following configurations: `.zshrc`, `.tmux.conf`, `.vimrc`

## Architecture Overview

The repository follows a modular structure:

```
/opt/dotfiles/
├── zsh/           # Shell configuration and red team aliases
├── tmux/          # Terminal multiplexer with logging capabilities  
├── vim/           # Editor with security plugins and Go development
├── install.sh     # Bootstrap script with backup functionality
└── README.md      # Comprehensive feature documentation
```

### Key Design Principles

- **Symlink-based**: Configurations are symlinked rather than copied, enabling easy updates
- **Non-destructive**: Existing dotfiles are backed up before installation
- **Red team optimized**: Tools, aliases, and workflows designed for security operations
- **Auto-maintenance**: Automated tool checking and Homebrew maintenance

## Shell Environment (zsh)

### Core Features

The zsh configuration provides a rich terminal environment with:

- **Red Team Shell branding**: Displays "Red Team Shell" banner using figlet and lolcat
- **Smart completions**: Case-insensitive tab completion with menu selection
- **History management**: 2000-line history with duplicate filtering
- **Syntax highlighting**: Zsh-syntax-highlighting with custom color scheme
- **Auto-suggestions**: Command suggestions based on history

### Red Team Aliases and Functions

| Command | Purpose | Usage |
|---------|---------|-------|
| `http-server` | Start HTTP server | `http-server [port]` (default: 8000) |
| `https-server` | Start HTTPS server | Requires cert.pem and key.pem files |
| `nmap-top-ports` | Quick port scan | `nmap-top-ports <target>` |
| `rev-shell` | Generate reverse shells | `rev-shell <type> <lhost> <lport>` |
| `/help` | Display help | Lists all custom commands |

### Reverse Shell Generator

The `rev-shell` function supports multiple payload types:
- `bash`: Bash reverse shell
- `nc`: Netcat reverse shell
- `python`: Python reverse shell
- `perl`: Perl reverse shell  
- `php`: PHP reverse shell

Example: `rev-shell bash 10.0.0.1 4444`


## Tmux Configuration

### Key Bindings

| Binding | Action |
|---------|--------|
| `Prefix + P` | Start/stop asciinema recording |
| `Prefix + N` | Create new session |
| `Prefix + p` | Previous window |
| `Prefix + n` | Next window |
| `h/j/k/l` | Vim-style pane navigation |
| `H/J/K/L` | Vim-style pane resizing |

### Recording Capabilities

- **Asciinema integration**: Records terminal sessions for documentation
- **Automatic logging**: Recordings saved to `~/Logs/asciinema-<window>-<timestamp>.cast`
- **Playback**: Use `asciinema play <filename>` to replay sessions

### Configuration Highlights

- 256-color terminal support with RGB overrides
- 10,000-line history buffer
- Mouse support enabled
- Activity monitoring across windows
- Custom status bar with magenta theme
- Base index starts at 1 (not 0)

## Vim Configuration

### Plugin Management

Uses vim-plug for plugin management. Install plugins with:
```vim
:PlugInstall
```

### Essential Plugins

- **dracula/vim**: Dark theme optimized for terminal work
- **fatih/vim-go**: Complete Go development environment
- **neoclide/coc.nvim**: Language server protocol support
- **scrooloose/nerdtree**: File explorer
- **tpope/vim-fugitive**: Git integration
- **vim-airline**: Enhanced status line

### Go Development Setup

After installing plugins, set up Go tools:
```vim
:GoUpdateBinaries
```

### Key Go Mappings

| Mapping | Action |
|---------|--------|
| `<leader>r` | Run Go program |
| `<leader>b` | Build Go program |
| `<leader>t` | Run Go tests |
| `<leader>c` | Toggle coverage |
| `<leader>e` | Rename symbol |

### Red Team File Support

Automatic filetype detection for:
- PowerShell scripts (`.ps1`)
- Python scripts (`.py`)
- Perl scripts (`.pl`)
- Ruby scripts (`.rb`)
- PHP scripts (`.php`)

## Development Workflow

### Initial Setup

1. Clone repository to `/opt/dotfiles`
2. Run `./install.sh` to install configurations
3. Open new terminal to load zsh configuration
4. Launch vim and run `:PlugInstall` for plugins

### Daily Usage

1. Use `/help` command to see available aliases
2. Start tmux sessions for organized work
3. Use `Prefix + P` to record important terminal sessions
4. Generate reverse shells with `rev-shell` function
5. Quick HTTP servers with `http-server` alias

### Updating Dotfiles

Since configurations are symlinked, updates are automatic:
```bash
cd /opt/dotfiles
git pull origin main
# Changes are immediately available in new terminals
```

### Backup and Restore

Dotfiles are backed up during installation to:
```
~/.dotfiles_backup_YYYYMMDDHHMMSS/
```

To restore previous configurations:
```bash
# Remove symlinks
rm ~/.zshrc ~/.tmux.conf ~/.vimrc

# Restore from backup
cp ~/.dotfiles_backup_*/.[zstv]* ~/
```

## Troubleshooting

### Common Issues

**Tool installation fails**: Ensure Homebrew is installed and updated
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Vim plugins not working**: Update and install plugins
```vim
:PlugUpdate
:PlugInstall
```

**Tmux recording fails**: Ensure ~/Logs directory exists and asciinema is installed
```bash
mkdir -p ~/Logs
brew install asciinema
```

**Zsh syntax highlighting missing**: Install via Homebrew
```bash
brew install zsh-syntax-highlighting zsh-autosuggestions
```

### Re-installation

To completely reinstall dotfiles:
```bash
cd /opt/dotfiles
# Remove existing symlinks
rm ~/.zshrc ~/.tmux.conf ~/.vimrc ~/.dotfiles
# Run installer again  
./install.sh
```

## Security and Operational Considerations

- All example commands use placeholder IPs (10.0.0.1, 192.168.1.1)
- Session recordings contain sensitive information - secure ~/Logs directory
- Consider operational security when using in sensitive environments
- Regular backups are created automatically during updates

## Dependencies

Required tools:
- zsh (shell)
- tmux (terminal multiplexer) 
- vim (editor)
- asciinema (terminal recording)
- figlet + lolcat (banner display)

Optional but recommended:
- nmap (network scanning)
- socat (network utility)
- gobuster (directory/DNS busting)
- feroxbuster (web fuzzer)
- zsh-syntax-highlighting
- zsh-autosuggestions

This configuration provides a professional red team terminal environment with comprehensive tooling, session management, and operational security considerations built-in.