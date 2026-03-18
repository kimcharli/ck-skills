# Troubleshooting Guide

Common install and runtime failures and how to fix them.

---

## Install Failures

### "Plugin not found in marketplace"

```text
✘ Failed to install plugin "X@ck-skills": Plugin "X" not found in marketplace "ck-skills"
```

**Cause:** Stale marketplace cache — plugin was added after the cache was populated.
**Fix:**

```bash
claude plugin marketplace update ck-skills
claude plugin install X@ck-skills
```

---

### "Invalid manifest file — skills: Invalid input"

```text
✘ Plugin has an invalid manifest file at .../plugin.json. Validation errors: skills: Invalid input
```

**Cause:** `plugin.json` is at the plugin root alongside a `commands/` directory.
`claude plugin install` auto-injects `"skills": ["commands/"]` into root-level
`plugin.json`, and that format fails validation.
**Fix:** Move `plugin.json` into `.claude-plugin/plugin.json`. Keep only metadata
fields: `name`, `description`, `version`, `author`, `license`, `keywords`.
The `commands/` directory is auto-discovered — no `skills` field needed.

---

## Adding a New Plugin Checklist

After adding a plugin and pushing to GitHub:

1. `claude plugin marketplace update ck-skills` — refresh cache
2. `claude plugin install <name>@ck-skills` — install
3. Verify `plugin.json` is inside `.claude-plugin/` with metadata-only fields
4. Test `copilot plugin install <name>@ck-skills` as well
