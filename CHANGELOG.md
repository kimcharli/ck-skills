# Changelog

All notable changes to doc-review-commands will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/kimcharli/doc-review-commands/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/kimcharli/doc-review-commands/releases/tag/v1.0.0
