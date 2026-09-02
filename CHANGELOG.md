# Changelog

All notable changes to doc-review-commands will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [python-repo-init 1.2.0] - 2026-09-02

Backported from the conventions proven in the `46137-darden-l3-prep` project
repo, which ran this scaffold in anger and diverged in four useful ways.

### Added

- **`templates/specs/project.md`** — repo map, improvement routing, and a
  concrete escalation threshold, split out of `AGENTS.md`. Keeps the
  always-loaded file purely behavioral instead of spending its line budget on
  a directory listing.
- **`templates/specs/improvements.md`** — append-only improvement-proposal log
  with an agent-proposes / human-decides protocol: four named triggers, max
  three proposals per session, agents never change a status, and rejected
  entries stay permanently so the same proposal is not made twice.
- **`AGENTS.md` Output Discipline section** — enforceable budgets (per user
  request, not per step): edit-never-rewrite with a 30% threshold, silence
  between tool calls, no preamble, a 4-sentence prose budget that counts
  headers and bullets, a 3-line risk cap, and a fixed closing-report shape.
- **`AGENTS.md` Improvement Proposals section** — propose-never-apply, with
  acceptance explicitly not constituting authorization to apply.
- **Symlinked tool pointers, opt-in.** `check_repo_conventions.py` check 3 now
  exempts a pointer that is a symlink to `AGENTS.md` from the thinness and
  must-reference rules and validates its link target instead. Previously such
  a repo passed locally (where `git show :path` yields the link target) but
  failed in CI (where the checkout dereferences to a 90-line file) — a silent
  local/CI split. `generate.py` now preserves symlinks in `templates/` rather
  than dereferencing them into duplicate files.

### Fixed

- **Sibling-manifest provenance escape hatch now actually works.**
  `specs/workflow.md` Section 5a has always documented `<file>.manifest.yaml`
  as the provenance carrier for formats that cannot hold an inline `#` comment
  (binary, or a CSV whose first line a strict importer reads as the column
  header), but `check_repo_conventions.py` never implemented it and rejected
  those files unconditionally. Spec/code drift, closed.

### Changed

- `AGENTS_MD_MAX_LINES` 70 → 90. The added content is behavioral; the repo-map
  content that used to consume the budget moved to `specs/project.md`.

## [Unreleased] - 2026-07-10

### Changed

- **BREAKING: Consolidated 5 flat-form plugins into a single `ck` umbrella plugin**:
  `python-lint-fix`, `sdd-project-init`, `doc-review-commands`, `sdd-git-commit`, and
  `skill-builder` moved from independent top-level plugins (`plugins/<name>/`) into
  `plugins/ck/skills/<name>/`, matching the nested `skills/<name>/SKILL.md` layout
  Anthropic's plugin docs recommend for plugins that bundle more than one skill.
  `python-repo-init` is unaffected and remains a standalone plugin.
- **`marketplace.json`**: removed the 5 old plugin entries; added a single `ck` entry
  (`source: ./plugins/ck`). Existing installs of the 5 individual plugin names will no
  longer resolve — reinstall via `claude plugin install ck@ck-skills` (or the Copilot
  CLI equivalent).
- Dropped each moved skill's per-skill `install.sh`/`uninstall.sh`/`.claude-plugin/`
  (superseded by the shared `plugins/ck/.claude-plugin/plugin.json`); manual install is
  now a plain copy into `~/.claude/skills/<name>`.
- Updated root `README.md` (Available Skills table, install instructions for all three
  CLIs, repository structure diagram, uninstall instructions, contributing guide) to
  reflect the new layout.

### Added

- **python-repo-init Plugin (1.0.0)**: New plugin that scaffolds a Python repo pre-wired with spec-first, agent-agnostic workflow governance (AGENTS.md + thin per-tool pointers, `specs/` session handoff via NEXT.md, stdlib-only pre-commit convention guard + CI, uv/mise tooling with adjustable `--python` version, lifecycle-staged `data/` layout). Registered in marketplace; skill lives at `skills/python-repo-init/` per Claude Code plugin layout; `/python-repo-init` command included. Author defaults to `git config user.name`; generator is cwd-independent and reports `--force` overwrites.

## [Unreleased] - 2026-04-09

### Added

- **pre-commit Integration**: Added `.pre-commit-config.yaml` with ruff, ruff-format, mdformat (GFM/frontmatter/tables/shfmt plugins), markdownlint (`--fix`), and pytest (pre-push stage).
- **CI Workflow**: Added `.github/workflows/pre-commit.yml` (dormant; `workflow_dispatch` only until activated).
- **Analysis Doc**: Added `docs/pre-commit-integration-analysis.md` comparing ruff/pre-commit options.

### Changed

- **`lint-fix.sh` Refactored**: Repurposed from a lint runner to an environment health checker; verifies uv, pre-commit, git hook installation, `.pre-commit-config.yaml` presence, and markdownlint version (≥ 0.45.0).
- **`python-lint-fix` SKILL.md**: Updated to reflect pre-commit as primary gate; lint-fix.sh described as health checker.
- **`AGENTS.md`**: Updated AI Agent Workflow section to use `uv run pre-commit install` and reference lint-fix.sh as environment verifier.
- **MD060 Policy**: Finalized `.markdownlint.json` MD060 style as `aligned` to match `mdformat-tables` behavior and avoid recurring table-style conflicts.
- **Marketplace/Plugin Versioning**: Bumped marketplace package version to `1.0.1` and `python-lint-fix` plugin version metadata to `1.1.0`.

### Fixed

- **MD060 Errors**: Fixed table separator rows across `docs/pre-commit-integration-analysis.md` to comply with compact style.

## [Unreleased]

### Fixed

- **Skill Metadata**: Reverted `SKILL.md` files to standard YAML frontmatter to fix Gemini CLI installation regression.

### Added

- **Dynamic Installation Paths**: Updated all `install.sh` and `uninstall.sh` scripts to automatically detect and support `~/.agents` (Gemini CLI) and `~/.claude` (Claude Code) base directories.
- **Automated Path Patching**: Implemented `perl`-based automated patching of hardcoded `~/.claude` references in `.md`, `.json`, and `SKILL.md` files during installation to match the actual installation path.
- **Generic CLI Support**: Standardized success and usage messages to be tool-agnostic, supporting a wider range of AI CLI runners.
- **Automated Validation**: Created `validate-skill.sh` to ensure `SKILL.md` files remain compliant with Gemini CLI requirements.

### Planned

- Diagram generation sub-command
- Multi-language template support
- CI/CD integration mode

## [1.0.0] - 2025-10-24

### Added

- Initial release of modular documentation system
- 6 core commands: main, analyze, core, sdd, qa, help
- External bash analyzer tool for instant analysis
- Pattern-based file categorization system
- SDD (Specification-Driven Development) support
- Quality validation with 7-category scoring
- Professional documentation templates
- Installation and uninstallation scripts
- Comprehensive documentation and examples

### Performance

- 88% token reduction vs monolithic commands
- 70% faster execution with focused sub-commands
- Sub-second analysis with external tools

### Architecture

- Modular folder structure
- Self-contained system (commands + config + tools)
- Dual tool path support (local + global)
- Progressive disclosure pattern
- Zero external dependencies (bash only)

[1.0.0]: https://github.com/kimcharli/doc-review-commands/releases/tag/v1.0.0
[unreleased]: https://github.com/kimcharli/doc-review-commands/compare/v1.0.0...HEAD
