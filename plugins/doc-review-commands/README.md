# doc-review-commands

Keeps project documentation in sync with code changes. Six focused commands
instead of one monolithic tool — 88% token reduction, 70% faster execution.

______________________________________________________________________

## Installation

For marketplace setup and general install instructions, see the
[ck-skills README](../../README.md).

**Quick install:**

```bash
# Claude Code
claude plugin install doc-review-commands@ck-skills

# Copilot CLI
copilot plugin install doc-review-commands@ck-skills

# Manual
cd plugins/doc-review-commands && ./install.sh
```

______________________________________________________________________

## Commands

| Command                  | Purpose                                        | Token Cost |
| ------------------------ | ---------------------------------------------- | ---------- |
| `/ck:doc-review/main`    | Smart orchestrator — analyzes then delegates   | ~900–1.2K  |
| `/ck:doc-review/analyze` | Analysis only, zero file changes               | ~600–800   |
| `/ck:doc-review/core`    | Update README, CHANGELOG, CLAUDE.md            | ~1.2–1.5K  |
| `/ck:doc-review/sdd`     | Update SDD artifacts (specs, tasks, contracts) | ~1.5–1.8K  |
| `/ck:doc-review/qa`      | Quality validation, 0–100 scoring              | ~1.8–2K    |
| `/ck:doc-review/help`    | Usage guide                                    | ~200       |

______________________________________________________________________

## Usage Patterns

**After adding a feature:**

```bash
/ck:doc-review/core "added feature X"
```

**After completing an SDD phase:**

```bash
/ck:doc-review/sdd "phase 2 complete"
```

**Before committing:**

```bash
/ck:doc-review/qa
```

**Full orchestrated update:**

```bash
/ck:doc-review/main "what changed"
```

______________________________________________________________________

## Customization

- Edit `config/categories.json` to customize file categorization patterns
- Modify `commands/*.md` to adjust command behavior
- Extend `tools/analyzer.sh` with custom bash analysis functions

See `docs/CUSTOMIZATION.md` for details.

______________________________________________________________________

## Uninstall

```bash
claude plugin uninstall doc-review-commands   # Claude Code
copilot plugin uninstall doc-review-commands  # Copilot CLI
./uninstall.sh                                # Manual
```

______________________________________________________________________

## Docs

- [Quick Start](docs/QUICKSTART.md)
- [Usage Guide](docs/USAGE.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Customization](docs/CUSTOMIZATION.md)

______________________________________________________________________

## Related

- [sdd-project-init](../sdd-project-init/README.md) — bootstrap new SDD projects
- [skill-builder](../skill-builder/README.md) — create new ck-skills plugins
- [ck-skills](../../README.md) — full marketplace README
