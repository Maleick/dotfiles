# Red Team Dotfiles

A comprehensive set of dotfiles optimized for red team operations and penetration testing. These configurations provide a powerful, efficient, and modern command-line environment with extensive tooling for security professionals.

## ✨ Key Features

- 🎯 **Warp Terminal Optimized**: Enhanced performance and theming for [Warp](https://warp.dev)
- 🔴 **Red Team Focused**: 30+ specialized aliases and functions for pentesting
- 🎨 **Modern Dark Theme**: Consistent styling across zsh, tmux, and vim
- ⚡ **High Performance**: Optimized for speed and terminal responsiveness
- 🛠️ **Comprehensive Tooling**: Network scanning, encoding/decoding, web servers, and more

## 📋 Dependencies

### Required
- [Zsh](https://www.zsh.org/) - Shell
- [Tmux](https://github.com/tmux/tmux/wiki) - Terminal multiplexer
- [Vim](https://www.vim.org/) - Editor
- [Asciinema](https://asciinema.org/) - Terminal recording

### Recommended
- [FZF](https://github.com/junegunn/fzf) - Fuzzy finder
- [Ripgrep](https://github.com/BurntSushi/ripgrep) - Fast text search
- Nerd Fonts - For proper icon display
- zsh-syntax-highlighting & zsh-autosuggestions

## Installation

To install these dotfiles, run the following command:

```bash
./install.sh
```

This will create symbolic links to the dotfiles in your home directory and back up any existing dotfiles to a timestamped directory (e.g., `~/.dotfiles_backup_YYYYMMDDHHMMSS`).

## 🚀 Quick Start

```bash
git clone https://github.com/Maleick/dotfiles.git
cd dotfiles
./install.sh
```

The installer will:
- Create backups of existing dotfiles (timestamped)
- Create symbolic links to the new configurations
- Set up the `~/.dotfiles` directory

## 🔧 Configuration Details

### 💻 Zsh (`.zshrc`) - Red Team Shell

#### 🔍 Network & Reconnaissance
- `myip` / `localip` - Get external/internal IP addresses
- `netinfo` - Comprehensive network information
- `quickscan <target>` - Fast nmap port scan (-T4 -F)
- `nmap-top-ports <target>` - Scan top 1000 TCP ports
- `ports` / `listening` - Show open/listening ports

#### 🌐 Web Servers & Services
- `http-server` / `webserver` - Start HTTP server (8000/8080)
- `https-server` - HTTPS server (requires certs)
- `smbserver` - SMB server in current directory

#### 📜 Encoding & Utilities
- `base64encode/decode <text>` - Base64 encoding/decoding
- `urlencode/decode <text>` - URL encoding/decoding
- `rot13` - ROT13 cipher
- `hexdump <file>` - Hex dump utility
- `extract <file>` - Universal archive extractor
- `findtext <term> [dir]` - Search text in files

#### 🛠️ Red Team Tools
- `rev-shell <type> <lhost> <lport>` - Generate reverse shells
  - Types: `bash`, `nc`, `python`, `perl`, `php`
- Enhanced `ls` aliases: `ll`, `la`, `lt`, `lh`
- Smart prompt with Warp detection
- 10,000-line command history with smart deduplication
- `/help` - Comprehensive emoji-categorized help system

### 🎥 Tmux (`.tmux.conf`) - Session Management

#### 🎨 Modern Red Team Theme
- Dark catppuccin-inspired color scheme
- Lightning bolt (⚡) session indicator
- Performance optimizations for Warp

#### 📹 Recording & Logging
- `Prefix + P` - Toggle asciinema recording with visual feedback
- `Prefix + S` - Save pane history to `~/Logs/`
- Timestamped recording files

#### ⌨️ Enhanced Navigation
- `Prefix + |` / `Prefix + -` - Intuitive window splitting
- `Prefix + h/j/k/l` - Vim-style pane navigation
- `Prefix + H/J/K/L` - Pane resizing (repeatable)
- `Prefix + Tab` - Quick pane cycling

#### 🛠️ Red Team Shortcuts
- `Prefix + Ctrl+n` - Quick nmap in new window
- `Prefix + Ctrl+g` - Launch gobuster
- `Prefix + Ctrl+s` - Start HTTP server

### 🎨 Vim (`.vimrc`) - Code Editor

#### 🎆 Warp Terminal Optimization
- True color support with automatic detection
- Performance tuning for large files
- Modern theme hierarchy: Catppuccin → Dracula → Molokai

#### 📚 Enhanced Plugin Suite
- **FZF Integration**: `Ctrl+p` (files), `Ctrl+f` (ripgrep), `<leader>b` (buffers)
- **NERDTree**: `Ctrl+n` with git integration
- **Language Support**: Go, Python, Ruby, PHP, PowerShell, Markdown
- **COC.nvim**: Intelligent code completion and LSP
- **Vim-airline**: Enhanced status line with git integration

#### 🛠️ Red Team Features
- File type detection for security scripts and configs
- Quick templates: `<leader>rs` (reverse shell), `<leader>py` (Python header)
- Markdown support for report writing
- Python PEP 8 compliance (88-char line length)
- Enhanced search: `F8` highlights word under cursor
- Smart split navigation: `Ctrl+h/j/k/l`

## 📚 Usage Examples

### Quick Network Reconnaissance
```bash
netinfo                    # Get network overview
quickscan 192.168.1.0/24   # Fast subnet scan
myip && localip            # Show IP addresses
```

### Instant Web Server
```bash
webserver                  # HTTP server on port 8080
smbserver                  # SMB share current directory
```

### Encoding/Decoding
```bash
base64encode "test data"   # dGVzdCBkYXRh
urlencode "hello world"    # hello%2Bworld
```

### Tmux Session Recording
```bash
tmux                       # Start tmux
# Prefix + P              # Start/stop recording
# Prefix + S              # Save history
```

## 🔒 Security Considerations

- **History Management**: Commands starting with space are not logged (OPSEC)
- **Session Recording**: Recordings may contain sensitive data - secure `~/Logs/`
- **Placeholder IPs**: All examples use non-routable addresses (10.0.0.1, 192.168.1.x)
- **Network Tools**: Use responsibly and only on authorized systems
- **Backup Safety**: Installation creates timestamped backups of existing configs

## 🔄 Updates & Maintenance

### Keep Dotfiles Updated
```bash
cd ~/.dotfiles
git pull origin master
# Restart terminal or source ~/.zshrc
```

### Restore Previous Configuration
```bash
# Find your backup
ls -la ~/.dotfiles_backup_*

# Remove current symlinks
rm ~/.zshrc ~/.tmux.conf ~/.vimrc

# Restore from backup
cp ~/.dotfiles_backup_TIMESTAMP/.* ~/
```

## 📝 File Structure

```
dotfiles/
├── install.sh          # Installation script
├── README.md           # This file
├── zsh/
│   └── .zshrc          # Zsh configuration
├── tmux/
│   └── .tmux.conf      # Tmux configuration  
└── vim/
    └── .vimrc          # Vim configuration
```

## ⚖️ License

This project is provided as-is for educational and authorized security testing purposes. Users are responsible for compliance with applicable laws and regulations.

## 🎆 Acknowledgments

- [Warp Terminal](https://warp.dev) - For the amazing terminal experience
- [Catppuccin](https://catppuccin.com) - For the beautiful color palette inspiration
- [Dracula Theme](https://draculatheme.com) - For the classic dark theme
- The security community - For continuous inspiration and tools

---

🔴 **Happy Red Teaming!** 🔴
