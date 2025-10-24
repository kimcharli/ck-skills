# Installation Guide

Complete installation instructions for Doc Review Commands - Multiple methods available.

---

## 📋 Overview

Doc Review Commands can be installed using:

1. **Plugin Command** (Easiest) - `/plugin install` in Claude Code
2. **Automatic Installation** (Recommended) - One command with install.sh
3. **Manual Installation** - Step-by-step file copying
4. **From Backup** - Restore from backup
5. **Claude Skills Registry** - Via Skill marketplace (future)

---

## ✅ Prerequisites

Before installation, ensure you have:

- ✅ **Claude Code** installed and working
- ✅ **Bash** 4.0+ (check with `bash --version`)
- ✅ **Git** (optional but recommended)
- ✅ **Permissions** to write to `~/.claude/` directory
- ✅ **Space** for ~50 KB of files

**Check Prerequisites:**

```bash
# Verify Claude Code is set up
ls -la ~/.claude/

# Check Bash version
bash --version

# Check Git (optional)
git --version
```

---

## 🚀 Method 1: Plugin Command Installation (Easiest)

### Using `/plugin` Command in Claude Code

If Doc Review Commands is registered in the Claude Skills marketplace, you can install directly within Claude Code:

```bash
# In Claude Code terminal or chat
/plugin install doc-review-commands
```

**What happens:**
- ✅ Automatically downloads the skill from marketplace
- ✅ Installs to correct Claude Code directory
- ✅ Makes all commands available immediately
- ✅ Automatic updates when new versions released

### Restart Claude Code

After installation, restart Claude Code to activate the commands:

```bash
# Restart Claude Code application
# Then commands are available:
/ck:doc-review/help
```

### Verify Installation

```bash
# In Claude Code, run:
/ck:doc-review/help

# Should display comprehensive help guide
```

**Benefits:**
- Simplest installation method
- No git clone needed
- No manual setup
- Automatic updates
- Easy uninstall

**Note:** This method becomes available after Doc Review Commands is published to the Claude Skills marketplace.

---

## 🚀 Method 2: Automatic Installation (Recommended)

### Step 1: Clone Repository

```bash
# Clone the repository
git clone https://github.com/kimcharli/doc-review-commands.git
cd doc-review-commands
```

### Step 2: Run Installer

```bash
# Run the installation script
./install.sh
```

**What the installer does:**
- ✅ Creates `~/.claude/commands/ck/doc-review/` directory
- ✅ Copies all command files
- ✅ Installs configuration files
- ✅ Sets up analyzer tool
- ✅ Makes scripts executable
- ✅ Verifies installation

### Step 3: Verify Installation

```bash
# Test the installation
/ck:doc-review/help

# Should display comprehensive help guide
```

**Expected Output:**
```
📚 Documentation Review System - Help Guide
Version: Phase 3 (Modular Architecture)
Last Updated: 2025-10-24

[... full help output ...]
```

### Complete Installation Command (One-Liner)

```bash
git clone https://github.com/kimcharli/doc-review-commands.git && \
cd doc-review-commands && \
./install.sh && \
/ck:doc-review/help
```

---

## 🔧 Method 2: Manual Installation

If automatic installation doesn't work or you prefer manual setup:

### Step 1: Create Directory Structure

```bash
# Create the installation directory
mkdir -p ~/.claude/commands/ck/doc-review/{commands,config,tools}
```

### Step 2: Copy Files

```bash
# Clone or download the repository
git clone https://github.com/kimcharli/doc-review-commands.git
cd doc-review-commands

# Copy command files
cp commands/*.md ~/.claude/commands/ck/doc-review/commands/

# Copy configuration
cp config/categories.json ~/.claude/commands/ck/doc-review/config/

# Copy tools
cp tools/analyzer.sh ~/.claude/commands/ck/doc-review/tools/

# Make analyzer executable
chmod +x ~/.claude/commands/ck/doc-review/tools/analyzer.sh
```

### Step 3: Verify Files

```bash
# Check installation
ls -la ~/.claude/commands/ck/doc-review/

# Should show:
# - commands/ (directory with .md files)
# - config/ (directory with categories.json)
# - tools/ (directory with analyzer.sh)
```

### Step 4: Test Installation

```bash
# Test the main command
/ck:doc-review/help
```

---

## 🔄 Method 3: Update Existing Installation

If you already have Doc Review Commands installed and want to update:

### Option A: Automatic Update

```bash
# Navigate to the repository
cd path/to/doc-review-commands

# Pull latest changes
git pull origin main

# Run installer (will overwrite with latest)
./install.sh
```

### Option B: Backup and Reinstall

```bash
# Backup current installation
cp -r ~/.claude/commands/ck/doc-review ~/.claude/commands/ck/doc-review.backup

# Remove old installation
rm -rf ~/.claude/commands/ck/doc-review

# Install latest version
cd path/to/doc-review-commands
./install.sh

# Verify success
/ck:doc-review/help
```

