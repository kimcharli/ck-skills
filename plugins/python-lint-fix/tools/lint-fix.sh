#!/usr/bin/env bash
# lint-fix: auto-fix lint issues, format, verify, and run tests.
# This script is designed for Python (Ruff) and Markdown (mdformat, markdownlint).
# Reference: https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Minimum required versions for MD060 support
MIN_MDL_VERSION="0.40.0"

# ── Tool Availability Checks ──────────────────────────────────────────────────
check_python_tools() {
    if ! command -v ruff &> /dev/null && ! { command -v uv &> /dev/null && uv run ruff --version &> /dev/null; }; then
        echo -e "${YELLOW}⚠️  Ruff not found.${NC}"
        echo -e "   Install: ${BLUE}pip install ruff${NC} or ${BLUE}brew install ruff${NC}"
        return 1
    fi
    return 0
}

check_mdformat() {
    if ! command -v mdformat &> /dev/null && ! { command -v uv &> /dev/null && uvx mdformat --version &> /dev/null; }; then
        echo -e "${YELLOW}⚠️  mdformat not found.${NC}"
        echo -e "   Install: ${BLUE}pip install mdformat-gfm mdformat-frontmatter mdformat-tables mdformat-shfmt${NC}"
        return 1
    fi
    return 0
}

check_markdownlint() {
    if ! command -v markdownlint &> /dev/null; then
        echo -e "${YELLOW}⚠️  markdownlint-cli not found.${NC}"
        echo -e "   Install: ${BLUE}npm install -g markdownlint-cli@latest${NC}"
        return 1
    fi

    # Check version for MD060 support (requires markdownlint-cli 0.45.0+)
    local current_version
    current_version=$(markdownlint --version 2>&1 | head -n 1)
    
    # Simple function to compare versions
    version_ge() {
        printf '%s\n%s' "$2" "$1" | sort -V -C
    }

    if ! version_ge "$current_version" "0.45.0"; then
        echo -e "${YELLOW}⚠️  markdownlint-cli version (${current_version}) is too old.${NC}"
        echo -e "   Required: 0.45.0+ (for MD060 support)."
        echo -e "   Update: ${BLUE}npm install -g markdownlint-cli@latest${NC}"
    fi
    return 0
}

echo -e "${BLUE}=== Step 1: Python Linting (Ruff) ===${NC}"
if check_python_tools; then
    if command -v uv &> /dev/null && [ -f "pyproject.toml" ]; then
        echo "Running uv run ruff check --fix ."
        uv run ruff check --fix .
        echo "Running uv run ruff format ."
        uv run ruff format .
    else
        echo "Running ruff check --fix ."
        ruff check --fix . || true
        echo "Running ruff format ."
        ruff format . || true
    fi
fi

echo -e "${BLUE}=== Step 2: Markdown Formatting (mdformat) ===${NC}"
if check_mdformat; then
    # Essential mdformat plugins for GitHub-style Markdown and aligned tables
    MDFORMAT_PLUGINS="--with mdformat-gfm --with mdformat-frontmatter --with mdformat-tables --with mdformat-shfmt"
    
    if command -v uv &> /dev/null; then
        echo "Running uvx $MDFORMAT_PLUGINS mdformat ."
        # Use find to avoid potential shell expansion issues with many files
        find . -name "*.md" -not -path "*/.git/*" -print0 | xargs -0 uvx $MDFORMAT_PLUGINS mdformat
    elif command -v mdformat &> /dev/null; then
        echo "Running mdformat ."
        mdformat .
    fi
fi

echo -e "${BLUE}=== Step 3: Markdown Linting (markdownlint) ===${NC}"
if check_markdownlint; then
    ML_CONFIG=""
    if [ -f ".markdownlint.json" ] || [ -f ".markdownlint.yaml" ] || [ -f ".markdownlint.yml" ]; then
        echo "Using existing markdownlint configuration."
    else
        echo "No markdownlint config found, using fallback."
        ML_CONFIG="--config ${SCRIPT_DIR}/.markdownlint.json"
    fi

    echo "Running markdownlint --fix ..."
    # markdownlint-cli supports globbing
    markdownlint --fix $ML_CONFIG '**/*.md' 2>/dev/null || true
    
    echo "Running final markdownlint check..."
    markdownlint $ML_CONFIG '**/*.md'
fi

echo -e "${BLUE}=== Step 4: Verification ===${NC}"
if command -v uv &> /dev/null && [ -f "pyproject.toml" ]; then
    echo "Verifying clean state..."
    uv run ruff check . && uv run ruff format --check .
elif command -v ruff &> /dev/null; then
    ruff check . && ruff format --check .
fi

echo -e "${BLUE}=== Step 5: Testing (pytest) ===${NC}"
if command -v uv &> /dev/null && [ -f "pyproject.toml" ]; then
    echo "Running tests..."
    uv run pytest -q || echo -e "${RED}Tests failed!${NC}"
elif [ -d "tests" ] && command -v pytest &> /dev/null; then
    pytest -q || echo -e "${RED}Tests failed!${NC}"
else
    echo "No tests found or pytest missing, skipping."
fi

echo -e "${GREEN}=== All checks completed ===${NC}"
