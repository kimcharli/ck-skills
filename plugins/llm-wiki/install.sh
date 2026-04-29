#!/bin/bash
# install.sh — llm-wiki installer

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Detect base directory
BASE_DIR="${HOME}/.claude"
if [ -d "${HOME}/.agents" ]; then
    BASE_DIR="${HOME}/.agents"
fi

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --agents) BASE_DIR="${HOME}/.agents"; shift ;;
        --claude) BASE_DIR="${HOME}/.claude"; shift ;;
        --dir)    BASE_DIR="$2"; shift 2 ;;
        *) shift ;;
    esac
done

REL_BASE_DIR="${BASE_DIR/#$HOME/~}"
INSTALL_DIR="${BASE_DIR}/skills/llm-wiki"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}🚀 Installing LLM Wiki skill to ${REL_BASE_DIR}...${NC}"

if [ -d "$INSTALL_DIR" ]; then
    echo -e "${BLUE}   Cleaning up existing installation...${NC}"
    rm -rf "$INSTALL_DIR"
fi

echo -e "${BLUE}📁 Creating directory structure...${NC}"
mkdir -p "$INSTALL_DIR"/{commands,tools}

echo -e "${BLUE}📝 Installing skill files...${NC}"
cp "$SCRIPT_DIR/SKILL.md" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/manifest.json" "$INSTALL_DIR/"
echo -e "${GREEN}   ✓ SKILL.md${NC}"
echo -e "${GREEN}   ✓ manifest.json${NC}"

echo -e "${BLUE}📝 Installing commands...${NC}"
cp "$SCRIPT_DIR/commands/init.md" "$INSTALL_DIR/commands/"
cp "$SCRIPT_DIR/commands/ingest.md" "$INSTALL_DIR/commands/"
cp "$SCRIPT_DIR/commands/query.md" "$INSTALL_DIR/commands/"
cp "$SCRIPT_DIR/commands/lint.md" "$INSTALL_DIR/commands/"
echo -e "${GREEN}   ✓ commands/init.md${NC}"
echo -e "${GREEN}   ✓ commands/ingest.md${NC}"
echo -e "${GREEN}   ✓ commands/query.md${NC}"
echo -e "${GREEN}   ✓ commands/lint.md${NC}"

echo -e "${BLUE}🔧 Installing tools...${NC}"
cp "$SCRIPT_DIR/tools/wiki-schema-template.md" "$INSTALL_DIR/tools/"
cp "$SCRIPT_DIR/tools/page-template.md" "$INSTALL_DIR/tools/"
echo -e "${GREEN}   ✓ tools/wiki-schema-template.md${NC}"
echo -e "${GREEN}   ✓ tools/page-template.md${NC}"

echo -e "${BLUE}🔧 Patching paths for ${REL_BASE_DIR}...${NC}"
find "$INSTALL_DIR" -type f \( -name "*.md" -o -name "*.json" \) -print0 | \
    xargs -0 perl -i -pe "s|~/.claude|${REL_BASE_DIR}|g"

if [ "$BASE_DIR" = "${HOME}/.agents" ] && [ ! -d "${HOME}/.claude/skills" ]; then
    echo -e "${BLUE}🔗 Linking to ~/.claude/skills for cross-tool discovery...${NC}"
    mkdir -p "${HOME}/.claude"
    ln -s "${HOME}/.agents/skills" "${HOME}/.claude/skills"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ LLM Wiki skill installed!              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "In any project, say: ${BLUE}\"create a wiki\"${NC} to get started."
echo -e "Then: ${BLUE}\"ingest this: raw/myfile.md\"${NC} to add sources."
echo ""
