#!/bin/bash
# uninstall.sh — llm-wiki uninstaller

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

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

echo -e "${BLUE}🗑  Uninstalling LLM Wiki from ${REL_BASE_DIR}...${NC}"

if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo -e "${GREEN}   ✓ Removed ${INSTALL_DIR}${NC}"
else
    echo -e "${RED}   ✗ Not found at ${INSTALL_DIR}${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ LLM Wiki uninstalled.${NC}"
echo -e "Note: Your wiki content (raw/, wiki/, WIKI.md) was not modified."
echo ""
