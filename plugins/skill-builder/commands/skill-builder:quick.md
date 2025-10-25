---
description: Quick skill scaffolding - generate skill structure with defaults
allowed-tools: Bash(mkdir:*,cp:*), Write(*), Glob(*)
---

# Quick Skill Builder

Rapid skill generation using default configuration and templates.

---

## ⚡ Task

**Quick create skill:** $ARGUMENTS

**No questions asked - uses smart defaults**

---

## Execution

### Step 1: Parse Input

Extract skill details from $ARGUMENTS:
- Detect skill type from keywords
- Extract skill name
- Infer features from context

Example: "code formatter for python and javascript"
- Type: Transformation
- Name: code-formatter
- Languages: Python, JavaScript

### Step 2: Generate Structure

Create directory structure:
```
skills/[skill-name]/
├── commands/
│   ├── [skill-name].md
│   ├── [skill-name]:quick.md
│   └── [skill-name]:validate.md
├── tools/
│   ├── executor.sh
│   ├── validator.sh
│   └── cache.sh
├── tests/
│   └── test-basic.sh
└── docs/
    ├── README.md
    └── GUIDE.md
```

### Step 3: Generate Files

Generate from cached templates:
- ✅ Command files (with proper frontmatter)
- ✅ Bash scripts (executable, ready to customize)
- ✅ Documentation (formatted, complete)
- ✅ Test file (functional, passes)

All files generated in < 5 seconds using bash templates.

### Step 4: Output Location

Show generated skill location:

```
✅ Skill Created: ./skills/[skill-name]/

Token cost: 400-600
Time: < 30 seconds
Ready to use and customize
```

---

## Smart Defaults

Automatically configured:

| Setting | Default |
|---------|---------|
| Cache TTL | 3600 (1 hour) |
| Quick mode | Enabled |
| Validation | Enabled |
| Tests | Basic suite included |
| Documentation | Complete (README + GUIDE) |
| Caching | 20-30% savings built-in |
| Error handling | Comprehensive |

---

## Next Steps

```bash
# Edit executor.sh with your logic
nano skills/[skill-name]/tools/executor.sh

# Run test suite
bash skills/[skill-name]/tests/test-basic.sh

# Test the skill
/ck:[skill-name] "test input"
```

---

## Examples

```bash
# Create code formatter
/ck:skill-builder:quick "code formatter"
→ Creates: skills/code-formatter/

# Create document converter
/ck:skill-builder:quick "markdown to html converter"
→ Creates: skills/markdown-to-html/

# Create validator
/ck:skill-builder:quick "json schema validator"
→ Creates: skills/json-schema-validator/
```

---

## Token Cost

- **Time:** < 30 seconds
- **Tokens:** 400-600 (first skill, 100-200 for cached templates)
- **Speed:** ~5 seconds file generation
- **Ready:** Yes, customize immediately

---

## Features

✨ **Fast** - Complete in 30 seconds
✨ **Smart** - Detects skill type and name
✨ **Ready** - All files generated and functional
✨ **Cacheable** - Uses template cache for speed
