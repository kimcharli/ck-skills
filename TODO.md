# TODO: Future Work & Technical Debt

## Testing Infrastructure (Priority: High)

- [ ] **Unified Test Runner:** Create a root-level script (e.g., `test-all.sh`) to run tests across all plugins.
- [ ] **Doc-Review-Commands Tests:** Implement tests for `plugins/doc-review-commands/tools/analyzer.sh` and its command structure.
- [ ] **Enhanced Skill-Builder Tests:** Expand `plugins/skill-builder/tests/test-generator.sh` to validate the content of generated skills, not just their existence.
- [ ] **BATS Integration:** Migrate bash-based tests (like `test-generator.sh` and `validate-skill.sh`) to BATS for consistent output and better failure reporting.
- [ ] **CI Integration:** Set up a GitHub Action to run all tests on pull requests.

## Plugin Improvements

- [ ] **Diagram generation sub-command** (doc-review-commands)
- [ ] **Multi-language template support** (doc-review-commands)
- [ ] **CI/CD integration mode** (doc-review-commands)
- [ ] **Interactive Interview Mode** (skill-builder)

## Documentation

- [ ] **Comprehensive API Docs:** Document the internal tool APIs for each plugin.
- [ ] **Contribution Guide:** Expand `CONTRIBUTING.md` with detailed testing requirements for new plugins.
