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

# Installation paths
# 1. Detect Base Directory
# Default to ~/.claude, but check for ~/.agents
BASE_DIR="${HOME}/.claude"
if [ -d "${HOME}/.agents" ]; then
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

# Home-relative path for patching (e.g., ~/.agents)
REL_BASE_DIR="${BASE_DIR/#$HOME/~}"

CLAUDE_DIR="$BASE_DIR"
COMMANDS_DIR="$CLAUDE_DIR/plugins/ck"
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

# 4. Patch Path References
echo -e "${BLUE}🔧 Patching paths for ${REL_BASE_DIR}...${NC}"
# Use perl for better portability than sed -i on different OSes
find "$INSTALL_DIR" -type f \( -name "*.md" -o -name "*.json" -o -name "SKILL.md" \) -print0 | \
    xargs -0 perl -i -pe "s|~/.claude|${REL_BASE_DIR}|g"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ Installation successful!               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📦 Installed to:${NC} $INSTALL_DIR"
echo ""
echo -e "${BLUE}🚀 Usage:${NC}"
echo -e "   Tell the tool: ${YELLOW}/ck:sdd-init${NC}"
echo -e "   or: ${YELLOW}\"initialize a new project with SDD\"${NC}"
echo ""
