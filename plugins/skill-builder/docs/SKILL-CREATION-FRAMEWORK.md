# Skill Creation Framework

**Create skills fully, efficiently, fast, and resiliently**

Based on optimization patterns from doc-review-commands. This framework helps you build production-ready Claude Code skills with minimal token usage and maximum reliability.

---

## 📋 Framework Overview

A **Skill Creation Framework** for building Claude Code commands/skills that are:

- **Fully featured** - All components included (logic, validation, caching, docs)
- **Efficient** - Caching, bash scripts, minimal token usage
- **Fast** - Quick execution, progressive feedback
- **Resilient** - Error handling, validation, recovery

---

## 🏗️ Core Architecture

### Layer 1: Command Definition (Markdown + YAML)
```yaml
---
description: What this skill does (concise)
allowed-tools: Bash(*), Read(*), Write(*), Edit(*), Grep(*)
---

# Skill Name

Brief description...
```

### Layer 2: Bash Utility Scripts
- Handle mechanical tasks (file operations, validation, caching)
- Offload complexity from AI tokens
- Provide reusable functions

### Layer 3: Caching & State Management
- Cache expensive results (20-30% savings)
- TTL-based cache invalidation
- Smart cache key generation

### Layer 4: Validation & Testing
- Input validation
- Output validation
- Self-tests and health checks

### Layer 5: Documentation
- Quick reference guide
- Usage examples
- Error handling guide

---

## 🎯 Design Principles

### Principle 1: Use Bash for Mechanical Tasks
**Pattern:** Move validation, file operations, data transformation to bash
```bash
# ✅ GOOD - Pure bash, no tokens
validate_file_exists() {
    [ -f "$1" ] && return 0 || return 1
}

# ❌ BAD - Uses AI tokens
# Use Claude to check if file exists
```

**Token Savings:** 30-40% by offloading mechanical work

### Principle 2: Cache Expensive Operations
**Pattern:** Cache analysis results with TTL
```bash
CACHE_DIR="$HOME/.cache/skill-$SKILL_NAME"
CACHE_LIFETIME=3600  # 1 hour

# Check cache first
if is_cache_valid "key" "$CACHE_LIFETIME"; then
    read_cache "key"
    exit 0
fi

# Run expensive operation
result=$(ai_operation)

# Save to cache
write_cache "key" "$result"
```

**Token Savings:** 20-30% on repeat operations

### Principle 3: Provide Lightweight Mode
**Pattern:** Fast path for simple/known cases
```bash
# Quick mode: skip analysis, direct action
/skill:quick "simple task"  # 400-600 tokens

# Full mode: with analysis and validation
/skill:full "complex task"  # 1.5-2K tokens
```

**Token Savings:** 50-70% for simple cases

### Principle 4: Modular Design
**Pattern:** Break into focused sub-commands
```bash
# Instead of one monolithic command:
/skill everything

# Use focused sub-commands:
/skill:analyze      # Understanding phase
/skill:validate     # Checking phase
/skill:execute      # Action phase
/skill:quick        # Fast path
```

**Token Savings:** Load only what's needed

### Principle 5: Smart Error Handling
**Pattern:** Graceful degradation and recovery
```bash
# Try optimal path, fall back to safe defaults
if [ -f "$CONFIG" ]; then
    source "$CONFIG"
else
    # Use defaults
    use_defaults
fi

# Validate before proceeding
if ! validate_inputs; then
    suggest_fixes
    exit 1
fi
```

---

## 📁 Skill Structure

```
skills/
├── my-skill/
│   ├── commands/
│   │   ├── my-skill.md              # Main command file
│   │   ├── my-skill:quick.md        # Lightweight mode
│   │   ├── my-skill:validate.md     # Validation sub-command
│   │   └── my-skill:help.md         # Help sub-command
│   ├── tools/
│   │   ├── executor.sh              # Main logic in bash
│   │   ├── validator.sh             # Validation functions
│   │   └── cache-manager.sh         # Cache utilities
│   ├── templates/
│   │   ├── example-input.md         # Template examples
│   │   └── config-template.yaml     # Configuration template
│   ├── tests/
│   │   ├── test-basic.sh            # Basic functionality tests
│   │   ├── test-edge-cases.sh       # Edge case tests
│   │   └── test-validation.sh       # Validation tests
│   └── docs/
│       ├── README.md                # Quick start
│       ├── GUIDE.md                 # Complete guide
│       ├── API.md                   # API documentation
│       └── EXAMPLES.md              # Usage examples
```

---

## ⚡ Creation Workflow

### Step 1: Define the Skill (5-10 min)

**Inputs:**
- What does the skill do?
- Who uses it?
- What are the inputs/outputs?
- What are success/failure modes?

**Outputs:**
- Skill specification document
- Use case scenarios
- Architecture diagram

### Step 2: Build Core Logic (30-60 min)

**Create:**
- Main command file (my-skill.md)
- Executor script (tools/executor.sh)
- Basic error handling