### Option C: Selective Update

Update only specific files without full reinstall:

```bash
# Update only commands
cp commands/*.md ~/.claude/commands/ck/doc-review/commands/

# Update only configuration
cp config/categories.json ~/.claude/commands/ck/doc-review/config/

# Update only tools
cp tools/analyzer.sh ~/.claude/commands/ck/doc-review/tools/
chmod +x ~/.claude/commands/ck/doc-review/tools/analyzer.sh
```

---

## 🐛 Troubleshooting Installation

### Issue: "Permission Denied" on install.sh

```bash
# Problem: install.sh is not executable
# Solution: Make it executable

chmod +x install.sh
./install.sh
```

### Issue: "Claude directory not found"

```bash
# Problem: ~/.claude/ doesn't exist
# Solution: Create it manually

mkdir -p ~/.claude/
./install.sh

# Or set up Claude Code first
# Follow Claude Code documentation to initialize
```

### Issue: "Command not found: /ck:doc-review/help"

**Causes and Solutions:**

1. **Installation path issue:**
   ```bash
   # Verify installation location
   ls ~/.claude/commands/ck/doc-review/commands/help.md

   # If missing, reinstall:
   ./install.sh
   ```

2. **Claude Code not recognizing commands:**
   ```bash
   # Restart Claude Code
   # Then try again
   /ck:doc-review/help
   ```

3. **Using wrong command syntax:**
   ```bash
   # Wrong: /doc-review/help
   # Correct: /ck:doc-review/help

   # Note the /ck: namespace prefix
   ```

### Issue: "Cannot find analyzer.sh"

```bash
# Problem: Analyzer tool not found
# Solution: Ensure tool is in correct location

ls -la ~/.claude/commands/ck/doc-review/tools/analyzer.sh

# If missing:
chmod +x tools/analyzer.sh
cp tools/analyzer.sh ~/.claude/commands/ck/doc-review/tools/

# Check it's executable
file ~/.claude/commands/ck/doc-review/tools/analyzer.sh
```

### Issue: "config/categories.json not found"

```bash
# Problem: Configuration file missing
# Solution: Copy configuration

cp config/categories.json ~/.claude/commands/ck/doc-review/config/

# Verify it's valid JSON
python3 -m json.tool ~/.claude/commands/ck/doc-review/config/categories.json
```

### Issue: Commands execute but seem slow

```bash
# Problem: First run is slow (loads analyzer)
# Solution: This is normal, subsequent runs are faster

# Run analyze to cache:
/ck:doc-review/analyze

# Then core should be faster:
/ck:doc-review/core "test"
```

---

## 📍 Installation Locations

### Default Installation Path

```
~/.claude/commands/ck/doc-review/
├── commands/
│   ├── main.md
│   ├── analyze.md
│   ├── core.md
│   ├── sdd.md
│   ├── qa.md
│   └── help.md
├── config/
│   └── categories.json
└── tools/
    └── analyzer.sh
```

### Global Tools Path (Alternative)

If local tools path doesn't work, try global:

```bash
# Copy tools globally (optional)
mkdir -p ~/.claude/tools/
cp tools/analyzer.sh ~/.claude/tools/
chmod +x ~/.claude/tools/analyzer.sh
```

---

## 🔐 Security Considerations

### Safe Installation

- ✅ Script uses `set -e` (exit on error)
- ✅ No sudo required (installs to user directory)
- ✅ No external dependencies
- ✅ No network access during execution
- ✅ No telemetry or tracking

### Permissions

Installation requires write access to:
- `~/.claude/commands/ck/` (create/write)
- `~/.claude/tools/` (optional, write)

**To verify safe permissions:**

```bash
# Check installation directory permissions
ls -la ~/.claude/commands/ck/doc-review/

# Should show user ownership (your username)
# Example: drwxr-xr-x user staff
```

### Backup Before Installation

```bash
# Safe backup (before update)
cp -r ~/.claude/commands/ck/doc-review ~/.claude/commands/ck/doc-review.backup

# Install
./install.sh

# Restore if needed
rm -rf ~/.claude/commands/ck/doc-review
mv ~/.claude/commands/ck/doc-review.backup ~/.claude/commands/ck/doc-review
```

---

## ✨ Post-Installation

### First Time Setup

After installation, set up your environment:

```bash
# Step 1: Get help
/ck:doc-review/help

# Step 2: Analyze your project
cd /path/to/your/project
/ck:doc-review/analyze

# Step 3: Customize configuration (optional)
vi ~/.claude/commands/ck/doc-review/config/categories.json

# Step 4: Try first update
/ck:doc-review/core "initial setup"
```

