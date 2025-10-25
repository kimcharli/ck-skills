# Plugin Deployment Guide

This guide explains how to take a generated skill and deploy it as a discoverable Claude Code plugin in a marketplace.

---

## Overview

Generated skills can be deployed in two ways:

1. **Local Command** - Simple, direct use on your machine
2. **Marketplace Plugin** - Discoverable and installable across machines

---

## Quick Comparison

| Aspect | Local Command | Marketplace Plugin |
|--------|---------------|-------------------|
| Setup Time | < 1 minute | 5-10 minutes |
| Discovery | Manual sharing | Discoverable by others |
| Installation | Copy directory | `claude plugin install` |
| Updates | Manual | Automatic via marketplace |
| Scope | Single machine | Team/Community |

---

## Option 1: Local Command Deployment (Simple)

### Step 1: Create Commands Directory

```bash
mkdir -p ~/.claude/commands/ck
```

### Step 2: Copy Generated Skill

```bash
cp -r skills/my-skill ~/.claude/commands/ck/my-skill
```

### Step 3: Make Executable

```bash
chmod +x ~/.claude/commands/ck/my-skill/tools/*.sh
```

### Step 4: Use Your Skill

```bash
/ck:my-skill "your input"
/ck:my-skill:quick "simple input"
/ck:my-skill:validate "check output"
```

---

## Option 2: Marketplace Plugin Deployment (Distributed)

This makes your skill discoverable and installable via `claude plugin install`.

### Step 1: Organize as a Plugin

Create a marketplace repository structure:

```
my-marketplace/
├── .claude-plugin/
│   └── marketplace.json          # Central registry
└── plugins/
    └── my-skill/
        ├── commands/
        ├── tools/
        ├── tests/
        └── docs/
```

### Step 2: Create marketplace.json

At the root `.claude-plugin/marketplace.json`:

```json
{
  "owner": {
    "name": "your-github-username"
  },
  "name": "my-marketplace",
  "version": "1.0.0",
  "description": "Collection of Claude Code skills",
  "author": {
    "name": "your-name"
  },
  "license": "MIT",
  "homepage": "https://github.com/your-username/my-marketplace",
  "repository": {
    "type": "git",
    "url": "https://github.com/your-username/my-marketplace.git"
  },
  "plugins": [
    {
      "name": "my-skill",
      "version": "1.0.0",
      "source": "./plugins/my-skill",
      "description": "Your skill description here",
      "author": {
        "name": "your-name"
      },
      "license": "MIT",
      "homepage": "https://github.com/your-username/my-marketplace/tree/main/plugins/my-skill",
      "tags": [
        "skill",
        "automation"
      ],
      "category": "development"
    }
  ]
}
```

### Step 3: Required Files in Your Skill

Ensure your skill has:

- ✅ `commands/*.md` - Command definitions with YAML frontmatter
- ✅ `tools/*.sh` - Executable bash scripts
- ✅ `docs/README.md` - Quick start documentation
- ✅ `tests/*.sh` - Test suite

### Step 4: Configure Marketplace in Git

```bash
# Initialize git repo
git init

# Create initial commit
git add .
git commit -m "Initial marketplace with my-skill plugin"

# Add GitHub remote
git remote add origin https://github.com/your-username/my-marketplace.git

# Push to GitHub
git push -u origin main
```

### Step 5: Register Marketplace Locally

```bash
# Add marketplace source to Claude Code
claude plugin marketplace add github:your-username/my-marketplace

# Verify
claude plugin marketplace list
```

### Step 6: Update and Install

```bash
# Update marketplace cache from GitHub
claude plugin marketplace update my-marketplace

# Install your plugin
claude plugin install my-skill@my-marketplace
```

### Step 7: Verify Installation

```bash
# Check installed plugins
claude plugin list

# Use your skill
/ck:my-skill "test input"
```

---

## Key Learnings from Marketplace Integration

### 1. marketplace.json is the Central Registry

The `.claude-plugin/marketplace.json` file at the root is **the only manifest** needed for marketplace discovery.

- Individual plugins do NOT need separate manifest files
- All plugin information is defined here
- Changes must be pushed to GitHub to take effect

### 2. GitHub-Based Discovery

Marketplaces use GitHub as the source of truth.

- Local changes are NOT discoverable until pushed
- Use `git push` to publish changes
- Use `claude plugin marketplace update` to refresh cache

### 3. Plugin Entry Structure

Each plugin entry in marketplace.json requires:

```json
{
  "name": "unique-plugin-name",
  "version": "1.0.0",
  "source": "./plugins/relative/path",
  "description": "Human-readable description",
  "author": { "name": "your-name" },
  "license": "MIT",
  "homepage": "GitHub link",
  "tags": ["keyword1", "keyword2"],
  "category": "development"
}
```

### 4. Installation Flow

```
Local marketplace.json
    ↓ (contains plugin entry)
Git push to GitHub
    ↓
claude plugin marketplace update
    ↓ (refreshes cache from GitHub)
claude plugin install plugin-name@marketplace
    ↓ (discovers and installs)
```

---

## Common Issues & Solutions

### Issue: Plugin not found after update

**Solution:**
- ✅ Commit marketplace.json changes
- ✅ Push to GitHub: `git push`
- ✅ Update marketplace: `claude plugin marketplace update your-marketplace`
- ✅ Wait 10-15 seconds for cache update

### Issue: Plugin source path incorrect

**Solution:**
- Verify `"source"` is relative path from repo root: `"./plugins/my-skill"`
- Verify directory exists at that path
- Verify commands/*.md files are present

### Issue: Commands not found in installed plugin

**Solution:**
- Verify YAML frontmatter in command files
- Check file names match command names (e.g., `my-skill.md` for `/ck:my-skill`)
- Run `claude plugin validate` on your plugin directory

---

## Publishing Your Marketplace

To share with others:

1. Push your marketplace to GitHub
2. Share the repo URL: `https://github.com/your-username/my-marketplace`
3. Others add with: `claude plugin marketplace add github:your-username/my-marketplace`

---

## Version Management

Update version numbers when:

- ✅ Adding new commands or features → Minor version (1.0.0 → 1.1.0)
- ✅ Bug fixes or updates → Patch version (1.0.0 → 1.0.1)
- ✅ Major breaking changes → Major version (1.0.0 → 2.0.0)

Increment in both:
- Individual skill version in marketplace.json
- Marketplace version itself

---

## Next Steps

1. Choose deployment option (local or marketplace)
2. Follow the steps above
3. Test your skill works: `/ck:my-skill "test"`
4. Share with team if using marketplace
5. Keep docs updated in your skill's README

---

## References

- Skill Builder docs: `docs/README.md`
- Generated skill structure: See generated skills/[skill-name]/
- Framework details: `docs/SKILL-CREATION-FRAMEWORK.md`
