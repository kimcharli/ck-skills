#!/bin/bash
#
# Doc Review Commands - Installation Script
# Installs the modular documentation management system for Claude Code
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation paths
CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands/ck"
INSTALL_DIR="$COMMANDS_DIR/doc-review"
TOOLS_GLOBAL="$CLAUDE_DIR/tools"

# Script directory (where install.sh is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Doc Review Commands Installer           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# Check if Claude Code directory exists
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${YELLOW}⚠️  Claude Code directory not found at $CLAUDE_DIR${NC}"
    echo -e "${YELLOW}   Creating directory structure...${NC}"
    mkdir -p "$CLAUDE_DIR"
fi

# Create ck namespace if it doesn't exist
if [ ! -d "$COMMANDS_DIR" ]; then
    echo -e "${YELLOW}   Creating ck commands namespace...${NC}"
    mkdir -p "$COMMANDS_DIR"
fi

# Check if doc-review already exists
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠️  Existing installation found at $INSTALL_DIR${NC}"
    read -p "   Overwrite? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}   Installation cancelled.${NC}"
        exit 1
    fi
    echo -e "${YELLOW}   Backing up existing installation...${NC}"
    mv "$INSTALL_DIR" "$INSTALL_DIR.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Create installation directory
echo -e "${BLUE}📁 Creating directory structure...${NC}"
mkdir -p "$INSTALL_DIR"/{config,tools}

# Copy command files
echo -e "${BLUE}📝 Installing command files...${NC}"
cp "$SCRIPT_DIR"/commands/*.md "$INSTALL_DIR/"
echo -e "${GREEN}   ✓ Installed 6 command files${NC}"

# Copy configuration
echo -e "${BLUE}⚙️  Installing configuration...${NC}"
cp "$SCRIPT_DIR"/config/categories.json "$INSTALL_DIR/config/"
echo -e "${GREEN}   ✓ Installed pattern configuration${NC}"

# Copy and setup tools
echo -e "${BLUE}🔧 Installing tools...${NC}"
cp "$SCRIPT_DIR"/tools/analyzer.sh "$INSTALL_DIR/tools/"
chmod +x "$INSTALL_DIR/tools/analyzer.sh"
echo -e "${GREEN}   ✓ Installed analyzer tool${NC}"

# Optionally install global copy of analyzer
if [ ! -d "$TOOLS_GLOBAL" ]; then
    mkdir -p "$TOOLS_GLOBAL"
fi

if [ ! -f "$TOOLS_GLOBAL/doc-analyzer.sh" ]; then
    echo -e "${BLUE}🌐 Installing global analyzer tool (optional)...${NC}"
    cp "$SCRIPT_DIR"/tools/analyzer.sh "$TOOLS_GLOBAL/doc-analyzer.sh"
    chmod +x "$TOOLS_GLOBAL/doc-analyzer.sh"
    echo -e "${GREEN}   ✓ Installed global doc-analyzer.sh${NC}"
else
    echo -e "${YELLOW}   ℹ️  Global analyzer already exists, skipping${NC}"
fi

# Verification
echo ""
echo -e "${BLUE}🔍 Verifying installation...${NC}"

ERRORS=0

# Check command files
for cmd in main analyze core sdd qa help; do
    if [ -f "$INSTALL_DIR/$cmd.md" ]; then
        echo -e "${GREEN}   ✓ $cmd.md${NC}"
    else
        echo -e "${RED}   ✗ $cmd.md missing${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check config
if [ -f "$INSTALL_DIR/config/categories.json" ]; then
    echo -e "${GREEN}   ✓ config/categories.json${NC}"
else
    echo -e "${RED}   ✗ config/categories.json missing${NC}"
    ERRORS=$((ERRORS + 1))
fi

# Check tool
if [ -x "$INSTALL_DIR/tools/analyzer.sh" ]; then
    echo -e "${GREEN}   ✓ tools/analyzer.sh (executable)${NC}"
else
    echo -e "${RED}   ✗ tools/analyzer.sh missing or not executable${NC}"
    ERRORS=$((ERRORS + 1))
fi

echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ✓ Installation successful!               ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}📦 Installed to:${NC} $INSTALL_DIR"
    echo ""
    echo -e "${BLUE}🚀 Quick Start:${NC}"
    echo -e "   ${YELLOW}/ck:doc-review/help${NC}      - Show usage guide"
    echo -e "   ${YELLOW}/ck:doc-review/analyze${NC}   - Analyze documentation needs"
    echo -e "   ${YELLOW}/ck:doc-review/core \"X\"${NC}  - Update core files"
    echo ""
    echo -e "${BLUE}📚 Documentation:${NC}"
    echo -e "   README: $SCRIPT_DIR/README.md"
    echo -e "   Docs:   $SCRIPT_DIR/docs/"
    echo ""
    echo -e "${GREEN}Happy documenting! 📝${NC}"
else
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║   ✗ Installation completed with errors     ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${RED}$ERRORS error(s) occurred during installation.${NC}"
    echo -e "${YELLOW}Please check the output above and try again.${NC}"
    exit 1
fi
