# Troubleshooting Guide

Common install and runtime failures and how to fix them.

---

## Install Failures

### "Plugin not found in marketplace"
```
✘ Failed to install plugin "X@ck-skills": Plugin "X" not found in marketplace "ck-skills"
```
**Cause:** Stale marketplace cache — plugin was added after the cache was populated.  
**Fix:**
```bash
rm -rf ~/.claude/plugins/cache/ck-skills
claude plugin marketplace add github:kimcharli/ck-skills
claude plugin install X@ck-skills
```

---

### "Invalid manifest file — skills: Invalid input"
```
✘ Plugin has an invalid manifest file at .../plugin.json. Validation errors: skills: Invalid input
```
**Cause:** `plugin.json` contains Copilot CLI-specific fields (`skills`, `agents`,
`hooks`) that Claude Code's validator does not recognize.  
**Fix:** Remove those fields from `plugin.json`. Only keep: `name`, `description`,
`version`, `author`, `license`, `keywords`. Claude Code uses `manifest.json`
for all installation logic.

---

## Adding a New Plugin Checklist

After adding a plugin and pushing to GitHub:

1. `rm -rf ~/.claude/plugins/cache/ck-skills` — clear stale cache
2. `claude plugin marketplace add github:kimcharli/ck-skills` — re-register
3. `claude plugin install <name>@ck-skills` — install
4. Verify `plugin.json` has no Copilot-specific path fields
5. Test `copilot plugin install <name>@ck-skills` as well
