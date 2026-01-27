# contributor-setup

A curated collection of dot files and WSL configurations optimized for contributing to jcaldwell-labs projects. This repository provides a consistent development environment setup across all contributors.

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/jcaldwell-labs/contributor-setup.git
cd contributor-setup

# Run the setup script to install dot files
./setup.sh

# (Optional) Install common development tools
./install-tools.sh
```

## 📦 What's Included

### Dot Files

- **`.bashrc`** - Enhanced Bash configuration with:
  - Colorful prompt
  - Useful aliases for git, navigation, and development
  - Extended history settings
  - Bash completion support

- **`.gitconfig`** - Git configuration with:
  - Helpful aliases (st, lg, amend, undo, etc.)
  - Colorized output
  - Sensible defaults for pull and push behavior

- **`.vimrc`** - Vim editor configuration with:
  - Syntax highlighting and line numbers
  - Smart indentation
  - Useful key mappings
  - File-type specific settings

- **`.tmux.conf`** - Terminal multiplexer configuration with:
  - Intuitive key bindings
  - Mouse support
  - Vim-like pane navigation
  - Status bar customization

### WSL Configuration Files

- **`wsl.conf`** - WSL system configuration
  - Systemd support
  - Network settings
  - Windows interoperability
  - Drive mounting options

- **`.wslconfig`** - Global WSL 2 settings
  - Memory and CPU limits
  - Swap configuration
  - Performance optimizations

### Setup Scripts

- **`setup.sh`** - Automated installation script that creates symlinks for all dot files
- **`install-tools.sh`** - Installs common development tools (git, vim, tmux, python, node, docker, etc.)

## 🔧 Installation

### Standard Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/jcaldwell-labs/contributor-setup.git
   cd contributor-setup
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```
   This will create symlinks from your home directory to the dot files in this repository.

3. Configure Git with your personal information:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

4. Restart your shell or source the new configuration:
   ```bash
   source ~/.bashrc
   ```

### WSL-Specific Setup

For WSL users, additional steps are needed:

1. Copy `wsl.conf` to your WSL distribution (requires sudo):
   ```bash
   sudo cp wsl.conf /etc/wsl.conf
   ```

2. Copy `.wslconfig` to your Windows user directory:
   ```bash
   # Adjust the username as needed
   cp .wslconfig /mnt/c/Users/$USER/.wslconfig
   ```

3. Restart WSL for changes to take effect:
   ```powershell
   # From PowerShell on Windows
   wsl --shutdown
   ```

### Installing Development Tools

Optionally, install common development tools:

```bash
./install-tools.sh
```

This will install:
- Build essentials (gcc, g++, make)
- Git
- Vim and Tmux
- Python 3 and pip
- Node.js and npm
- Docker
- GitHub CLI (gh)
- Various utilities (curl, wget, jq, zip, unzip)

## 🎨 Customization

### Local Overrides

You can create local customization files that won't be tracked by git:

- **`~/.bashrc.local`** - Additional bash configurations
- **`~/.gitconfig.local`** - Additional git configurations

These files are automatically loaded if they exist.

### Modifying Configurations

Since the setup script creates symlinks, you can:

1. Edit files directly in the repository
2. Commit your changes
3. Push to share with other contributors

Or, you can break the symlink and maintain your own version:

```bash
rm ~/.bashrc
cp contributor-setup/.bashrc ~/.bashrc
# Now edit ~/.bashrc directly
```

## 📋 Key Features

### Bash Aliases

Common aliases included in `.bashrc`:

- **Navigation**: `..`, `...`, `ll`, `la`
- **Git**: `gs`, `ga`, `gc`, `gp`, `gl`, `gd`, `gco`, `gb`
- **Safety**: `rm -i`, `cp -i`, `mv -i`
- **Development**: `py`, `pip`

### Git Aliases

Useful git aliases from `.gitconfig`:

- `git st` - Short status
- `git lg` - Beautiful log graph
- `git amend` - Amend last commit without editing message
- `git undo` - Undo last commit (keeps changes)
- `git aliases` - List all git aliases

### Tmux Key Bindings

Custom tmux bindings from `.tmux.conf`:

- Prefix key: `Ctrl-a` (instead of `Ctrl-b`)
- Split panes: `|` (vertical) and `-` (horizontal)
- Pane navigation: `Alt-Arrow` or vim-style `h`/`j`/`k`/`l`
- Reload config: `Ctrl-a r`

## 🤝 Contributing

Contributions are welcome! If you have improvements or additional configurations:

1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💡 Tips

- Regularly pull updates from this repository to get the latest configurations
- Back up your existing dot files before running the setup script
- Customize settings in `.local` files to avoid conflicts with updates
- Use `git config --global` to set personal git settings that override the defaults

## 🐛 Troubleshooting

### Symlinks not working

If symlinks aren't created properly:
```bash
# Remove broken symlinks
rm ~/.bashrc ~/.gitconfig ~/.vimrc ~/.tmux.conf

# Re-run setup
./setup.sh
```

### WSL configuration not applying

Make sure you've restarted WSL after copying configuration files:
```powershell
wsl --shutdown
```

### Permission issues

Ensure scripts are executable:
```bash
chmod +x setup.sh install-tools.sh
```
