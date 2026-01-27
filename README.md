# jcaldwell-labs Contributor Setup

Standardized development environment for WSL Debian contributors.

## Quick Start

```bash
# (Optional) Create jcdev user if not exists
sudo useradd -m -s /bin/bash -G sudo,docker jcdev
sudo passwd jcdev
su - jcdev

# Clone the repository
git clone https://github.com/jcaldwell-labs/contributor-setup.git
cd contributor-setup

# Install dot files
./bootstrap.sh

# Install vim plugins
vim +PlugInstall +qall

# (Optional) Install development tools
./scripts/install-tools.sh
```

## What's Included

### Dot Files

| File | Source | Purpose |
|------|--------|---------|
| `.tmux.conf` | be-dev-agent | Terminal multiplexer with vim-style navigation |
| `.vimrc` | javadev | Minimal vim with fzf, NERDTree, gruvbox |
| `.bashrc-additions` | Composite | Shell enhancements (sourced from .bashrc) |

### Features

**tmux**:
- `Ctrl-a` prefix (ergonomic)
- Mouse support
- Vim-style pane navigation (`hjkl`)
- 50k line scrollback
- Splits preserve current directory

**vim**:
- vim-plug (auto-installs plugins)
- fzf fuzzy finder (`Ctrl+P`)
- NERDTree file browser (`,n`)
- gruvbox dark theme
- System clipboard integration

**Shell**:
- Prompt toggle for Claude Code (`prompt-min` / `prompt-full`)
- Git shortcuts (`gs`, `ga`, `gc`, `gp`, `gl`)
- Java version switching (`java17`, `java21`)
- my-context integration (if installed)

## Configuration Details

### Prompt Toggle

Switch between minimal (agent-friendly) and full (developer) prompts:

```bash
prompt-min   # Green user@host:path$  (for Claude Code)
prompt-full  # user@host:path (branch)$  (for development)
prompt-toggle  # Switch between modes
```

### Vim Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl+P` | Find files (fzf) |
| `Ctrl+F` | Grep content (ripgrep) |
| `,b` | List buffers |
| `,n` | Toggle NERDTree |
| `,w` | Save |
| `,q` | Quit |
| `,/` | Clear search highlight |

### tmux Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl-a + \|` | Split vertically |
| `Ctrl-a + -` | Split horizontally |
| `Ctrl-a + hjkl` | Navigate panes |
| `Alt + Arrow` | Navigate panes (no prefix) |
| `Ctrl-a + z` | Zoom pane |
| `Ctrl-a + G` | Git status popup |
| `Ctrl-a + r` | Reload config |

## Dependencies

**Required** (installed by `install-tools.sh`):
- `fzf` - Fuzzy finder
- `fd-find` - Fast file finder
- `ripgrep` - Fast grep
- `vim` 8.0+ - Editor with plugin support

**Optional**:
- `glow` - Markdown viewer
- `gh` - GitHub CLI
- Java 21 (OpenJDK LTS) - For Java projects
- Rust - For CLI tools and Rust projects

## Customization

### Local Overrides

Create these files for personal customizations (not tracked by git):

```bash
~/.bashrc.local     # Additional bash config
~/.vimrc.local      # Project-specific vim settings (auto-loaded)
```

### Modifying Configs

The bootstrap script creates symlinks. To customize:

**Option 1**: Edit files in this repo and re-run `./bootstrap.sh`

**Option 2**: Break symlink and maintain your own copy:
```bash
rm ~/.tmux.conf
cp contributor-setup/configs/tmux.conf ~/.tmux.conf
# Now edit ~/.tmux.conf directly
```

## Directory Structure

```
contributor-setup/
├── README.md              # This file
├── bootstrap.sh           # Main setup script
├── configs/
│   ├── tmux.conf          # tmux configuration
│   ├── vimrc              # vim configuration
│   └── bashrc-additions   # Shell additions
├── docs/
│   ├── audit-findings.md  # Config inventory
│   └── gap-analysis.md    # PR comparison
└── scripts/
    └── install-tools.sh   # Tool installer
```

## For WSL Users

### wsl.conf (System Config)

Copy to `/etc/wsl.conf` (requires sudo):

```ini
[boot]
systemd=true

[interop]
appendWindowsPath = false
```

**Note**: `appendWindowsPath=false` keeps Linux PATH clean. Enable if you need Windows executables.

### Restart WSL

After changing wsl.conf:
```powershell
# From Windows PowerShell
wsl --shutdown
```

## Troubleshooting

### vim plugins not loading

```bash
# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins
vim +PlugInstall +qall
```

### fzf not finding files

Ensure `fd-find` is installed and symlinked:
```bash
sudo apt install fd-find
mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd
```

### tmux colors wrong

Ensure terminal supports 256 colors:
```bash
echo $TERM  # Should be xterm-256color or similar
```

## Contributing

See [docs/audit-findings.md](docs/audit-findings.md) for configuration sources and rationale.

## License

MIT
