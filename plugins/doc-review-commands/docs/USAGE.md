# Detailed Usage Guide

Complete reference for all Doc Review Commands with examples and patterns.

---

## 🎯 Quick Command Reference

| Command                  | Token Cost       | Time     | Use Case                       |
| ------------------------ | ---------------- | -------- | ------------------------------ |
| `/ck:doc-review/help`    | ~200             | Instant  | First time? Start here         |
| `/ck:doc-review/analyze` | ~600-800         | < 1s     | What needs updating?           |
| `/ck:doc-review/core`    | ~1.2-1.5K        | 15-30s   | Update README/CLAUDE/CHANGELOG |
| `/ck:doc-review/sdd`     | ~1.5-1.8K        | 30-60s   | Update spec/plan/tasks         |
| `/ck:doc-review/qa`      | ~1.8-2K          | 10-20s   | Validate before commit         |
| `/ck:doc-review/main`    | ~900-1.2K + subs | Variable | Full orchestrated update       |

---

## 📖 Individual Command Guide

### `/ck:doc-review/help` - Get Started

**What it does:**

- Shows all available commands
- Explains usage patterns
- Provides decision tree
- Lists token budgets
- Includes troubleshooting

**When to use:**

- First time setup
- Forgot a command
- Need usage examples

**Example:**

```bash
/ck:doc-review/help
```

**Output:**

```
Command reference, usage patterns, decision tree, token budgets, help
```

---

### `/ck:doc-review/analyze` - What Needs Updating?

**What it does:**

- ✅ Extracts documentation principles from your project
- ✅ Analyzes current documentation structure
- ✅ Identifies recently modified files
- ✅ Assesses impact of changes
- ✅ Generates metrics and recommendations
- ✅ **Makes ZERO file changes**

**When to use:**

- "What docs need updating?"
- Before starting documentation work
- Quick health check
- Understanding project structure

**Syntax:**

```bash
/ck:doc-review/analyze
```

**Example Output:**

```
=== Documentation Analysis ===

📋 Principles Detected:
- Self-contained system (from PROJECT-SUMMARY.md)
- Token efficiency focus (from CHANGELOG.md)

📁 Structure Analysis:
- 13 markdown files found
- 4 documentation categories
- Latest changes in: src/, commands/

📊 Impact Assessment:
- Modified files: 5 files
- Recommendation: Update README, CHANGELOG, and commands/

✅ Analysis complete (0.8s)
```

**Advanced Usage:**

You can provide context for more targeted analysis:

```bash
/ck:doc-review/analyze "added new feature"
```

---

### `/ck:doc-review/core` - Update Core Files

**What it does:**

- ✅ Updates `README.md` (features, usage, installation)
- ✅ Updates `CLAUDE.md` (AI context, module documentation)
- ✅ Updates `CHANGELOG.md` (version entry)
- ✅ Uses professional templates
- ✅ Validates changes before completing

**When to use:**

- Added a new feature
- Updated existing functionality
- Need to document new API/module
- Quick documentation update
- Before sharing project publicly

**Syntax:**

```bash
/ck:doc-review/core "what changed"
```

**Examples:**

1. **New Feature:**

```bash
/ck:doc-review/core "added authentication module"
```

2. **Bug Fix:**

```bash
/ck:doc-review/core "fixed token calculation bug"
```

3. **Architecture Change:**

```bash
/ck:doc-review/core "refactored analyzer to external bash tool"
```

**Execution Example:**

```bash
$ /ck:doc-review/core "added QA validation command"

→ Analyzing project...
→ Extracting recent changes...
→ Preparing updates...

📝 Files to Update:
- README.md
- CLAUDE.md
- CHANGELOG.md

✅ Updating README.md...
✅ Updating CLAUDE.md...
✅ Updating CHANGELOG.md...

📊 Summary:
- Files updated: 3
- Sections modified: 8
- Token cost: 1.4K
- Time: 22s

✨ Core files updated successfully!
```

**What Gets Updated:**

