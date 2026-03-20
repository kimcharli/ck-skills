#!/bin/bash
# uninstall.sh — sdd-git-commit uninstaller

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

# 1. Detect Base Directory
# Default to ~/.claude, but check for ~/.agents
BASE_DIR="${HOME}/.claude"
if [ -d "${HOME}/.agents/skills/sdd-git-commit" ]; then
    BASE_DIR="${HOME}/.agents"
fi

# Allow overrides via flags
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --agents) BASE_DIR="${HOME}/.agents"; shift ;;
        --claude) BASE_DIR="${HOME}/.claude"; shift ;;
        --dir)    BASE_DIR="$2"; shift 2 ;;
        *) shift ;;
    esac
done

INSTALL_DIR="${BASE_DIR}/skills/sdd-git-commit"

echo -e "${BLUE}🗑️  Uninstalling SDD Git Commit skill...${NC}"

if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo -e "${GREEN}   ✓ Removed $INSTALL_DIR${NC}"
else
    echo -e "${BLUE}   Skill not found in $INSTALL_DIR${NC}"
fi

echo -e "${GREEN}✓ Uninstallation complete.${NC}"
