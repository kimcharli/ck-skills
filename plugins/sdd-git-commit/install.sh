#!/bin/bash
# install.sh — sdd-git-commit installer

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

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

INSTALL_DIR="${BASE_DIR}/skills/sdd-git-commit"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}🚀 Installing SDD Git Commit skill to ${REL_BASE_DIR}...${NC}"

if [ -d "$INSTALL_DIR" ]; then
    echo -e "${BLUE}   Cleaning up existing installation...${NC}"
    rm -rf "$INSTALL_DIR"
fi

echo -e "${BLUE}📁 Creating directory structure...${NC}"
mkdir -p "$INSTALL_DIR/commands"

echo -e "${BLUE}📝 Installing command files...${NC}"
cp "$SCRIPT_DIR/commands/commit.md" "$INSTALL_DIR/commands/"
cp "$SCRIPT_DIR/SKILL.md" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/manifest.json" "$INSTALL_DIR/"
echo -e "${GREEN}   ✓ commands/commit.md${NC}"
echo -e "${GREEN}   ✓ SKILL.md${NC}"
echo -e "${GREEN}   ✓ manifest.json${NC}"

# 4. Patch Path References
echo -e "${BLUE}🔧 Patching paths for ${REL_BASE_DIR}...${NC}"
# Use perl for better portability than sed -i on different OSes
find "$INSTALL_DIR" -type f \( -name "*.md" -o -name "*.json" -o -name "SKILL.md" \) -print0 | \
    xargs -0 perl -i -pe "s|~/.claude|${REL_BASE_DIR}|g"

# 5. Ensure Claude discovery
if [ "$BASE_DIR" = "${HOME}/.agents" ] && [ ! -d "${HOME}/.claude/skills" ]; then
    echo -e "${BLUE}🔗 Linking to ~/.claude/skills for cross-tool discovery...${NC}"
    mkdir -p "${HOME}/.claude"
    ln -s "${HOME}/.agents/skills" "${HOME}/.claude/skills"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ SDD Git Commit installed!              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "You can now tell the tool: ${BLUE}\"commit my changes\"${NC}"
echo ""
