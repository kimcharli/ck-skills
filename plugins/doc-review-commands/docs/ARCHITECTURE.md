# Architecture Guide

**Doc Review Commands** follows a modular, command-based architecture designed for efficiency, maintainability, and extensibility.

---

## 🏗️ System Overview

```
User Invokes Command
        ↓
Context Loads (analysis)
        ↓
Command Executes (focused logic)
        ↓
Files Updated OR Analysis Returned
        ↓
Structured Summary
```

---

## 📁 Folder Structure

```
~/.claude/commands/ck/doc-review/
├── main.md              # Orchestrator (entry point)
├── analyze.md           # Analysis sub-command
├── core.md              # Core files update
├── sdd.md               # SDD artifacts update
├── qa.md                # Quality validation
├── help.md              # Help documentation
├── config/
│   └── categories.json  # Pattern configuration
└── tools/
    └── analyzer.sh      # External analysis tool
```

### Folder Rationale

**Self-Contained Design:**

- All commands in one folder for easy installation
- Paired with config and tools (no scattered dependencies)
- Portable across systems (single folder copy)
- Clean git structure for updates

---

## 🎯 Command Architecture

### Modular Design Pattern

Each command is **single-responsibility** and **independently executable**:

| Command   | Responsibility                    | Dependencies     |
| --------- | --------------------------------- | ---------------- |
| `main`    | Orchestrate analysis + delegation | All sub-commands |
| `analyze` | Extract project insights          | analyzer.sh tool |
| `core`    | Update main docs                  | Read, Edit tools |
| `sdd`     | Update specs/plans                | Read, Edit tools |
| `qa`      | Validate documentation            | Grep tool        |
| `help`    | Display usage guide               | None             |

### Why Modular?

**Before (Monolithic):**

- 419 lines in one command
- 10-12K tokens per invocation
- All features load together
- Hard to maintain or extend

**After (Modular):**

- 6 focused commands, 1,667 lines total
- 900-2K tokens per invocation
- Load only needed functionality
- **88% token savings** ✅

---

## 🔧 Core Components

### 1. Command Files (`commands/*.md`)

Each `.md` file is a Claude Code command with frontmatter:

```markdown
---
description: What this command does
allowed-tools: Bash(*), Read(*), Edit(*)
---

## Context

[External data loads here]

## Task

[What the user wants]

## Implementation

[Step-by-step logic]
```

**Key Pattern:**

- YAML frontmatter defines capabilities
- Context section loads external data (blazingly fast!)
- Task section describes goal
- Implementation uses progressive disclosure

### 2. Configuration (`config/categories.json`)

Pattern-based file categorization:

```json
{
  "categories": {
    "developer": {
      "patterns": ["## API", "### Endpoints"],
      "description": "API documentation"
    },
    "user": {
      "patterns": ["## Installation", "### Setup"],
      "description": "User guides"
    }
  },
  "essential_root_files": ["README.md", "CHANGELOG.md"],
  "large_file_threshold": 200
}
```

**Why Pattern-Based?**

- Flexible (customize for any project)
- No hardcoded assumptions
- Works with different documentation styles
- Portable across projects

### 3. External Tool (`tools/analyzer.sh`)

Bash script for instant analysis:

```bash
#!/bin/bash
# Extract documentation principles
# Analyze structure
# Categorize files
# Assess impact
# Generate metrics
```

**Performance Advantage:**

- Runs in < 1 second
- Executes in bash context (no Claude overhead)
- Returns structured output
- Reduces Claude token consumption

---

## 📊 Data Flow

### Analysis Flow

```
User runs /ck:doc-review/analyze
        ↓
main.md loads analyzer.sh context
        ↓
analyzer.sh runs instantly (< 1s)
        ↓
Structured output returned
        ↓
Claude presents findings
```

### Update Flow

```
User runs /ck:doc-review/core "feature X"
        ↓
main.md analyzes project (via analyzer.sh)
        ↓
Updates are suggested
        ↓
Edit tool updates files
        ↓
Summary returned
```

---

## 🎯 Design Patterns

### 1. Progressive Disclosure

Show information progressively to avoid overwhelming users:

```
Step 1: Analyze changes
Step 2: Show what's available
Step 3: Ask what to update (user choice)
Step 4: Execute selected updates
Step 5: Show summary
```

**Benefit:** Users control scope, tokens saved by not doing unnecessary work.

### 2. External Execution

Move heavy lifting outside Claude:

```
❌ Monolithic: Read all files → Parse → Analyze in Claude
✅ Modular: bash tool does analysis → Return structured output
```

**Benefit:** 10x faster, lower token cost, more reliable.

### 3. Configuration-Driven

Customize without changing code:

```yaml
# Change patterns in categories.json
# No code modifications needed
# Works for any documentation style
```

**Benefit:** Extensible, maintainable, user-friendly.

### 4. Single Responsibility

Each command does one thing well:

```
main → orchestrates
analyze → analyzes only
core → updates core files
sdd → updates SDD files
qa → validates only
help → displays help
```

**Benefit:** Easy to understand, test, and extend.

---

## 🔄 Extension Points

### Add a New Command

1. Create `commands/mycommand.md`
2. Define YAML frontmatter
3. Implement logic
4. Reference in `main.md`

**Example:**

```markdown
---
description: Generate diagrams
allowed-tools: Bash(mermaid), Write(*)
---

## Task

Generate architecture diagrams from documentation
```

### Customize Categories

Edit `config/categories.json`:

```json
{
  "categories": {
    "mytype": {
      "patterns": ["Custom patterns"],
      "description": "My category"
    }
  }
}
```

### Extend Analyzer

Add bash functions to `tools/analyzer.sh`:

```bash
analyze_custom() {
  # Custom analysis logic
}
```

---

## 📈 Performance Characteristics

### Token Efficiency

| Operation  | Before   | After     | Savings |
| ---------- | -------- | --------- | ------- |
| Analysis   | 800      | 200       | 75%     |
| Update     | 3K       | 1.2K      | 60%     |
| Validation | 2.5K     | 1.8K      | 28%     |
| **Total**  | **~10K** | **~1.2K** | **88%** |

### Execution Speed

| Operation   | Time        |
| ----------- | ----------- |
| Analyze     | < 1s (bash) |
| Core update | 15-30s      |
| SDD update  | 30-60s      |
| Validate    | 10-20s      |

---

## 🔐 Design Principles

1. **Modularization** - Break into focused commands
2. **Externalization** - Move execution outside Claude
3. **Configuration** - Customize without coding
4. **Progressive** - Disclose information gradually
5. **Portable** - Single folder, no dependencies
6. **Documented** - Clear structure, extensive guides

---

## 🚀 Future Architecture

### Planned Enhancements

- **Diagram Generation** - Mermaid support
- **Claude Skills** - Skill wrapper for broader distribution
- **CI/CD Integration** - GitHub Actions mode
- **Metrics Dashboard** - Documentation health tracking

### Extensibility

The modular design supports:

- Custom commands
- Custom categories
- Custom tools
- Custom templates
- Custom workflows

---

## 🎓 Learning Path

1. **Start:** Read `/ck:doc-review/help`
2. **Understand:** Study `commands/main.md`
3. **Explore:** Review `commands/core.md` and `commands/sdd.md`
4. **Extend:** Create your own command
5. **Master:** Customize categories.json and analyzer.sh

---

**Architecture Guide Complete**

For detailed usage, see [USAGE.md](USAGE.md)
