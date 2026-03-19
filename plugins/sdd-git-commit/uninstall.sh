#!/bin/bash
# uninstall.sh — sdd-git-commit uninstaller

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

INSTALL_DIR="${HOME}/.claude/commands/ck/commit"

echo -e "${BLUE}🗑️  Uninstalling SDD Git Commit skill...${NC}"

if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo -e "${GREEN}   ✓ Removed $INSTALL_DIR${NC}"
else
    echo -e "${BLUE}   Skill not found in $INSTALL_DIR${NC}"
fi

echo -e "${GREEN}✓ Uninstallation complete.${NC}"
