# skill-builder

Creates new production-ready ck-skills plugins in minutes. Generates all
files — commands, tools, tests, docs, manifest — ready to use without boilerplate.

---

## Installation

For marketplace setup and general install instructions, see the
[ck-skills README](../../README.md).

**Quick install:**

```bash
# Claude Code
claude plugin install skill-builder@ck-skills

# Copilot CLI
copilot plugin install skill-builder@ck-skills

# Manual
cd plugins/skill-builder && ./install.sh
```

---

## Usage

```bash
# Interactive — guided creation with full options
/ck:skill-builder "describe your new skill"

# Quick — scaffold with sensible defaults
/ck:skill-builder:quick "my-new-skill"
```

---

## What Gets Generated

Each new skill includes:

- `commands/` — main command, quick mode, validation sub-command
- `tools/` — executor and validator bash scripts
- `tests/` — basic and validation test suite
- `docs/` — README and usage guide
- `manifest.json` — Claude Code manifest
- `plugin.json` — Copilot CLI manifest
- `install.sh` / `uninstall.sh`

Complete and ready to register in `marketplace.json`.

---

## After Generation

1. Review generated files in `plugins/<your-skill>/`
2. Fill in the placeholder logic in `tools/`
3. Add to `.claude-plugin/marketplace.json`
4. Test with `./tests/test-install.sh`
5. Commit and push to ck-skills

See `docs/PLUGIN-DEPLOYMENT-GUIDE.md` for the full deployment workflow.

---

## Uninstall

```bash
claude plugin uninstall skill-builder   # Claude Code
copilot plugin uninstall skill-builder  # Copilot CLI
```

---

## Docs

- [Skill Creation Framework](docs/SKILL-CREATION-FRAMEWORK.md)
- [Skill Creation Example](docs/SKILL-CREATION-EXAMPLE.md)
- [Plugin Deployment Guide](docs/PLUGIN-DEPLOYMENT-GUIDE.md)

---

## Related

- [sdd-project-init](../sdd-project-init/README.md) — bootstrap new SDD projects
- [doc-review-commands](../doc-review-commands/README.md) — keep docs in sync
- [ck-skills](../../README.md) — full marketplace README
