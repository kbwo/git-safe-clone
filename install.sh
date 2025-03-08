#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing git-safe-clone...${NC}"

# Make the script executable
chmod +x git-safe-clone

# Determine the installation directory
INSTALL_DIR="/usr/local/bin"
if [ ! -w "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}Need sudo privileges to install to $INSTALL_DIR${NC}"
    sudo cp git-safe-clone "$INSTALL_DIR/"
else
    cp git-safe-clone "$INSTALL_DIR/"
fi

echo -e "${GREEN}git-safe-clone has been installed to $INSTALL_DIR/git-safe-clone${NC}"

# Check if LLM_API_KEY is set
if [ -z "$LLM_API_KEY" ]; then
    echo -e "${YELLOW}Warning: LLM_API_KEY environment variable is not set.${NC}"
    echo -e "Please add the following to your shell configuration file (.bashrc, .zshrc, etc.):"
    echo -e "${YELLOW}export LLM_API_KEY=\"your_api_key_here\"${NC}"
fi

# Check if LLM_MODEL is set
if [ -z "$LLM_MODEL" ]; then
    echo -e "${YELLOW}Warning: LLM_MODEL environment variable is not set.${NC}"
    echo -e "Please add the following to your shell configuration file (.bashrc, .zshrc, etc.):"
    echo -e "${YELLOW}export LLM_MODEL=\"your_preferred_model\"${NC}"
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed.${NC}"
    echo -e "Please install Docker to use git-safe-clone."
    exit 1
fi

echo -e "${GREEN}Installation complete!${NC}"
echo -e "You can now use git-safe-clone with: ${YELLOW}git safe-clone <repository-url>${NC}" 