#!/bin/bash
#
# SDD Project Init - Uninstall Script
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

INSTALL_DIR="$HOME/.claude/commands/ck/sdd-init"

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   SDD Project Init Uninstaller             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠️  Installation not found at $INSTALL_DIR${NC}"
    echo -e "${YELLOW}   Nothing to uninstall.${NC}"
    exit 0
fi

read -p "Remove SDD Project Init from $INSTALL_DIR? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}   Uninstall cancelled.${NC}"
    exit 0
fi

rm -rf "$INSTALL_DIR"

echo -e "${GREEN}✓ SDD Project Init uninstalled successfully.${NC}"
