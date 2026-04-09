# Changelog

All notable changes to doc-review-commands will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2026-04-09

### Added

- **pre-commit Integration**: Added `.pre-commit-config.yaml` with ruff, ruff-format, mdformat (GFM/frontmatter/tables/shfmt plugins), markdownlint (`--fix`), and pytest (pre-push stage).
- **CI Workflow**: Added `.github/workflows/pre-commit.yml` (dormant; `workflow_dispatch` only until activated).
- **Analysis Doc**: Added `docs/pre-commit-integration-analysis.md` comparing ruff/pre-commit options.

### Changed

- **`lint-fix.sh` Refactored**: Repurposed from a lint runner to an environment health checker; verifies uv, pre-commit, git hook installation, `.pre-commit-config.yaml` presence, and markdownlint version (≥ 0.45.0).
- **`python-lint-fix` SKILL.md**: Updated to reflect pre-commit as primary gate; lint-fix.sh described as health checker.
- **`AGENTS.md`**: Updated AI Agent Workflow section to use `uv run pre-commit install` and reference lint-fix.sh as environment verifier.
- **MD060 Policy**: Changed `.markdownlint.json` MD060 style from `aligned` to `compact`; table separators standardized to `| --- |` format.

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