In **README.md:**

- Features section
- Usage patterns
- Command reference
- Quick start

In **CLAUDE.md:**

- New module documentation
- API changes
- Context updates

In **CHANGELOG.md:**

- New version entry
- Added/Changed/Fixed sections

---

### `/ck:doc-review/sdd` - Update SDD Artifacts

**What it does:**

- ✅ Updates `specs/*/spec.md` (marks requirements complete)
- ✅ Updates `plan.md` (phase status)
- ✅ Updates `tasks.md` (marks tasks done)
- ✅ Updates `contracts/*.md` (design contracts, API specs)
- ✅ Validates SDD ↔ code consistency

**When to use:**

- Completed an implementation phase
- Need to sync specs with code
- Mark requirements as done
- Document architecture decisions
- Update technical contracts

**Syntax:**

```bash
/ck:doc-review/sdd "phase or feature description"
```

**Examples:**

1. **Phase Completion:**

```bash
/ck:doc-review/sdd "Phase 2 - Modularization complete"
```

2. **Feature Implementation:**

```bash
/ck:doc-review/sdd "Feature 005 - QA validation system"
```

3. **Architecture Update:**

```bash
/ck:doc-review/sdd "Refactored analyzer as external tool"
```

**Execution Example:**

```bash
$ /ck:doc-review/sdd "Modular command architecture"

→ Analyzing specification structure...
→ Identifying completed requirements...
→ Mapping code to specifications...

📋 Requirements Status:
- FR-001: ✅ Modular commands
- FR-002: ✅ External analyzer
- FR-003: ✅ Pattern configuration
- FR-004: ✅ QA validation

📊 Updates:
- spec.md: 4 requirements marked complete
- plan.md: Phase status updated
- tasks.md: 12 tasks marked done
- contracts/api.md: Updated

✅ SDD artifacts synchronized (38s)
```

**SDD Consistency Checks:**

- Requirements → Implementation alignment
- Plan → Tasks alignment
- Contracts → Code alignment
- Traceability validation

---

### `/ck:doc-review/qa` - Quality Validation

**What it does:**

- ✅ Validates all markdown links (finds broken links)
- ✅ Checks file:line references (e.g., `src/file.py:45`)
- ✅ Verifies terminology consistency
- ✅ Validates version numbers
- ✅ Checks SDD requirement traceability
- ✅ Validates code examples (syntax)
- ✅ Checks completeness (required sections)
- ✅ **Generates quality score (0-100)**

**When to use:**

- Before committing documentation changes
- After major documentation updates
- Find and fix broken links
- Ensure documentation quality
- Before releasing to GitHub

**Syntax:**

```bash
/ck:doc-review/qa
```

**Example Output:**

```bash
$ /ck:doc-review/qa

=== 📊 Documentation Quality Validation ===

🔗 Link Validation (20 points):
  - Valid links: 156 ✅
  - Broken links: 2 ❌
    • README.md:107 → examples/advanced-workflows.md (missing)
    • docs/CUSTOMIZATION.md:45 → ../config/custom.json (wrong path)
  - Score: 18/20

📄 Cross-Reference Validation (15 points):
  - File references checked: 23
  - Valid: 21 ✅
  - Invalid: 2 ⚠️
  - Score: 13/15

🔤 Terminology Consistency (15 points):
  - Style guide issues: 1
    • Inconsistent capitalization in 3 places
  - Score: 14/15

📦 Version Consistency (15 points):
  - README: v1.0.0 ✅
  - CHANGELOG: v1.0.0 ✅
  - package.json: 1.0.0 ✅
  - Score: 15/15

🗂️ SDD Consistency (15 points):
  - Specs found: 3
  - Requirements traced: 45
  - Untraceable: 1
  - Score: 14/15

💻 Code Examples (10 points):
  - Examples found: 8
  - Valid syntax: 7
  - Issues: 1 (bash example at line 234)
  - Score: 9/10

✅ Completeness (10 points):
  - Required sections found
  - Missing: None
  - Score: 10/10

═══════════════════════════════════════════
🎯 OVERALL QUALITY SCORE: 93/100 ✅
═══════════════════════════════════════════

📋 Recommendations:
1. Fix broken link in README.md:107
2. Update path reference in docs/CUSTOMIZATION.md:45
3. Fix bash syntax in examples at line 234
4. Standardize terminology (3 instances)

✅ All files scanned in 12s
```

