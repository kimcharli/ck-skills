#!/bin/bash
# Documentation Analyzer Tool
# Used by /ck:doc-review command
# Purpose: Extract documentation analysis logic for reusability and testability

set -e  # Exit on error

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../commands/ck/doc-categories.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# Function: analyze_principles
# Purpose: Extract and validate project-specific documentation principles
# ============================================================================
analyze_principles() {
    echo "=== 📋 Project Documentation Principles Analysis ==="
    echo ""

    local principles_found=0
    local conflicts=0

    # Extract key documentation design claims
    echo "🔍 Searching for documentation philosophy..."
    if grep -i "no.*config.*files\|zero.*setup\|interactive.*config\|self.*contained\|minimal.*docs\|single.*file\|documentation.*philosophy" README.md CLAUDE.md *.md 2>/dev/null; then
        principles_found=$((principles_found + 1))
        echo ""
    else
        echo "   No specific documentation philosophy found"
        echo ""
    fi

    # Check for explicit documentation structure preferences
    echo "🔍 Checking documentation structure preferences..."
    if grep -i "directory.*structure\|file.*organization\|docs.*folder\|keep.*root\|avoid.*dirs" README.md CLAUDE.md *.md 2>/dev/null; then
        principles_found=$((principles_found + 1))
        echo ""
    else
        echo "   No explicit structure preferences found"
        echo ""
    fi

    # Look for configuration philosophy
    echo "🔍 Analyzing configuration approach..."
    if grep -i "no.*env\|environment.*files\|configuration.*approach\|setup.*method" README.md CLAUDE.md *.md 2>/dev/null; then
        principles_found=$((principles_found + 1))
        echo ""
    else
        echo "   No specific configuration philosophy found"
        echo ""
    fi

    # Summary
    echo "📊 Summary:"
    echo "   Principles detected: $principles_found"
    echo "   Conflicts detected: $conflicts"

    if [ $principles_found -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}⚠️  Project has specific documentation principles${NC}"
        echo "   Ensure updates respect these principles"
    else
        echo ""
        echo -e "${GREEN}✅ No specific documentation constraints detected${NC}"
        echo "   Standard documentation updates can proceed"
    fi
}

# ============================================================================
# Function: analyze_structure
# Purpose: Analyze current documentation structure and identify issues
# ============================================================================
analyze_structure() {
    echo "=== 📁 Documentation Structure Analysis ==="
    echo ""

    # Check if config file exists
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}❌ Config file not found: $CONFIG_FILE${NC}"
        return 1
    fi

    # Count documentation files
    local total_md=$(find . -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    local root_md=$(find . -maxdepth 1 -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    local sdd_files=$(find ./specs -name "spec.md" -o -name "plan.md" -o -name "tasks.md" 2>/dev/null | wc -l | tr -d ' ')

    echo "📊 Inventory:"
    echo "   Total .md files: $total_md"
    echo "   Root .md files: $root_md"
    echo "   SDD artifacts: $sdd_files"
    echo ""

    # Discover SDD artifacts
    if [ $sdd_files -gt 0 ]; then
        echo "📋 SDD Artifacts Found:"
        find ./specs -type f \( -name "spec.md" -o -name "plan.md" -o -name "tasks.md" \) 2>/dev/null | while read file; do
            echo "   $file"
        done
        echo ""
    fi

    # Find potential misplaced files in root
    echo "🔍 Root Directory Analysis:"
    local misplaced=$(find . -maxdepth 1 -name "*.md" | grep -E "(EXAMPLES?|GUIDE|TUTORIAL|REFERENCE|API|SPEC|MANUAL)" 2>/dev/null || true)
    if [ -n "$misplaced" ]; then
        echo -e "${YELLOW}⚠️  Potential candidates for docs/ organization:${NC}"
        echo "$misplaced" | while read file; do
            echo "   $file"
        done
    else
        echo "   ✅ No obviously misplaced files detected"
    fi
    echo ""

    # Check file sizes
    echo "📄 Large Documentation Files (>200 lines):"
    find . -maxdepth 1 -name "*.md" -exec wc -l {} \; 2>/dev/null | sort -nr | head -5 | while read lines file; do
        if [ "$lines" -gt 200 ]; then
            echo "   $file: $lines lines"
        fi
    done
    echo ""
}

# ============================================================================
# Function: categorize_files
# Purpose: Categorize documentation files by content type
# ============================================================================
categorize_files() {
    echo "=== 🏷️  Documentation File Categorization ==="
    echo ""

    # Check if config file exists
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}❌ Config file not found: $CONFIG_FILE${NC}"
        return 1
    fi

    # Get essential files list from config (simplified - just hardcode for now)
    local essential_files=("README.md" "CLAUDE.md" "GEMINI.md" "CHANGELOG.md" "CONTRIBUTING.md" "LICENSE.md")

    for file in *.md; do
        [ ! -f "$file" ] && continue

        # Check if essential root file
        local is_essential=false
        for essential in "${essential_files[@]}"; do
            if [ "$file" = "$essential" ]; then
                is_essential=true
                break
            fi
        done

        if [ "$is_essential" = true ]; then
            echo -e "${GREEN}✅ $file${NC} - Keep at root (essential)"
            continue
        fi

        # Analyze content patterns
        local category=""
        local keywords=""

        if grep -q "## API\|### Endpoints\|Request/Response\|curl.*http\|POST\|GET\|PUT" "$file" 2>/dev/null; then
            category="developer"
            keywords="API documentation"
        elif grep -q "## Installation\|### Setup\|Getting Started\|Quick Start\|## Usage\|### Examples" "$file" 2>/dev/null; then
            category="user"
            keywords="User guide"
        elif grep -q "## Architecture\|### Design\|Technical.*Spec\|## Security\|Performance\|Requirements" "$file" 2>/dev/null; then
            category="technical"
            keywords="Technical specification"
        elif grep -q "AI\|Claude\|Gemini\|Assistant\|Tool.*Usage\|Prompt" "$file" 2>/dev/null; then
            category="ai-agents"
            keywords="AI integration"
        fi

        if [ -n "$category" ]; then
            echo -e "${BLUE}📁 $file${NC} → docs/$category/ ($keywords)"
        else
            echo -e "${YELLOW}❓ $file${NC} - Manual review needed"
        fi
    done
    echo ""
}

