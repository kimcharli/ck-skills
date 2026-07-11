#!/usr/bin/env bash
# validate-skill: Ensure SKILL.md has valid YAML frontmatter for Gemini CLI.
# Required format:
# ---
# name: skill-name
# description: Detailed description for discovery.
# ---

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# Helper Functions
# ============================================================================

log_error() {
    echo -e "${RED}❌ ERROR: $*${NC}" >&2
}

log_info() {
    echo -e "${BLUE}ℹ️  INFO: $*${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $*${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  WARNING: $*${NC}"
}

# ============================================================================
# Validation Functions
# ============================================================================

validate_skill_file() {
    local file="$1"
    local errors=0

    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        return 1
    fi

    echo -e "${BLUE}Checking $file...${NC}"

    # 1. Check for starting ---
    if [ "$(head -n 1 "$file")" != "---" ]; then
        log_error "Missing starting '---' delimiter in $file"
        errors=$((errors + 1))
    fi

    # 2. Check for name field
    if ! grep -q "^name:" "$file"; then
        log_error "Missing 'name' field in frontmatter of $file"
        errors=$((errors + 1))
    fi

    # 3. Check for description field
    if ! grep -q "^description:" "$file"; then
        log_error "Missing 'description' field in frontmatter of $file"
        errors=$((errors + 1))
    fi

    # 4. Check for closing --- (within first 20 lines)
    if ! head -n 20 "$file" | tail -n +2 | grep -q "^---$"; then
        log_error "Missing closing '---' delimiter in first 20 lines of $file"
        errors=$((errors + 1))
    fi

    # 5. Check name field is not empty
    local name_val=$(grep "^name:" "$file" | sed 's/name:[[:space:]]*//' | xargs)
    if [ -z "$name_val" ]; then
        log_error "Empty 'name' field in $file"
        errors=$((errors + 1))
    fi

    # 6. Check description field is not empty
    local desc_val=$(grep "^description:" "$file" | sed 's/description:[[:space:]]*//' | xargs)
    if [ -z "$desc_val" ]; then
        log_error "Empty 'description' field in $file"
        errors=$((errors + 1))
    fi

    if [ $errors -gt 0 ]; then
        return 1
    fi

    log_success "Valid frontmatter: $name_val"
    return 0
}

# ============================================================================
# Main Execution
# ============================================================================

main() {
    local target="${1:-.}"
    local total_errors=0
    local total_checked=0

    # Find all SKILL.md files
    local skill_files=()
    if [ -f "$target" ]; then
        skill_files+=("$target")
    else
        while IFS= read -r -d '' file; do
            skill_files+=("$file")
        done < <(find "$target" -name "SKILL.md" -not -path "*/.git/*" -print0)
    fi

    if [ ${#skill_files[@]} -eq 0 ]; then
        log_warning "No SKILL.md files found in $target"
        return 0
    fi

    for file in "${skill_files[@]}"; do
        total_checked=$((total_checked + 1))
        if ! validate_skill_file "$file"; then
            total_errors=$((total_errors + 1))
        fi
    done

    echo ""
    if [ $total_errors -gt 0 ]; then
        log_error "Validation failed: $total_errors error(s) found across $total_checked file(s)."
        exit 1
    else
        log_success "Validation passed: $total_checked file(s) are valid."
        exit 0
    fi
}

main "$@"
