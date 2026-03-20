#!/bin/bash
#
# Doc Review Commands - Uninstallation Script
# Removes the doc-review system from Claude Code
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 1. Detect Base Directory
# Default to ~/.claude, but check for ~/.agents
BASE_DIR="${HOME}/.claude"
if [ -d "${HOME}/.agents/commands/ck/doc-review" ]; then
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

INSTALL_DIR="${BASE_DIR}/commands/ck/doc-review"
TOOLS_GLOBAL="${BASE_DIR}/tools/doc-analyzer.sh"


echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Doc Review Commands Uninstaller         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# Check if installed
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠️  Doc Review Commands not found at $INSTALL_DIR${NC}"
    echo -e "${YELLOW}   Nothing to uninstall.${NC}"
    exit 0
fi

# Confirm uninstallation
echo -e "${YELLOW}This will remove Doc Review Commands from:${NC}"
echo -e "   $INSTALL_DIR"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Uninstallation cancelled.${NC}"
    exit 1
fi

# Backup before removal
BACKUP_DIR="$INSTALL_DIR.backup.$(date +%Y%m%d_%H%M%S)"
echo -e "${BLUE}📦 Creating backup at: $BACKUP_DIR${NC}"
cp -r "$INSTALL_DIR" "$BACKUP_DIR"
echo -e "${GREEN}   ✓ Backup created${NC}"

# Remove installation
echo -e "${BLUE}🗑️  Removing installation...${NC}"
rm -rf "$INSTALL_DIR"
echo -e "${GREEN}   ✓ Removed $INSTALL_DIR${NC}"

# Ask about global tool
if [ -f "$TOOLS_GLOBAL" ]; then
    echo ""
    read -p "Remove global analyzer tool? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "$TOOLS_GLOBAL"
        echo -e "${GREEN}   ✓ Removed $TOOLS_GLOBAL${NC}"
    else
        echo -e "${YELLOW}   ℹ️  Kept global analyzer tool${NC}"
    fi
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ Uninstallation complete!               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📦 Backup saved to:${NC} $BACKUP_DIR"
echo ""
echo -e "${YELLOW}To restore, run:${NC}"
echo -e "   mv \"$BACKUP_DIR\" \"$INSTALL_DIR\""
echo ""