**Quality Categories:**

1. **Link Validation (20%)** - All links work
2. **Cross-References (15%)** - File:line references valid
3. **Terminology (15%)** - Consistent language
4. **Versions (15%)** - Version numbers match
5. **SDD (15%)** - Specs ↔ code aligned
6. **Examples (10%)** - Code examples valid
7. **Completeness (10%)** - Required sections present

**Scoring:**

- 90-100: Excellent documentation ✨
- 80-89: Good documentation 👍
- 70-79: Acceptable, needs minor fixes
- Below 70: Significant issues to address

---

### `/ck:doc-review/main` - Full Orchestration

**What it does:**

- ✅ Runs comprehensive analysis
- ✅ Shows analysis summary
- ✅ Asks which areas to update
- ✅ Delegates to selected sub-commands
- ✅ Aggregates results
- ✅ Shows final summary

**When to use:**

- Not sure what needs updating
- Want guided workflow
- Comprehensive documentation update
- First time using the system

**Syntax:**

```bash
/ck:doc-review/main "what changed"
```

**Interactive Example:**

```bash
$ /ck:doc-review/main "Phase 2 implementation complete"

→ Running comprehensive analysis...

=== 📊 Analysis Summary ===
[... analysis output ...]

📋 Update Options:
1. Core Files (README, CLAUDE, CHANGELOG)
2. SDD Artifacts (spec, plan, tasks)
3. Run QA Only
4. Full Update (all of above)

? Which areas to update? (select with space, confirm with enter)
  ◉ Core Files
  ◯ SDD Artifacts
  ◯ Run QA Only

→ You selected: Core Files

→ Running sub-commands...
  1. /ck:doc-review/core "Phase 2 implementation complete"
  2. /ck:doc-review/qa

=== 📊 Final Summary ===
- Files updated: 3
- Quality score: 91/100
- Total time: 35s
- Token cost: 2.2K

✨ Documentation updated successfully!
```

---

## 🎓 Usage Patterns

### Pattern 1: Quick Daily Update (Most Common)

**Scenario:** Added new feature, need docs

```bash
# Step 1: Quick update
/ck:doc-review/core "added user authentication"

# Done! (20s, 1.2K tokens)
```

**Files updated:** README, CLAUDE, CHANGELOG
**Best for:** Daily development workflow

---

### Pattern 2: Analysis First (Recommended for New Users)

**Scenario:** Not sure what needs updating

```bash
# Step 1: Analyze
/ck:doc-review/analyze

# Step 2: Read recommendations
# Step 3: Update based on findings
/ck:doc-review/core "your feature"

# Total: 21s, 1.8K tokens
```

**Best for:** Learning the system, understanding project structure

---

### Pattern 3: Full Documentation Overhaul

**Scenario:** Completed major implementation phase

```bash
# One command with guided workflow
/ck:doc-review/main "Phase 2 complete"

# Select all update options
# All docs updated automatically

# Total: 60-90s, 3-4K tokens
```

**Best for:** Phase completions, major releases

---

### Pattern 4: QA Before Commit (Best Practice)

**Scenario:** About to git commit documentation

```bash
# Step 1: Check quality
/ck:doc-review/qa

# Step 2: Fix any issues found
# (manually edit or run other commands)

# Step 3: Re-run QA
/ck:doc-review/qa

# Step 4: Commit when score >= 85
git commit -m "docs: updated for feature X"
```

**Best for:** Quality assurance, preventing broken links

---

### Pattern 5: SDD Batching (Efficient)

