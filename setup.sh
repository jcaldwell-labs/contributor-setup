#!/bin/bash
# Setup script for jcaldwell-labs contributor environment
# This script creates symlinks from the repository to your home directory

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== jcaldwell-labs Contributor Setup ===${NC}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -L "$target" ]; then
        echo -e "${YELLOW}Removing existing symlink: $target${NC}"
        rm "$target"
    elif [ -e "$target" ]; then
        echo -e "${YELLOW}Backing up existing file: $target -> $target.backup${NC}"
        mv "$target" "$target.backup"
    fi
    
    ln -s "$source" "$target"
    echo -e "${GREEN}Created symlink: $target -> $source${NC}"
}

# Symlink dot files
echo -e "${GREEN}Setting up dot files...${NC}"
create_symlink "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
create_symlink "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
create_symlink "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc"
create_symlink "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

echo ""
echo -e "${GREEN}=== Setup Complete! ===${NC}"
echo ""
echo "Next steps:"
echo "1. Update .gitconfig with your name and email:"
echo "   git config --global user.name \"Your Name\""
echo "   git config --global user.email \"your.email@example.com\""
echo ""
echo "2. Restart your shell or run: source ~/.bashrc"
echo ""
echo "3. (Optional) Install common development tools:"
echo "   ./install-tools.sh"
echo ""
echo "4. (WSL Users) Copy wsl.conf to /etc/wsl.conf (requires sudo):"
echo "   sudo cp wsl.conf /etc/wsl.conf"
echo ""
echo "5. (WSL Users) Copy .wslconfig to your Windows user directory:"
echo "   cp .wslconfig /mnt/c/Users/\$USER/.wslconfig"
echo ""
echo -e "${YELLOW}Note: Some changes may require restarting WSL or your terminal.${NC}"
