# Sharing Global Agent Rules Across Claude Code and Gemini CLI

Keep your personal, cross-repo rules in **one canonical file**. Make `~/.claude/CLAUDE.md` and `~/.gemini/GEMINI.md` thin wrappers that import it and add only tool-specific lines. This replaces two drifting copies with one source of truth.

## Layout

```text
~/.agents/AGENTS.md        # canonical personal rules (tool-neutral)
~/.claude/CLAUDE.md        # imports canonical + Claude-only rules
~/.gemini/GEMINI.md        # imports canonical + Gemini-only rules
```

Keep the canonical file **outside** `~/.claude` and `~/.gemini`. One reported Claude Code import bug only cleared up after the imported files were moved out of `~/.claude` ([issue #8765](https://github.com/anthropics/claude-code/issues/8765)). A neutral location also avoids implying the file belongs to one tool.

To version-control it, keep the real file in `ck-skills` (`plugins/ck/skills/agents-md/templates/global-AGENTS.md`, which merges [Ponytail](https://github.com/dietrichgebert/ponytail/blob/main/AGENTS.md)'s lazy-senior-dev discipline with global safety, verification, git, and communication rules) and symlink `~/.agents/AGENTS.md` to it:

```sh
mkdir -p ~/.agents
ln -sf ~/Projects/ck-skills/plugins/ck/skills/agents-md/templates/global-AGENTS.md ~/.agents/AGENTS.md
```

## Wrappers

```markdown
<!-- ~/.claude/CLAUDE.md -->
@~/.agents/AGENTS.md

## Claude-specific
- (hooks, subagent conventions, anything only Claude Code understands)
```

```markdown
<!-- ~/.gemini/GEMINI.md -->
@/Users/<you>/.agents/AGENTS.md

## Gemini-specific
- (anything only Gemini CLI understands)
```

Gemini uses an **absolute path** on purpose: its import processor expands relative and absolute paths, not `~` or `$HOME` ([Memory Import Processor](https://geminicli.com/docs/reference/memport)). Because Gemini also restricts `@` imports to allowed directories, `~/.agents/` may be blocked as outside `~/.gemini/`. If so, symlink `~/.gemini/AGENTS.md -> ~/.agents/AGENTS.md` and import `@./AGENTS.md` in `~/.gemini/GEMINI.md`.

## Verify after setup

| Tool | Command | Expect |
| -- | -- | -- |
| Claude Code | `/memory` or `/context` | `~/.agents/AGENTS.md` listed among memory files |
| Gemini CLI | `/memory show` (after `/memory reload`) | The canonical rules appear in the concatenated memory |

If an import doesn't load, fall back to a symlink for that tool (below) rather than copying the content.

## Alternatives

| Option | How | Trade-off |
| -- | -- | -- |
| Import wrapper (recommended) | As above | Keeps room for tool-specific rules; depends on import support |
| Symlink | `ln -s ~/.agents/AGENTS.md ~/.claude/CLAUDE.md` (same for Gemini) | Simplest and works without imports; no place for tool-specific rules |
| Gemini `context.fileName` | `"context": {"fileName": ["AGENTS.md", "GEMINI.md"]}` in `~/.gemini/settings.json` | Good for repos; changes the filename inside `~/.gemini/`, not the directory ([GEMINI.md docs](https://geminicli.com/docs/cli/gemini-md)) |

## Writing the canonical file

- **Tool-neutral wording:** "run the tests before calling it done", not a tool's slash command or a specific tool name.
- **Personal only:** your preferences (UV for Python, commit style, ask before destructive git ops). Team standards go in the repo, per the companion guide.
- **Short:** it loads on every turn in every repo, so every line costs context everywhere.

## Copilot

GitHub Copilot CLI reads global instructions from `~/.copilot/copilot-instructions.md` and does not expand `@path` imports. Symlink it to the canonical file rather than maintaining a third copy by hand:

```sh
ln -s ~/.agents/AGENTS.md ~/.copilot/copilot-instructions.md
```

## Relation to ck-skills

`~/.agents/AGENTS.md` is the **personal** half of the constitution (canonical baseline shipped in `plugins/ck/skills/agents-md/templates/global-AGENTS.md`). Team-wide rules that collaborators and CI need stay committed in the repo, for example as a constitution file referenced from each repo's `AGENTS.md`.
