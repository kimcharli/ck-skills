#!/bin/bash
#
# SDD Project Init - Installation Script
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands/ck"
INSTALL_DIR="$COMMANDS_DIR/sdd-init"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   SDD Project Init Installer               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

[ ! -d "$CLAUDE_DIR" ]   && mkdir -p "$CLAUDE_DIR"
[ ! -d "$COMMANDS_DIR" ] && mkdir -p "$COMMANDS_DIR"

if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠️  Existing installation found at $INSTALL_DIR${NC}"
    read -p "   Overwrite? (y/N): " -n 1 -r; echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && echo -e "${RED}   Cancelled.${NC}" && exit 1
    mv "$INSTALL_DIR" "$INSTALL_DIR.backup.$(date +%Y%m%d_%H%M%S)"
fi

echo -e "${BLUE}📁 Creating directory structure...${NC}"
mkdir -p "$INSTALL_DIR"/{template/docs,template/specs/features,tools}

echo -e "${BLUE}📝 Installing command file...${NC}"
cp "$SCRIPT_DIR/commands/init.md" "$INSTALL_DIR/"
echo -e "${GREEN}   ✓ init.md${NC}"

echo -e "${BLUE}📋 Installing model file tree...${NC}"
cp "$SCRIPT_DIR/template/AGENTS.md"                        "$INSTALL_DIR/template/"
cp "$SCRIPT_DIR/template/README.md"                        "$INSTALL_DIR/template/"
cp "$SCRIPT_DIR/template/.gitignore"                       "$INSTALL_DIR/template/"
cp "$SCRIPT_DIR/template/docs/sdd-how-to-apply.md"         "$INSTALL_DIR/template/docs/"
cp "$SCRIPT_DIR/template/specs/requirements.md"            "$INSTALL_DIR/template/specs/"
cp "$SCRIPT_DIR/template/specs/design.md"                  "$INSTALL_DIR/template/specs/"
cp "$SCRIPT_DIR/template/specs/tasks.md"                   "$INSTALL_DIR/template/specs/"
cp "$SCRIPT_DIR/template/specs/features/_template.md"      "$INSTALL_DIR/template/specs/features/"
echo -e "${GREEN}   ✓ template/ (8 files)${NC}"

echo -e "${BLUE}🔧 Installing tools...${NC}"
cp "$SCRIPT_DIR/tools/create-project.sh" "$INSTALL_DIR/tools/"
chmod +x "$INSTALL_DIR/tools/create-project.sh"
echo -e "${GREEN}   ✓ tools/create-project.sh${NC}"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ Installation successful!               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📦 Installed to:${NC} $INSTALL_DIR"
echo ""
echo -e "${BLUE}🚀 Usage:${NC}"
echo -e "   Tell Claude Code: ${YELLOW}/ck:sdd-init${NC}"
echo -e "   or: ${YELLOW}\"initialize a new project with SDD\"${NC}"
echo ""