**Token Cost:** 1.5-2K per iteration

### Step 3: Add Optimization (15-30 min)

**Implement:**
- Caching layer (20-30% savings)
- Bash validation (30-40% savings)
- Lightweight mode (50-70% savings)

**Token Cost:** 800-1.2K total

### Step 4: Build Sub-commands (20-40 min)

**Create:**
- my-skill:quick (lightweight)
- my-skill:validate (validation)
- my-skill:help (documentation)

**Token Cost:** 1-1.5K total

### Step 5: Write Tests (20-30 min)

**Test:**
- Basic functionality
- Edge cases
- Error conditions
- Cache behavior

**Token Cost:** 800-1K

### Step 6: Document (15-20 min)

**Write:**
- Quick reference
- Complete guide
- Examples
- API documentation

**Token Cost:** 600-800

### Step 7: Validation & Polish (10-15 min)

**Verify:**
- All tests pass
- Documentation complete
- No regressions
- Performance acceptable

**Token Cost:** 400-600

---

## 🎨 Template Library

### Template 1: Transformation Skill
```yaml
Purpose: Transform data from one format to another
Input: File or text in format A
Output: File or text in format B
Pattern: Read → Parse → Transform → Write → Validate
```

### Template 2: Analysis Skill
```yaml
Purpose: Analyze data and generate insights
Input: Files or text to analyze
Output: Analysis report
Pattern: Load → Analyze → Cache → Report
```

### Template 3: Generator Skill
```yaml
Purpose: Generate new content (code, docs, config)
Input: Requirements or parameters
Output: Generated content
Pattern: Define → Generate → Validate → Output
```

### Template 4: Validation Skill
```yaml
Purpose: Validate content against criteria
Input: Files or text to validate
Output: Validation report with fixes
Pattern: Load → Validate → Report → Suggest fixes
```

### Template 5: Orchestration Skill
```yaml
Purpose: Coordinate multiple operations
Input: Complex task definition
Output: Coordinated results
Pattern: Parse → Plan → Execute → Aggregate → Report
```

---

## 💾 Caching Strategy

### Cache Types

**1. Analysis Cache**
- TTL: 1 hour
- Use for: Results of expensive analysis
- Key format: `skill:analysis:{file_hash}`
- Example: Parsed file structure

**2. Validation Cache**
- TTL: 30 minutes
- Use for: Validation results
- Key format: `skill:validation:{input_hash}`
- Example: Schema validation results

**3. Template Cache**
- TTL: 24 hours
- Use for: Loaded templates
- Key format: `skill:template:{name}`
- Example: Code templates

**4. Config Cache**
- TTL: Never (manual clear)
- Use for: Configuration data
- Key format: `skill:config:{name}`
- Example: User preferences

### Cache Implementation

```bash
# Initialize cache
init_cache() {
    mkdir -p "$CACHE_DIR"
}

# Check cache validity
is_cache_valid() {
    local key="$1"
    local ttl="${2:-3600}"
    [ -f "$CACHE_DIR/$key" ] || return 1
    [ $(($(date +%s) - $(stat -f%m "$CACHE_DIR/$key"))) -lt "$ttl" ]
}

# Read from cache
read_cache() {
    [ -f "$CACHE_DIR/$1" ] && cat "$CACHE_DIR/$1"
}

# Write to cache
write_cache() {
    cat > "$CACHE_DIR/$1"
}

# Clear cache
clear_cache() {
    rm -rf "$CACHE_DIR"
}
```

---

## ✅ Validation Framework

### Input Validation
```bash
validate_inputs() {
    # Check required parameters
    [ -z "$PARAM1" ] && { echo "Missing param1"; return 1; }

    # Check file exists
    [ ! -f "$INPUT_FILE" ] && { echo "File not found"; return 1; }

    # Check format
    validate_format "$INPUT_FILE" || return 1

    return 0
}
```

### Output Validation
```bash
validate_output() {
    # Check output exists
    [ ! -f "$OUTPUT_FILE" ] && { echo "No output generated"; return 1; }

    # Check output is valid
    validate_format "$OUTPUT_FILE" || return 1

    # Check output is non-empty
    [ -s "$OUTPUT_FILE" ] || { echo "Empty output"; return 1; }

    return 0
}
```

### Self-Tests
```bash
run_self_tests() {
    echo "Running self-tests..."

    # Test 1: Basic functionality
    test_basic && echo "✅ Basic test passed"

    # Test 2: Edge cases
    test_edge_cases && echo "✅ Edge case tests passed"

    # Test 3: Error handling
    test_error_handling && echo "✅ Error handling tests passed"

    echo "All tests passed!"
}
```

---

## 🚀 Execution Modes

### Mode 1: Quick (Lightweight)
- Skip analysis
- Use defaults/templates
- Direct execution
- **Token cost:** 400-600
- **Time:** < 30 seconds

