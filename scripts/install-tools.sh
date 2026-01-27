#!/bin/bash
# ====================================
# jcaldwell-labs Development Tools Installer
# ====================================
# Installs tools required for contributor environment
# Run: ./install-tools.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=== jcaldwell-labs Development Tools ===${NC}"
echo ""

# Check if running on Debian/Ubuntu
if ! command -v apt-get &> /dev/null; then
    echo -e "${RED}Error: This script requires apt-get (Debian/Ubuntu).${NC}"
    exit 1
fi

# Update package list
echo -e "${GREEN}Updating package list...${NC}"
sudo apt-get update

# ====================================
# CORE DEVELOPMENT TOOLS
# ====================================
echo -e "${GREEN}Installing core development tools...${NC}"
sudo apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    vim \
    tmux \
    jq \
    unzip \
    zip \
    tree \
    htop

# ====================================
# VIM DEPENDENCIES (critical for config)
# ====================================
echo -e "${GREEN}Installing vim dependencies...${NC}"

# fzf - fuzzy finder (required for vim Ctrl+P)
sudo apt-get install -y fzf

# fd-find - fast file finder (required for $FZF_DEFAULT_COMMAND)
sudo apt-get install -y fd-find

# Create fd symlink (Debian uses 'fdfind' binary name)
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    mkdir -p ~/.local/bin
    ln -sf "$(which fdfind)" ~/.local/bin/fd
    echo -e "${YELLOW}Created fd symlink: ~/.local/bin/fd -> fdfind${NC}"
fi

# ripgrep - fast grep (required for vim :Rg)
sudo apt-get install -y ripgrep

# ====================================
# PYTHON
# ====================================
echo -e "${GREEN}Installing Python...${NC}"
sudo apt-get install -y \
    python3 \
    python3-pip \
    python3-venv

# ====================================
# NODE.JS (via NodeSource LTS)
# ====================================
if ! command -v node &> /dev/null; then
    echo -e "${GREEN}Installing Node.js LTS...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_lts.x -o /tmp/nodesource_setup.sh
    sudo -E bash /tmp/nodesource_setup.sh
    sudo apt-get install -y nodejs
    rm /tmp/nodesource_setup.sh
else
    echo -e "${YELLOW}Node.js already installed: $(node --version)${NC}"
fi

# ====================================
# GITHUB CLI
# ====================================
if ! command -v gh &> /dev/null; then
    echo -e "${GREEN}Installing GitHub CLI...${NC}"
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
        sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
        sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y gh
else
    echo -e "${YELLOW}GitHub CLI already installed: $(gh --version | head -1)${NC}"
fi

# ====================================
# DOCKER (optional - user can skip)
# ====================================
read -p "Install Docker? (y/N): " install_docker
if [[ "$install_docker" =~ ^[Yy]$ ]]; then
    if ! command -v docker &> /dev/null; then
        echo -e "${GREEN}Installing Docker...${NC}"
        curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
        sudo sh /tmp/get-docker.sh
        sudo usermod -aG docker "$USER"
        rm /tmp/get-docker.sh
        echo -e "${YELLOW}Note: Log out and back in for Docker group membership.${NC}"
    else
        echo -e "${YELLOW}Docker already installed.${NC}"
    fi
fi

# ====================================
# GLOW - Markdown Viewer (optional)
# ====================================
read -p "Install glow (markdown viewer)? (y/N): " install_glow
if [[ "$install_glow" =~ ^[Yy]$ ]]; then
    if ! command -v glow &> /dev/null; then
        echo -e "${GREEN}Installing glow...${NC}"
        # glow not in Debian stable, install from GitHub releases
        GLOW_VERSION="1.5.1"
        GLOW_URL="https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_linux_amd64.tar.gz"
        curl -fsSL "$GLOW_URL" -o /tmp/glow.tar.gz
        tar -xzf /tmp/glow.tar.gz -C /tmp glow
        sudo mv /tmp/glow /usr/local/bin/
        rm /tmp/glow.tar.gz
        echo -e "${GREEN}glow installed.${NC}"
    else
        echo -e "${YELLOW}glow already installed.${NC}"
    fi
fi

# ====================================
# JAVA (optional - OpenJDK 21 LTS)
# ====================================
read -p "Install Java 21 (OpenJDK LTS)? (y/N): " install_java
if [[ "$install_java" =~ ^[Yy]$ ]]; then
    if ! java -version 2>&1 | grep -q "21"; then
        echo -e "${GREEN}Installing OpenJDK 21...${NC}"
        sudo apt-get install -y openjdk-21-jdk
        echo -e "${GREEN}Java 21 (OpenJDK) installed.${NC}"

        # Set JAVA_HOME
        if ! grep -q "JAVA_HOME" "$HOME/.bashrc"; then
            echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' >> "$HOME/.bashrc"
            echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> "$HOME/.bashrc"
            echo -e "${GREEN}JAVA_HOME configured in ~/.bashrc${NC}"
        fi
    else
        echo -e "${YELLOW}Java 21 already installed.${NC}"
    fi
fi

# ====================================
# RUST (optional - for CLI tools)
# ====================================
read -p "Install Rust toolchain? (y/N): " install_rust
if [[ "$install_rust" =~ ^[Yy]$ ]]; then
    if ! command -v rustup &> /dev/null; then
        echo -e "${GREEN}Installing Rust...${NC}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        echo -e "${GREEN}Rust installed. Run: source ~/.cargo/env${NC}"
    else
        echo -e "${YELLOW}Rust already installed: $(rustc --version)${NC}"
    fi
fi

# ====================================
# CLEANUP
# ====================================
echo -e "${GREEN}Cleaning up...${NC}"
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# ====================================
# SUMMARY
# ====================================
echo ""
echo -e "${CYAN}=== Installation Complete ===${NC}"
echo ""
echo "Core tools installed:"
echo "  - git, vim, tmux, curl, wget, jq, tree, htop"
echo "  - fzf (fuzzy finder)"
echo "  - fd-find (fast file finder)"
echo "  - ripgrep (fast grep)"
echo "  - Python 3 + pip + venv"
echo "  - Node.js + npm"
echo "  - GitHub CLI (gh)"
echo ""
echo "Verification commands:"
echo "  git --version"
echo "  vim --version | head -1"
echo "  tmux -V"
echo "  fzf --version"
echo "  rg --version"
echo "  python3 --version"
echo "  node --version"
echo "  gh --version"
echo ""
echo -e "${YELLOW}Next: Run setup.sh to install dot files${NC}"
