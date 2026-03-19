______________________________________________________________________

## description: Build production-ready Claude Code skills efficiently and quickly allowed-tools: Read(*), Write(*), Edit(*), Bash(mkdir:*,cp:*,chmod:*), Glob(*), AskUserQuestion(*)

# Skill Builder

Interactive skill creation system. Build production-ready Claude Code skills in minutes.

______________________________________________________________________

## 🎯 Task

**Create a new skill:** $ARGUMENTS

______________________________________________________________________

## Phase 1: Gather Requirements

Understanding what skill to build...

Ask user:

**Header:** "Skill Basics"
**Question:** "What type of skill do you want to create?"
**MultiSelect:** false
**Options:**

- **Transformation** - Convert data from one format to another (Markdown→HTML, JSON→YAML)
- **Analysis** - Analyze data and generate insights (code review, document analysis)
- **Generator** - Create new content (code templates, documentation, configs)
- **Validation** - Check and validate content (syntax, format, consistency)
- **Orchestration** - Coordinate multiple operations (multi-step workflows)

Based on selection, determine template to use.

______________________________________________________________________

## Phase 2: Skill Details

Collect skill information:

**Ask:**

1. **Skill Name** (kebab-case, e.g., "code-formatter")

   - Validate: lowercase, hyphens only, no spaces
   - Suggest: based on description

1. **Description** (one sentence)

   - Example: "Format code in Python, JavaScript, Go"
   - Validate: < 100 chars

1. **Key Features** (comma-separated)

   - Examples: "Auto-detect language, Fast formatting, Syntax validation"
   - Validate: 2-5 features

1. **Primary Language Support**

   - Choose: Python, JavaScript, Go, Rust, Java, Multi-language, Other

______________________________________________________________________

## Phase 3: Generate Skill Structure

1. ✅ Create directory structure

   ```
   skills/[skill-name]/
   ├── commands/
   │   ├── [skill-name].md
   │   ├── [skill-name]:quick.md
   │   └── [skill-name]:validate.md
   ├── tools/
   │   ├── executor.sh
   │   └── validator.sh
   ├── templates/
   ├── tests/
   │   └── test-basic.sh
   └── docs/
       ├── README.md
       └── GUIDE.md
   ```

1. ✅ Generate command files from templates

   - Main command with boilerplate
   - Quick mode for fast execution
   - Validation sub-command

1. ✅ Generate bash scripts

   - Executor with placeholder functions
   - Validator with basic checks
   - Cache management functions

1. ✅ Generate documentation

   - README with quick start
   - GUIDE with complete documentation
   - Example usage

______________________________________________________________________

## Phase 4: Add Optimizations

Automatically included:

✅ **Caching Layer**

- TTL-based result caching (1 hour default)
- Cache management commands
- 20-30% token savings on repeat operations

✅ **Quick Mode**

- Fast path for simple/known cases
- Skips analysis phase
- 50-70% token savings

✅ **Validation**

- Input validation
- Output validation
- Error handling

✅ **Tests**

- Basic functionality test
- Cache functionality test
- Validation test

______________________________________________________________________

## Phase 5: Review & Confirm

Show generated structure:

```
Created: skills/[skill-name]/
├── commands/
│   ├── [skill-name].md (350 lines)
│   ├── [skill-name]:quick.md (180 lines)
│   └── [skill-name]:validate.md (120 lines)
├── tools/
│   ├── executor.sh (150 lines)
│   └── validator.sh (80 lines)
├── templates/
├── tests/
│   └── test-basic.sh (60 lines)
└── docs/
    ├── README.md (80 lines)
    └── GUIDE.md (200 lines)

Total: ~1,220 lines of generated code
Setup time: < 5 minutes
Ready to customize
```

Ask for confirmation:

- Modify anything?
- Review specific files?
- Generate additional templates?

**Note:** To make this skill discoverable in a marketplace:

1. Add entry to marketplace `.claude-plugin/marketplace.json` (see docs/README.md)
1. Commit and push to GitHub remote
1. Update marketplace cache: `claude plugin marketplace update your-marketplace`
1. Install from marketplace: `claude plugin install [skill-name]@your-marketplace`

______________________________________________________________________

## Phase 6: Generate & Write Files

Create all files:

1. Command files (with proper YAML frontmatter)
1. Bash scripts (executable, with error handling)
1. Documentation files (formatted markdown)
1. Test file (functional tests)
1. Git-ready structure (no .git in generated skill)

______________________________________________________________________

## Phase 7: Final Steps

Show completion:

```
✅ Skill Created Successfully!

Location: ./skills/[skill-name]/

Next Steps:
1. Customize executor.sh with your logic
2. Update validator.sh with validation rules
3. Add custom templates if needed
4. Run: bash tools/executor.sh "test input"
5. Run tests: bash tests/test-basic.sh

Documentation:
- Quick start: docs/README.md
- Full guide: docs/GUIDE.md
- Framework: docs/SKILL-CREATION-FRAMEWORK.md
- Example: docs/SKILL-CREATION-EXAMPLE.md

Use the skill:
- /ck:[skill-name] "your input"
- /ck:[skill-name]:quick "simple input"
- /ck:[skill-name]:validate "check output"
```

______________________________________________________________________

## Features

✨ **Fully Generated**

- All files created and ready to use
- No manual file creation needed
- Proper directory structure

✨ **Production Ready**

- Includes error handling
- Built-in caching layer
- Validation framework included
- Test suite included

✨ **Optimized**

- Quick mode for fast execution
- Bash scripts for mechanical tasks
- Caching for 20-30% savings
- Lightweight framework < 2K tokens typical

✨ **Well Documented**

- README with quick start
- GUIDE with full documentation
- Framework reference included
- Example code included

______________________________________________________________________

## Sub-Commands

```bash
/ck:skill-builder              # Interactive creation (this command)
/ck:skill-builder:quick        # Quick scaffolding with defaults
/ck:skill-builder:templates    # Browse available templates
/ck:skill-builder:validate     # Check existing skill
/ck:skill-builder:help         # Help and examples
```

______________________________________________________________________

## Example Usage

```bash
# Interactive creation
/ck:skill-builder "code formatter"

# Quick creation with defaults
/ck:skill-builder:quick "my-tool"

# List available templates
/ck:skill-builder:templates

# Validate generated skill
/ck:skill-builder:validate "skills/my-skill"
```

______________________________________________________________________

## Token Cost

- **First skill:** 1.5-2K tokens (interactive guidance)
- **Subsequent skills:** 400-600 tokens (cached templates, quick mode)
- **Validation:** < 200 tokens (bash-based)

30-40% faster with each skill created due to caching.

______________________________________________________________________

## What You Get

Each generated skill includes:

✅ 3 command files (main + quick + validate)
✅ 2 bash scripts (executor + validator)
✅ 1 test suite (basic functionality tests)
✅ 2 docs (README + GUIDE)
✅ Caching layer built-in
✅ Error handling built-in
✅ Ready to customize and deploy