### Mode 2: Standard (Full)
- Full analysis
- Custom configuration
- Complete validation
- **Token cost:** 1.2-1.5K
- **Time:** 2-3 seconds

### Mode 3: Expert (Advanced)
- Deep analysis
- Fine-grained control
- Extensive options
- **Token cost:** 1.8-2K
- **Time:** 3-5 seconds

### Mode 4: Batch (Efficient)
- Process multiple items
- Amortize overhead
- Minimal token per item
- **Token cost:** 800-1K + 100-200 per item
- **Time:** Variable

---

## 📊 Token Budget

### Typical Skill Usage

**Daily Usage (5 runs):**
- 3 quick runs: 1.2-1.8K
- 2 standard runs: 2.4-3K
- **Total:** 3.6-4.8K tokens/day

**Weekly Usage (35 runs):**
- 25 quick runs: 10-15K
- 10 standard runs: 12-15K
- **Total:** 22-30K tokens/week

**Monthly Usage (140 runs):**
- 100 quick runs: 40-60K
- 40 standard runs: 48-60K
- **Total:** 88-120K tokens/month

---

## 🔧 Debugging & Logging

### Logging Levels
```bash
DEBUG=0   # No logging
DEBUG=1   # Errors only
DEBUG=2   # Errors + warnings
DEBUG=3   # All messages
DEBUG=4   # With function traces
```

### Logging Functions
```bash
log_error() {
    [ $DEBUG -ge 1 ] && echo "❌ ERROR: $*" >&2
}

log_warning() {
    [ $DEBUG -ge 2 ] && echo "⚠️  WARNING: $*" >&2
}

log_info() {
    [ $DEBUG -ge 3 ] && echo "ℹ️  INFO: $*" >&2
}

log_debug() {
    [ $DEBUG -ge 4 ] && echo "🐛 DEBUG: $*" >&2
}
```

---

## 📚 Documentation Template

### Quick Start (README.md)
```markdown
# Skill Name

One-sentence description.

## Quick Usage

```bash
/skill "simple task"
```

## Examples

[3-4 common examples]

## Learn More

See GUIDE.md for complete documentation.
```

### Complete Guide (GUIDE.md)
```markdown
# Complete Guide

## Overview
[What the skill does]

## Installation
[Setup instructions]

## Usage

### Basic Mode
[Basic examples]

### Advanced Features
[Advanced options]

### Configuration
[Config options]

## Error Handling
[Common errors and solutions]

## Performance
[Token usage, speed]

## API Reference
[Command reference]
```

---

## 🎓 Best Practices

### 1. Start Simple
- Implement MVP first (main functionality)
- Add optimizations after (caching, modes)
- Document as you go

### 2. Test Early & Often
- Write tests before implementation
- Test happy path and edge cases
- Test error conditions

### 3. Cache Strategically
- Cache expensive operations (analysis, parsing)
- Don't cache user inputs (security)
- Clear cache documentation

### 4. Modularize
- Break into focused sub-commands
- Reuse functions across commands
- DRY principle

### 5. Document Thoroughly
- Quick reference for common cases
- Complete guide for advanced features
- Examples for each feature

### 6. Monitor Performance
- Track token usage
- Measure execution time
- Profile bottlenecks

---

## 🛡️ Resilience Patterns

### Pattern 1: Graceful Degradation
```bash
# Try optimal, fall back to safe
if has_advanced_features; then
    use_advanced_mode
else
    use_basic_mode
fi
```

### Pattern 2: Retry Logic
```bash
retry_with_backoff() {
    local max_attempts=3
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        operation && return 0
        sleep $((2 ** attempt))
        attempt=$((attempt + 1))
    done
    return 1
}
```

### Pattern 3: Circuit Breaker
```bash
# Stop trying if service is down
if is_service_down; then
    suggest_alternatives
    exit 1
fi
```

### Pattern 4: Validation Before Action
```bash
# Never proceed without validation
validate_inputs || exit 1
validate_state || exit 1
perform_action
validate_output || exit 1
```

---

## ✨ Example: Complete Skill Creation

See example in: `SKILL-CREATION-EXAMPLE.md`

Includes:
- Full skill definition
- All support scripts
- Test suite
- Documentation
- Real token measurements

---

## 🎯 Success Criteria

A well-created skill should:

- ✅ Solve the problem completely
- ✅ Use < 2K tokens for standard operation
- ✅ Complete in < 5 seconds
- ✅ Have comprehensive tests (> 80% coverage)
- ✅ Have complete documentation
- ✅ Handle errors gracefully
- ✅ Provide caching (20-30% improvement)
- ✅ Have lightweight mode (50-70% savings)
- ✅ Be maintainable and extensible

---

## 📖 Further Reading

- `OPTIMIZATION-ANALYSIS.md` - Token optimization strategies
- `QUICK-REFERENCE.md` - Quick lookup guide
- Doc-review-commands source code - Real implementation example

---

**Framework Version:** 1.0
**Last Updated:** 2025-10-24
**Based on:** doc-review-commands optimization work