**Scenario:** Completed multiple features in a phase

```bash
# Don't update SDD after every task
# Wait until phase is complete

# Update all at once
/ck:doc-review/sdd "Phase 3 complete"

# More efficient, better overview
```

**Best for:** Large features, phases, architecture changes

---

## 🎯 Decision Tree

```
Start
  │
  ├─ Need help?
  │  └─ /ck:doc-review/help
  │
  ├─ Want to see what needs updating?
  │  └─ /ck:doc-review/analyze
  │
  ├─ Added new feature?
  │  └─ /ck:doc-review/core "feature"
  │
  ├─ Completed implementation phase?
  │  └─ /ck:doc-review/sdd "phase"
  │
  ├─ About to commit docs?
  │  └─ /ck:doc-review/qa
  │
  ├─ Not sure what to do?
  │  └─ /ck:doc-review/main "description"
  │
  └─ Want comprehensive update?
     └─ /ck:doc-review/main → Select "Full Update"
```

---

## 💡 Tips & Best Practices

### 1. Run Analysis First

```bash
# New to a project?
/ck:doc-review/analyze

# Understand structure before updating
```

### 2. Use Core for Daily Work

```bash
# Most common use case
/ck:doc-review/core "what you added"

# Fast, efficient, focused
```

### 3. Batch SDD Updates

```bash
# Don't run after every feature
# Wait until phase complete

/ck:doc-review/sdd "Phase X complete"

# More efficient
```

### 4. QA Before Commit

```bash
# Best practice
/ck:doc-review/qa

# Fix issues
# Re-run QA
# Commit when score >= 85
```

### 5. Use Meaningful Descriptions

```bash
# ✅ Good - Specific
/ck:doc-review/core "added OAuth authentication"

# ❌ Poor - Vague
/ck:doc-review/core "updates"
```

---

## 🔧 Advanced Usage

### Custom Configuration

Edit `~/.claude/commands/ck/doc-review/config/categories.json`:

```json
{
  "categories": {
    "my-category": {
      "patterns": ["## My Pattern"],
      "description": "Custom category"
    }
  }
}
```

### Extending Analyzer

Add functions to `~/.claude/commands/ck/doc-review/tools/analyzer.sh`:

```bash
analyze_custom() {
  # Your custom analysis
}
```

### Creating Custom Commands

Use the architecture described in [ARCHITECTURE.md](ARCHITECTURE.md) to create new sub-commands.

---

## 📊 Token Budget Examples

### Light Usage (10 updates/month)

```
10x /core: 12-15K tokens
2x /qa: 3.6-4K tokens
Total: ~16-19K tokens/month
```

### Medium Usage (20 updates/month)

```
15x /core: 18-22.5K tokens
4x /sdd: 6-7.2K tokens
4x /qa: 7.2-8K tokens
Total: ~31-38K tokens/month
```

### Heavy Usage (40 updates/month)

```
25x /core: 30-37.5K tokens
8x /sdd: 12-14.4K tokens
8x /qa: 14.4-16K tokens
4x /main: 12-16K tokens
Total: ~69-84K tokens/month
```

---

## ❓ FAQ

**Q: How often should I run QA?**
A: Before every commit, or after major updates. Aim for score >= 85.

**Q: Should I use /main or /core?**
A: Use /core for daily work (faster). Use /main when unsure or for big updates.

**Q: Can I customize patterns?**
A: Yes! Edit `config/categories.json` to match your documentation style.

**Q: What if QA finds broken links?**
A: Fix them, then re-run QA. All files are mentioned in the output.

**Q: How do I add a new command?**
A: See [ARCHITECTURE.md](ARCHITECTURE.md) for extension points.

**Q: Can I run commands outside Claude Code?**
A: These are Claude Code commands. They require Claude Code environment.

---

**Usage Guide Complete**

For system design, see [ARCHITECTURE.md](ARCHITECTURE.md)
For customization, see [CUSTOMIZATION.md](CUSTOMIZATION.md)
