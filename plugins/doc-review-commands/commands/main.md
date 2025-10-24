---

description: Documentation update orchestrator - analyzes and delegates to sub-commands
allowed-tools: Bash(~/.claude/commands/ck/doc-review/tools/analyzer.sh:*), Bash(~/.claude/tools/doc-analyzer.sh:*), Read(*), SlashCommand(*), AskUserQuestion(*)
---

# Documentation Update Orchestrator

## Context

- Analysis:
  !`~/.claude/commands/ck/doc-review/tools/analyzer.sh all || ~/.claude/tools/doc-analyzer.sh all`

## Task

**Update all documentation for:** $ARGUMENTS

**🎯 Smart Orchestration:** This command analyzes your changes and delegates to sub-commands.

---

## Analysis Review

Review the analysis output above to understand:

✅ **Principles:** Project documentation constraints (if any)
✅ **Structure:** Current documentation organization
✅ **Changes:** Files modified in recent commits
✅ **Impact:** Which documentation needs updating

---

## Recommended Update Plan

Based on the analysis, here's what needs updating:

**Available Sub-Commands:**

- `/ck:doc-review/quick` - Fast updates, no analysis (~400-600 tokens)
- `/ck:doc-review/analyze` - Run analysis only (no updates)
- `/ck:doc-review/core` - Update README, CLAUDE, CHANGELOG
- `/ck:doc-review/sdd` - Update SDD artifacts (spec.md, plan.md, tasks.md)
- `/ck:doc-review/qa` - Quality validation and link checking

---

## User Confirmation

Use AskUserQuestion to ask:

### Question: Which documentation should be updated?

**header:** "Update Scope"
**question:** "Which documentation areas should be updated for: $ARGUMENTS"
**multiSelect:** true
**options:**

- **label:** "Core Files"
  **description:** "README.md, CLAUDE.md, CHANGELOG.md - Quick updates (1-2 min)"

- **label:** "SDD Artifacts"
  **description:** "specs/\*/spec.md, plan.md, tasks.md - Specification updates (2-3 min)"

- **label:** "Run QA Only"
  **description:** "Link validation, consistency checks - No content changes"

- **label:** "Full Update"
  **description:** "All documentation areas - Comprehensive update (3-5 min)"

---

## Execution

Based on user selection, invoke appropriate sub-commands:

### If "Core Files" selected

```bash
/ck:doc-review/core $ARGUMENTS
```

### If "SDD Artifacts" selected

```bash
/ck:doc-review/sdd $ARGUMENTS
```

### If "Run QA Only" selected

```bash
/ck:doc-review/qa
```

### If "Full Update" selected

```bash
/ck:doc-review/core $ARGUMENTS
/ck:doc-review/sdd $ARGUMENTS
/ck:doc-review/qa
```

**⚠️ Note:** Run sub-commands sequentially, wait for each to complete before running the next.

---

## Final Summary

After all sub-commands complete, provide aggregated summary:

### 📊 Complete Documentation Update Summary

**Scope:** $ARGUMENTS

**Sub-Commands Executed:**

- [List which sub-commands ran]

**Total Updates:**

- Files modified: [aggregate count]
- Total time: [sum of execution times]

**Next Steps:**

- [ ] Review changes: `git diff`
- [ ] Commit updates: `git add . && git commit -m "docs: ..."`
- [ ] Push if ready: `git push`

---

## Benefits of Modular Approach

✅ **90% Token Reduction** - Only load what you need
✅ **Faster Execution** - Focused commands run in < 1s
✅ **Clear Responsibility** - Each command does one thing well
✅ **Reusable** - Use sub-commands independently
✅ **Composable** - Mix and match as needed