# ============================================================================
# Function: analyze_impact
# Purpose: Determine documentation impact from recent code changes
# ============================================================================
analyze_impact() {
    echo "=== 🎯 Change Impact Analysis ==="
    echo ""

    # Get recent changes
    echo "📝 Recent Changes (last 5 commits):"
    local changed_files=$(git diff --name-only HEAD~5..HEAD 2>/dev/null || git diff --name-only HEAD~3..HEAD 2>/dev/null || git diff --name-only HEAD~1..HEAD 2>/dev/null || echo "")

    if [ -z "$changed_files" ]; then
        echo "   No recent commits to analyze"
        echo ""
        return 0
    fi

    echo "$changed_files" | while read file; do
        echo "   Changed: $file"
    done
    echo ""

    # Analyze impact areas
    local needs_readme=false
    local needs_claude=false
    local needs_sdd=false
    local needs_api=false

    echo "📊 Impact Assessment:"

    # Check if source code changed
    if echo "$changed_files" | grep -q "\.py$\|\.js$\|\.ts$\|\.go$\|\.rs$" 2>/dev/null; then
        echo "   ⚠️  Source code changed → Update README, CLAUDE, possibly API docs"
        needs_readme=true
        needs_claude=true
        needs_api=true
    fi

    # Check if specs changed
    if echo "$changed_files" | grep -q "specs/" 2>/dev/null; then
        echo "   ⚠️  Specs changed → Update SDD artifacts"
        needs_sdd=true
    fi

    # Check if tests changed
    if echo "$changed_files" | grep -q "test\|spec" 2>/dev/null; then
        echo "   ℹ️  Tests changed → Consider updating test documentation"
    fi

    # Check if config changed
    if echo "$changed_files" | grep -q "\.toml$\|\.yaml$\|\.json$\|\.env" 2>/dev/null; then
        echo "   ℹ️  Configuration changed → Update setup/config docs"
        needs_readme=true
    fi

    echo ""
    echo "🎯 Recommended Update Scope:"
    [ "$needs_readme" = true ] && echo "   - README.md (features, installation, usage)"
    [ "$needs_claude" = true ] && echo "   - CLAUDE.md (AI context, new modules)"
    [ "$needs_sdd" = true ] && echo "   - SDD artifacts (spec.md, plan.md, tasks.md)"
    [ "$needs_api" = true ] && echo "   - API/Technical documentation"
    echo ""
}

# ============================================================================
# Function: generate_metrics
# Purpose: Generate documentation metrics for reporting
# ============================================================================
generate_metrics() {
    echo "=== 📊 Documentation Metrics ==="
    echo ""

    local total_md=$(find . -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    local root_md=$(find . -maxdepth 1 -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    local docs_md=$(find ./docs -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    local specs_md=$(find ./specs -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

    echo "Total documentation files: $total_md"
    echo "  - Root directory: $root_md"
    echo "  - docs/ directory: $docs_md"
    echo "  - specs/ directory: $specs_md"
    echo ""

    # Total line counts
    local total_lines=$(find . -name "*.md" -exec wc -l {} \; 2>/dev/null | awk '{sum+=$1} END {print sum}')
    echo "Total documentation lines: ${total_lines:-0}"
    echo ""

    # Git stats if available
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local last_commit=$(git log -1 --format="%h - %s" 2>/dev/null || echo "N/A")
        local last_doc_commit=$(git log -1 --format="%h - %s" -- "*.md" 2>/dev/null || echo "No doc commits found")

        echo "Git Information:"
        echo "  Last commit: $last_commit"
        echo "  Last doc update: $last_doc_commit"
    fi
    echo ""
}

# ============================================================================
# Main execution
# ============================================================================
main() {
    local command=${1:-help}

    case "$command" in
        principles)
            analyze_principles
            ;;
        structure)
            analyze_structure
            ;;
        categorize)
            categorize_files
            ;;
        impact)
            analyze_impact
            ;;
        metrics)
            generate_metrics
            ;;
        all)
            analyze_principles
            echo ""
            analyze_structure
            echo ""
            categorize_files
            echo ""
            analyze_impact
            echo ""
            generate_metrics
            ;;
        help|--help|-h)
            echo "Documentation Analyzer Tool"
            echo ""
            echo "Usage: $0 <command>"
            echo ""
            echo "Commands:"
            echo "  principles  - Extract project documentation principles"
            echo "  structure   - Analyze documentation structure"
            echo "  categorize  - Categorize files by content type"
            echo "  impact      - Analyze change impact from git history"
            echo "  metrics     - Generate documentation metrics"
            echo "  all         - Run all analyses"
            echo "  help        - Show this help message"
            echo ""
            ;;
        *)
            echo -e "${RED}Unknown command: $command${NC}"
            echo "Run '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
