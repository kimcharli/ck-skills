#!/bin/bash
# install.sh — sdd-git-commit installer

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

INSTALL_DIR="${HOME}/.claude/commands/ck/commit"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}🚀 Installing SDD Git Commit skill...${NC}"

if [ -d "$INSTALL_DIR" ]; then
    echo -e "${BLUE}   Cleaning up existing installation...${NC}"
    rm -rf "$INSTALL_DIR"
fi

echo -e "${BLUE}📁 Creating directory structure...${NC}"
mkdir -p "$INSTALL_DIR/commands"

echo -e "${BLUE}📝 Installing command files...${NC}"
cp "$SCRIPT_DIR/commands/commit.md" "$INSTALL_DIR/commands/"
cp "$SCRIPT_DIR/SKILL.md" "$INSTALL_DIR/"
echo -e "${GREEN}   ✓ commit.md${NC}"
echo -e "${GREEN}   ✓ SKILL.md${NC}"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ SDD Git Commit installed!              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "You can now use ${BLUE}/ck:commit${NC} in Claude Code."
echo ""
