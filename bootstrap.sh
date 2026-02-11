#!/bin/bash
# ====================================
# jcaldwell-labs Contributor Environment Bootstrap
# ====================================
# Sets up ~jcdev with curated configs from be-dev-agent, javadev, and PR #1
# Run: ./bootstrap.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║     jcaldwell-labs Contributor Environment Setup       ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ====================================
# HELPER FUNCTIONS
# ====================================

create_symlink() {
    local source="$1"
    local target="$2"

    if [ -L "$target" ]; then
        echo -e "${YELLOW}  Removing existing symlink: $target${NC}"
        rm "$target"
    elif [ -e "$target" ]; then
        echo -e "${YELLOW}  Backing up: $target -> $target.backup${NC}"
        mv "$target" "$target.backup"
    fi

    ln -s "$source" "$target"
    echo -e "${GREEN}  Linked: $target -> $source${NC}"
}

copy_file() {
    local source="$1"
    local target="$2"

    if [ -e "$target" ]; then
        echo -e "${YELLOW}  Backing up: $target -> $target.backup${NC}"
        mv "$target" "$target.backup"
    fi

    cp "$source" "$target"
    echo -e "${GREEN}  Copied: $target${NC}"
}

# ====================================
# PRE-FLIGHT CHECKS
# ====================================
echo -e "${CYAN}=== Pre-flight Checks ===${NC}"

# Check if configs exist
if [ ! -d "$SCRIPT_DIR/configs" ]; then
    echo -e "${RED}Error: configs/ directory not found.${NC}"
    exit 1
fi

# List what will be installed
echo "This will install:"
echo "  - ~/.tmux.conf     (tmux configuration)"
echo "  - ~/.vimrc         (vim configuration with vim-plug)"
echo "  - ~/.bashrc-additions (optional shell enhancements)"
echo ""
echo "Existing files will be backed up with .backup extension."
echo ""

read -p "Continue? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# ====================================
# INSTALL DOT FILES
# ====================================
echo ""
echo -e "${CYAN}=== Installing Dot Files ===${NC}"

# tmux
if [ -f "$SCRIPT_DIR/configs/tmux.conf" ]; then
    echo -e "${GREEN}Installing tmux config...${NC}"
    create_symlink "$SCRIPT_DIR/configs/tmux.conf" "$HOME/.tmux.conf"
fi

# vim
if [ -f "$SCRIPT_DIR/configs/vimrc" ]; then
    echo -e "${GREEN}Installing vim config...${NC}"
    create_symlink "$SCRIPT_DIR/configs/vimrc" "$HOME/.vimrc"
fi

# bashrc-additions (copy, don't symlink - user may customize)
if [ -f "$SCRIPT_DIR/configs/bashrc-additions" ]; then
    echo -e "${GREEN}Installing bashrc-additions...${NC}"
    copy_file "$SCRIPT_DIR/configs/bashrc-additions" "$HOME/.bashrc-additions"
    echo -e "${YELLOW}  Note: ~/.bashrc-additions is copied (not symlinked) for customization.${NC}"
    echo -e "${YELLOW}  Re-run bootstrap.sh to get updates (existing file backed up).${NC}"
fi

# ====================================
# CONFIGURE BASH TO SOURCE ADDITIONS
# ====================================
echo ""
echo -e "${CYAN}=== Configuring Shell ===${NC}"

# Add source line to .bashrc if not already present
BASHRC_SOURCE='[ -f ~/.bashrc-additions ] && source ~/.bashrc-additions'
if ! grep -q "bashrc-additions" "$HOME/.bashrc" 2>/dev/null; then
    echo "" >> "$HOME/.bashrc"
    echo "# jcaldwell-labs contributor additions" >> "$HOME/.bashrc"
    echo "$BASHRC_SOURCE" >> "$HOME/.bashrc"
    echo -e "${GREEN}Added bashrc-additions source to ~/.bashrc${NC}"
else
    echo -e "${YELLOW}~/.bashrc already sources bashrc-additions${NC}"
fi

# ====================================
# ENSURE ~/.local/bin EXISTS
# ====================================
mkdir -p "$HOME/.local/bin"

# Add ~/.local/bin to PATH if not present
if ! grep -q '\.local/bin' "$HOME/.bashrc" 2>/dev/null; then
    echo '' >> "$HOME/.bashrc"
    echo '# User local bin' >> "$HOME/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo -e "${GREEN}Added ~/.local/bin to PATH in ~/.bashrc${NC}"
fi

# ====================================
# VIM-PLUG SETUP
# ====================================
echo ""
echo -e "${CYAN}=== Setting Up vim-plug ===${NC}"

# Check if vim is installed
if command -v vim &>/dev/null; then
    # vim-plug will auto-install on first vim launch (per vimrc)
    # But we can pre-install it for faster first launch
    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        echo "Downloading vim-plug..."
        curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        echo -e "${GREEN}vim-plug installed.${NC}"
        echo -e "${YELLOW}Run 'vim +PlugInstall +qall' to install vim plugins.${NC}"
    else
        echo -e "${YELLOW}vim-plug already installed.${NC}"
    fi
else
    echo -e "${YELLOW}vim not installed. Skipping vim-plug setup.${NC}"
fi

# ====================================
# GIT CONFIGURATION PROMPT
# ====================================
echo ""
echo -e "${CYAN}=== Git Configuration ===${NC}"

# Check if git user is configured
if ! git config --global user.name &>/dev/null; then
    echo "Git user not configured."
    read -p "Enter your name for git commits: " git_name
    read -p "Enter your email for git commits: " git_email

    if [ -n "$git_name" ] && [ -n "$git_email" ]; then
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        echo -e "${GREEN}Git user configured.${NC}"
    fi
else
    echo -e "${YELLOW}Git already configured as: $(git config --global user.name) <$(git config --global user.email)>${NC}"
fi

# Set sensible git defaults
git config --global init.defaultBranch main 2>/dev/null || true
git config --global pull.rebase false 2>/dev/null || true

# ====================================
# COMPLETION
# ====================================
echo ""
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                   Setup Complete!                      ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo "Installed:"
echo "  ~/.tmux.conf         - tmux configuration"
echo "  ~/.vimrc             - vim configuration"
echo "  ~/.bashrc-additions  - shell enhancements"
echo ""
echo -e "${CYAN}Next Steps:${NC}"
echo ""
echo "1. Restart your shell or run:"
echo "   ${GREEN}source ~/.bashrc${NC}"
echo ""
echo "2. Install vim plugins:"
echo "   ${GREEN}vim +PlugInstall +qall${NC}"
echo ""
echo "3. (Optional) Install development tools:"
echo "   ${GREEN}./scripts/install-tools.sh${NC}"
echo ""
echo "4. Verify tmux config:"
echo "   ${GREEN}tmux${NC}"
echo ""
echo -e "${CYAN}Quick Reference:${NC}"
echo "  prompt-min    - Minimal prompt (for Claude Code)"
echo "  prompt-full   - Full prompt (with git branch)"
echo "  Ctrl+P in vim - Fuzzy file finder"
echo "  Ctrl-a + |    - Split tmux pane vertically"
echo ""
