#!/bin/bash
# Skill Builder Generator
# Generates production-ready Claude Code skills from templates

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$PROJECT_DIR/templates"
# Only append /skills if SKILLS_BASE_DIR doesn't already end with /skills
if [[ "${SKILLS_BASE_DIR:-.}" == */skills ]]; then
    SKILLS_BASE_DIR="${SKILLS_BASE_DIR:-.}"
else
    SKILLS_BASE_DIR="${SKILLS_BASE_DIR:-.}/skills"
fi
CACHE_DIR="$HOME/.cache/skill-builder"

# Colors
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

validate_skill_name() {
    local name="$1"

    # Check format (kebab-case)
    if ! [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
        log_error "Skill name must be lowercase with hyphens only: '$name'"
        return 1
    fi

    # Check length
    if [ ${#name} -lt 3 ] || [ ${#name} -gt 30 ]; then
        log_error "Skill name must be 3-30 characters"
        return 1
    fi

    # Check if already exists
    if [ -d "$SKILLS_BASE_DIR/$name" ]; then
        log_error "Skill '$name' already exists"
        return 1
    fi

    return 0
}

validate_description() {
    local desc="$1"

    if [ -z "$desc" ]; then
        log_error "Description cannot be empty"
        return 1
    fi

    if [ ${#desc} -gt 100 ]; then
        log_error "Description must be < 100 characters"
        return 1
    fi

    return 0
}

# ============================================================================
# Template Functions
# ============================================================================

# Initialize cache
init_cache() {
    mkdir -p "$CACHE_DIR"
}

# Generate main command file
generate_main_command() {
    local name="$1"
    local description="$2"
    local features="$3"

    # Format features as markdown list
    local formatted_features=$(echo "$features" | tr ',' '\n' | sed 's/^/- /')

    cat > "$SKILLS_BASE_DIR/$name/commands/${name}.md" <<EOF
---
description: $description
allowed-tools: Read(*), Write(*), Edit(*), Bash(*)
---

# ${name^}

$description

---

## Task

**Process:** \$ARGUMENTS

---

## Step 1: Validate Input

Check input format and parameters.

---

## Step 2: Execute Core Logic

1. Load configuration
2. Process input
3. Generate output
4. Validate result

---

## Step 3: Output Results

Present findings:
- What was done
- What changed
- Key metrics

---

## Features

$formatted_features

---

## Next Steps

Recommendations for follow-up actions.
EOF
}

# Generate quick mode command
generate_quick_command() {
    local name="$1"
    local description="$2"

    cat > "$SKILLS_BASE_DIR/$name/commands/${name}:quick.md" <<EOF
---
description: Quick ${name^} - fast execution with defaults
allowed-tools: Bash(*), Read(*), Write(*)
---

# Quick ${name^}

Fast execution using standard configuration.

## Task

Quick process: \$ARGUMENTS

---

## Execution

1. Use cached configuration
2. Apply standard settings
3. Generate output
4. Done (< 30 seconds)

---

## Example

\`\`\`bash
/ck:$name:quick "input here"
\`\`\`

Fast, efficient, minimal tokens (400-600).
EOF
}

# Generate validation command
generate_validate_command() {
    local name="$1"

    cat > "$SKILLS_BASE_DIR/$name/commands/${name}:validate.md" <<EOF
---
description: Validate output from ${name^}
allowed-tools: Bash(*)
---

# Validate ${name^}

Check quality and correctness of output.

## Task

Validate: \$ARGUMENTS

---

## Validations

- ✅ Format validity
- ✅ Content quality
- ✅ Required fields

---

## Output

Pass/fail report with details.
EOF
}

# Generate executor script
generate_executor() {
    local name="$1"

    cat > "$SKILLS_BASE_DIR/$name/tools/executor.sh" <<'EXECUTOR_EOF'
#!/bin/bash
# Executor - Core logic - customize this file

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Cache configuration
CACHE_DIR="$HOME/.cache/SKILL_NAME"
CACHE_LIFETIME=3600

# ============================================================================
# Logging Functions
# ============================================================================

log_error() {
    echo "❌ ERROR: $*" >&2
}

log_info() {
    echo "ℹ️  INFO: $*"
}

log_success() {
    echo "✅ $*"
}

# ============================================================================
# Cache Functions
# ============================================================================

init_cache() {
    mkdir -p "$CACHE_DIR"
}

is_cache_valid() {
    local key="$1"
    local lifetime="${2:-$CACHE_LIFETIME}"

    [ ! -f "$CACHE_DIR/$key" ] && return 1

    local age=$(($(date +%s) - $(stat -f%m "$CACHE_DIR/$key" 2>/dev/null || stat -c%Y "$CACHE_DIR/$key")))
    [ $age -lt $lifetime ]
}

read_cache() {
    [ -f "$CACHE_DIR/$1" ] && cat "$CACHE_DIR/$1"
}

write_cache() {
    cat > "$CACHE_DIR/$1"
}

# ============================================================================
# Core Functions - Customize these
# ============================================================================

validate_input() {
    local input="$1"

    # TODO: Add your validation logic
    [ -z "$input" ] && { log_error "Input required"; return 1; }

    return 0
}

process_input() {
    local input="$1"

    # TODO: Add your processing logic
    log_info "Processing: $input"

    # Your skill logic here
    echo "Processing complete"

    return 0
}

# ============================================================================
# Main Execution
# ============================================================================

main() {
    init_cache

    local input="${1:?Input required}"

    # Validate
    validate_input "$input" || return 1

    # Check cache
    local cache_key="operation:$input"
    if is_cache_valid "$cache_key"; then
        log_info "Using cached result"
        read_cache "$cache_key"
        return 0
    fi

    # Process
    local result=$(process_input "$input") || return 1

    # Cache result
    echo "$result" | write_cache "$cache_key"

    # Output
    echo "$result"
}

main "$@"
EXECUTOR_EOF

    chmod +x "$SKILLS_BASE_DIR/$name/tools/executor.sh"
    sed -i '' "s|SKILL_NAME|$name|g" "$SKILLS_BASE_DIR/$name/tools/executor.sh"
}

# Generate validator script
generate_validator() {
    local name="$1"

    cat > "$SKILLS_BASE_DIR/$name/tools/validator.sh" <<'VALIDATOR_EOF'
#!/bin/bash
# Validation functions

# Validate input format
validate_format() {
    local input="$1"

    # TODO: Add format validation
    [ -z "$input" ] && return 1

    return 0
}

# Validate output quality
validate_quality() {
    local output="$1"

    # TODO: Add quality checks
    [ -z "$output" ] && return 1

    return 0
}

# Run all validations
validate_all() {
    validate_format "$1" || return 1
    validate_quality "$2" || return 1
    return 0
}

# Main
case "$1" in
    format) validate_format "$2" ;;
    quality) validate_quality "$2" ;;
    all) validate_all "$2" "$3" ;;
    *) echo "Unknown validation: $1"; return 1 ;;
esac
VALIDATOR_EOF

    chmod +x "$SKILLS_BASE_DIR/$name/tools/validator.sh"
}

# Generate test file
generate_tests() {
    local name="$1"

    cat > "$SKILLS_BASE_DIR/$name/tests/test-basic.sh" <<'EOF'
#!/bin/bash
# Basic tests for @@SKILL_NAME@@

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR/../tools"

echo "Running tests for @@SKILL_NAME@@..."

# Test 1: Simple execution
test_simple() {
    bash "$TOOLS_DIR/executor.sh" "test input" >/dev/null 2>&1 && echo "✅ Test 1: Simple execution"
}

# Test 2: Validation
test_validation() {
    bash "$TOOLS_DIR/validator.sh" format "test" >/dev/null 2>&1 && echo "✅ Test 2: Validation"
}

# Run tests
test_simple
test_validation

echo "Tests complete!"
EOF

    chmod +x "$SKILLS_BASE_DIR/$name/tests/test-basic.sh"
}

# Generate documentation
generate_docs() {
    local name="$1"
    local description="$2"
    local features="$3"

    # Format features
    local formatted_features=$(echo "$features" | tr ',' '\n' | sed 's/^/- /')

    # README
    cat > "$SKILLS_BASE_DIR/$name/docs/README.md" <<EOF
# ${name^}

$description

## Quick Start

\`\`\`bash
/ck:$name:quick "input here"
\`\`\`

## Features

$formatted_features

## Examples

\`\`\`bash
# Basic usage
/ck:$name "example input"

# Quick mode
/ck:$name:quick "simple input"

# Validation
/ck:$name:validate "output"
\`\`\`

## Learn More

See GUIDE.md for complete documentation.
EOF

    # GUIDE
    cat > "$SKILLS_BASE_DIR/$name/docs/GUIDE.md" <<EOF
# ${name^} - Complete Guide

## Overview

$description

## Features

$formatted_features

## Modes

### Quick Mode
- Fast execution (< 30 seconds)
- Standard configuration
- 400-600 tokens

### Standard Mode
- Full processing
- Custom configuration
- 1.2-1.5K tokens

## Configuration

See executor.sh for configuration options.

## Token Usage

- Quick: 400-600 tokens
- Standard: 1.2-1.5K tokens
- Cached: 20-30% savings

## Error Handling

Common errors and solutions documented in executor.sh.
EOF
}

# ============================================================================
# Main Generation Function
# ============================================================================

generate_skill() {
    local name="$1"
    local description="$2"
    local features="${3:-Basic functionality}"

    log_info "Generating skill: $name"

    # Validate
    validate_skill_name "$name" || return 1
    validate_description "$description" || return 1

    # Create directories
    mkdir -p "$SKILLS_BASE_DIR/$name"/{commands,tools,templates,tests,docs}

    # Generate files
    log_info "Generating command files..."
    generate_main_command "$name" "$description" "$features"
    generate_quick_command "$name" "$description"
    generate_validate_command "$name"

    log_info "Generating scripts..."
    generate_executor "$name"
    generate_validator "$name"

    log_info "Generating tests..."
    generate_tests "$name"

    log_info "Generating documentation..."
    generate_docs "$name" "$description" "$features"

    log_success "Skill created: $SKILLS_BASE_DIR/$name/"

    # Show structure
    echo ""
    echo "Structure:"
    tree "$SKILLS_BASE_DIR/$name" 2>/dev/null || find "$SKILLS_BASE_DIR/$name" -type f | sed "s|$SKILLS_BASE_DIR/$name|  |"
    echo ""

    return 0
}

# ============================================================================
# Main Execution
# ============================================================================

main() {
    init_cache

    local skill_name="$1"
    local description="${2:-Default skill description}"
    local features="${3:-Core functionality}"

    [ -z "$skill_name" ] && { log_error "Usage: $0 <skill-name> [description] [features]"; return 1; }

    generate_skill "$skill_name" "$description" "$features"
}

main "$@"
