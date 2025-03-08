#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed.${NC}"
    echo -e "Please install Docker to use git-safe-clone."
    exit 1
fi

# Test repository URL (a safe, popular repository)
REPO_URL="https://github.com/kbwo/dotfiles.git"

echo -e "${GREEN}Testing git-safe-clone with a known safe repository: $REPO_URL${NC}"
echo -e "${YELLOW}Note: This will clone a small part of the repository for testing purposes.${NC}"

# Run git-safe-clone with the test repository
./git-safe-clone "$REPO_URL" test-repo --depth=1

# Check if the test was successful
if [ -d "test-repo" ]; then
    echo -e "${GREEN}Test successful! The repository was cloned and deemed safe.${NC}"
    echo -e "Cleaning up test repository..."
    rm -rf test-repo
else
    echo -e "${RED}Test failed! The repository was not cloned or was deemed unsafe.${NC}"
    exit 1
fi

echo -e "${GREEN}All tests passed!${NC}" 