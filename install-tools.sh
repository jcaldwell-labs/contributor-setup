#!/bin/bash
# Install common development tools for jcaldwell-labs contributors

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Installing Development Tools ===${NC}"
echo ""

# Check if running on Debian/Ubuntu
if ! command -v apt-get &> /dev/null; then
    echo -e "${RED}This script is designed for Debian/Ubuntu systems.${NC}"
    echo "Please install tools manually on other systems."
    exit 1
fi

# Update package list
echo -e "${GREEN}Updating package list...${NC}"
sudo apt-get update

# Install essential tools
echo -e "${GREEN}Installing essential development tools...${NC}"
sudo apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    vim \
    tmux \
    jq \
    unzip \
    zip

# Install Python and pip
echo -e "${GREEN}Installing Python and pip...${NC}"
sudo apt-get install -y \
    python3 \
    python3-pip \
    python3-venv

# Install Node.js (via NodeSource)
if ! command -v node &> /dev/null; then
    echo -e "${GREEN}Installing Node.js...${NC}"
    echo -e "${YELLOW}Downloading NodeSource setup script...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_lts.x -o /tmp/nodesource_setup.sh
    echo -e "${YELLOW}Running NodeSource setup script (from official source)...${NC}"
    sudo -E bash /tmp/nodesource_setup.sh
    sudo apt-get install -y nodejs
    rm /tmp/nodesource_setup.sh
else
    echo -e "${YELLOW}Node.js already installed. Skipping...${NC}"
fi

# Install Docker (if not already installed)
if ! command -v docker &> /dev/null; then
    echo -e "${GREEN}Installing Docker...${NC}"
    echo -e "${YELLOW}Downloading Docker installation script from official source...${NC}"
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    echo -e "${YELLOW}Running Docker installation script...${NC}"
    sudo sh /tmp/get-docker.sh
    sudo usermod -aG docker "$USER"
    rm /tmp/get-docker.sh
    echo -e "${YELLOW}Note: You may need to log out and back in for Docker group membership to take effect.${NC}"
else
    echo -e "${YELLOW}Docker already installed. Skipping...${NC}"
fi

# Install GitHub CLI
if ! command -v gh &> /dev/null; then
    echo -e "${GREEN}Installing GitHub CLI...${NC}"
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y gh
else
    echo -e "${YELLOW}GitHub CLI already installed. Skipping...${NC}"
fi

# Clean up
echo -e "${GREEN}Cleaning up...${NC}"
sudo apt-get autoremove -y
sudo apt-get autoclean -y

echo ""
echo -e "${GREEN}=== Installation Complete! ===${NC}"
echo ""
echo "Installed tools:"
echo "  - Build essentials (gcc, g++, make)"
echo "  - Git"
echo "  - Vim and Tmux"
echo "  - Python 3 and pip"
echo "  - Node.js and npm"
echo "  - Docker"
echo "  - GitHub CLI (gh)"
echo "  - Various utilities (curl, wget, jq, zip, unzip)"
echo ""
echo "Verify installations:"
echo "  git --version"
echo "  python3 --version"
echo "  node --version"
echo "  docker --version"
echo "  gh --version"
