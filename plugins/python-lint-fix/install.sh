#!/bin/bash
# install.sh — python-lint-fix installer

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

INSTALL_DIR="${HOME}/.claude/commands/ck/lint"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}🚀 Installing Python Lint Fix skill...${NC}"

if [ -d "$INSTALL_DIR" ]; then
    echo -e "${BLUE}   Cleaning up existing installation...${NC}"
    rm -rf "$INSTALL_DIR"
fi

echo -e "${BLUE}📁 Creating directory structure...${NC}"
mkdir -p "$INSTALL_DIR"/{commands,tools}

echo -e "${BLUE}📝 Installing command files...${NC}"
cp "$SCRIPT_DIR/commands/lint.md" "$INSTALL_DIR/commands/"
cp "$SCRIPT_DIR/SKILL.md" "$INSTALL_DIR/"
echo -e "${GREEN}   ✓ lint.md${NC}"
echo -e "${GREEN}   ✓ SKILL.md${NC}"

echo -e "${BLUE}🔧 Installing tools...${NC}"
cp "$SCRIPT_DIR/tools/lint-fix.sh" "$INSTALL_DIR/tools/"
cp "$SCRIPT_DIR/tools/.markdownlint.json" "$INSTALL_DIR/tools/"
chmod +x "$INSTALL_DIR/tools/lint-fix.sh"
echo -e "${GREEN}   ✓ tools/lint-fix.sh${NC}"
echo -e "${GREEN}   ✓ tools/.markdownlint.json${NC}"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ Python Lint Fix installed!             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "You can now use ${BLUE}/ck:lint${NC} in Claude Code."
echo ""