### Create Shell Aliases (Optional)

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
# Shorter command names
alias docreview="/ck:doc-review/main"
alias docanalyze="/ck:doc-review/analyze"
alias doccore="/ck:doc-review/core"
alias docsdd="/ck:doc-review/sdd"
alias docqa="/ck:doc-review/qa"
alias dochelp="/ck:doc-review/help"

# Usage:
# doccore "feature name"
# docqa
# dochelp
```

### Add to Git Hooks (Optional)

Add documentation QA to your pre-commit hook:

```bash
# File: .git/hooks/pre-commit
#!/bin/bash

# Check if any .md files changed
if git diff --cached --name-only | grep -q '\.md$'; then
    echo "🔍 Running documentation QA..."
    /ck:doc-review/qa
fi
```

---

## 🗑️ Uninstallation

If you need to remove Doc Review Commands:

### Automatic Uninstall

```bash
# Run the uninstall script
./uninstall.sh
```

### Manual Uninstall

```bash
# Remove installation directory
rm -rf ~/.claude/commands/ck/doc-review

# Remove global tools (if installed)
rm -f ~/.claude/tools/analyzer.sh

# Remove aliases from shell config (if added)
# Edit ~/.zshrc or ~/.bashrc to remove aliases
```

### Restore from Backup

If you made a backup:

```bash
# Restore backup
mv ~/.claude/commands/ck/doc-review.backup ~/.claude/commands/ck/doc-review

# Verify
/ck:doc-review/help
```

---

## 🔄 Installation on Multiple Machines

### Copy Installation Between Machines

**On source machine:**
```bash
# Create archive
tar -czf doc-review-commands.tar.gz ~/.claude/commands/ck/doc-review/
```

**On destination machine:**
```bash
# Extract
mkdir -p ~/.claude/commands/ck/
tar -xzf doc-review-commands.tar.gz -C ~/.claude/commands/ck/

# Verify
/ck:doc-review/help
```

### Installation via SSH

**From remote machine:**
```bash
# Clone and install via SSH
ssh user@remote 'cd /tmp && \
  git clone https://github.com/kimcharli/doc-review-commands.git && \
  cd doc-review-commands && \
  ./install.sh && \
  /ck:doc-review/help'
```

---

## 📦 Installation Variants

### Minimal Installation (Commands Only)

If you only want command files without examples:

```bash
# Create minimal structure
mkdir -p ~/.claude/commands/ck/doc-review/{commands,config,tools}

# Copy only essentials
cp commands/*.md ~/.claude/commands/ck/doc-review/commands/
cp config/categories.json ~/.claude/commands/ck/doc-review/config/
cp tools/analyzer.sh ~/.claude/commands/ck/doc-review/tools/
chmod +x ~/.claude/commands/ck/doc-review/tools/analyzer.sh
```

### Full Installation (Recommended)

```bash
# Use the standard install.sh
./install.sh

# This includes everything:
# - Commands
# - Configuration
# - Tools
# - Documentation reference
```

---

## ✅ Installation Verification Checklist

After installation, verify everything is working:

- [ ] Installation completed without errors
- [ ] `/ck:doc-review/help` displays help guide
- [ ] `/ck:doc-review/analyze` runs successfully
- [ ] `/ck:doc-review/core "test"` updates documents
- [ ] `/ck:doc-review/qa` validates documentation
- [ ] No error messages in output
- [ ] Installation directory exists at `~/.claude/commands/ck/doc-review/`
- [ ] All 6 command files present
- [ ] Configuration file is valid JSON
- [ ] Analyzer tool is executable

---

## 🆘 Getting Help

If installation fails:

1. **Check Prerequisites** - Ensure Bash 4.0+ and Claude Code are installed
2. **Review Error Messages** - Read the output carefully
3. **Check File Permissions** - Ensure write access to `~/.claude/`
4. **Try Manual Installation** - If automatic fails, try method 2
5. **Consult Troubleshooting** - See section above
6. **Open an Issue** - Report on GitHub: https://github.com/kimcharli/doc-review-commands/issues

---

## 📚 Next Steps

After successful installation:

1. **Read Quick Start** - See [QUICKSTART.md](QUICKSTART.md)
2. **Review Usage Guide** - See [USAGE.md](USAGE.md)
3. **Explore Examples** - See [examples/](../examples/)
4. **Customize Configuration** - See [CUSTOMIZATION.md](CUSTOMIZATION.md)
5. **Set Up Aliases** - Add shortcuts to shell config

---

## 🎉 Installation Complete!

Your Doc Review Commands system is ready to use.

**Quick verification:**
```bash
/ck:doc-review/help
```

**Next command to try:**
```bash
/ck:doc-review/analyze
```

---

**Installation Guide Complete**

For issues or questions, see [troubleshooting section](#-troubleshooting-installation) above.
