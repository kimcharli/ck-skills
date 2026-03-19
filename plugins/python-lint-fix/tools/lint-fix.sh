#!/usr/bin/env bash
# lint-fix: auto-fix lint issues, format, verify, and run tests.
# This script is designed for Python (Ruff) and Markdown (mdformat, markdownlint).

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Step 1: Python Linting (Ruff) ===${NC}"
if command -v uv &> /dev/null && [ -f "pyproject.toml" ]; then
    echo "Running uv run ruff check --fix ."
    uv run ruff check --fix .
    echo "Running uv run ruff format ."
    uv run ruff format .
elif command -v ruff &> /dev/null; then
    echo "Running ruff check --fix ."
    ruff check --fix .
    echo "Running ruff format ."
    ruff format .
else
    echo "Ruff not found or no pyproject.toml, skipping Python linting."
fi

echo -e "${BLUE}=== Step 2: Markdown Formatting (mdformat) ===${NC}"
if command -v mdformat &> /dev/null; then
    echo "Running mdformat ."
    mdformat .
elif command -v uv &> /dev/null && [ -f "pyproject.toml" ]; then
    # Try running via uv if not in path
    uv run mdformat . 2>/dev/null || echo "mdformat not found in uv environment, skipping."
else
    echo "mdformat not found, skipping Markdown formatting."
fi

echo -e "${BLUE}=== Step 3: Markdown Linting (markdownlint) ===${NC}"
if command -v markdownlint &> /dev/null; then
    echo "Running markdownlint --fix ..."
    markdownlint --fix 'docs/**/*.md' 'CHANGELOG.md' 'README.md' 2>/dev/null || true
    markdownlint 'docs/**/*.md' 'CHANGELOG.md' 'README.md'
else
    echo -e "${RED}markdownlint not found, skipping (install: npm install -g markdownlint-cli)${NC}"
fi

echo -e "${BLUE}=== Step 4: Verification ===${NC}"
if command -v uv &> /dev/null && [ -f "pyproject.toml" ]; then
    echo "Verifying clean state..."
    uv run ruff check . && uv run ruff format --check .
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
