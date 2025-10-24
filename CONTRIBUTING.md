# Contributing to Doc Review Commands

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## 🎯 Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest features or improvements
- 📝 Improve documentation
- 🔧 Submit pull requests
- ⭐ Star the repository

## 🐛 Reporting Bugs

**Before submitting a bug report:**
1. Check existing [issues](https://github.com/YOUR_USERNAME/doc-review-commands/issues)
2. Verify you're using the latest version
3. Test with the analyzer tool: `tools/analyzer.sh help`

**Bug report should include:**
- Description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment (OS, Claude Code version)
- Relevant command output or logs

## 💡 Feature Requests

We welcome feature suggestions! Please:
1. Check [existing feature requests](https://github.com/YOUR_USERNAME/doc-review-commands/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)
2. Describe the use case clearly
3. Explain how it fits the project's goals
4. Consider token efficiency and performance impact

## 🔧 Development Setup

### Prerequisites
- Claude Code installed
- Bash shell
- Git

### Setup

```bash
# Fork and clone
git clone https://github.com/YOUR_USERNAME/doc-review-commands.git
cd doc-review-commands

# Install for testing
./install.sh

# Make changes
# ... edit files ...

# Test your changes
/ck:doc-review/help
/ck:doc-review/analyze

# Run tests
./tests/test-commands.sh
```

## 📝 Code Style

### Markdown Files (Commands)
- Use consistent heading levels
- Include clear descriptions
- Add examples where helpful
- Keep line length reasonable (< 120 chars)
- Use code blocks with language tags

### Bash Scripts
- Use shellcheck for linting
- Add comments for complex logic
- Handle errors gracefully (`set -e`)
- Use meaningful variable names
- Include help/usage information

### Configuration Files (JSON)
- Use 2-space indentation
- Include descriptive field names
- Add comments via `_comment` fields if needed

## 🧪 Testing

Before submitting a PR:

```bash
# Test installation
./tests/test-install.sh

# Test commands manually
/ck:doc-review/analyze
/ck:doc-review/core "test feature"
/ck:doc-review/qa

# Test analyzer tool
tools/analyzer.sh all
```

## 📤 Pull Request Process

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow code style guidelines
   - Add tests if applicable
   - Update documentation

4. **Commit with clear messages**
   ```bash
   git commit -m "feat: add diagram generation command"
   git commit -m "fix: correct token path in analyzer"
   git commit -m "docs: update installation instructions"
   ```

   Use conventional commits:
   - `feat:` - New feature
   - `fix:` - Bug fix
   - `docs:` - Documentation only
   - `style:` - Code style (formatting)
   - `refactor:` - Code restructuring
   - `test:` - Add/update tests
   - `chore:` - Maintenance tasks

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Clear title and description
   - Reference related issues (#123)
   - Explain the change and why
   - Include screenshots/examples if relevant

## 🔍 Review Process

1. **Automated Checks**: Basic tests run automatically
2. **Code Review**: Maintainer reviews code quality
3. **Testing**: Manual testing by maintainers
4. **Feedback**: Address any requested changes
5. **Merge**: Once approved, PR is merged

## 📋 Checklist for PRs

- [ ] Code follows project style
- [ ] Changes tested locally
- [ ] Documentation updated (if needed)
- [ ] CHANGELOG.md updated (for significant changes)
- [ ] Commit messages follow conventions
- [ ] No unnecessary files committed

## 🌟 Recognition

Contributors will be:
- Listed in README.md
- Credited in release notes
- Thanked in CHANGELOG.md

## 📞 Getting Help

- 💬 [Discussions](https://github.com/YOUR_USERNAME/doc-review-commands/discussions) - Ask questions
- 🐛 [Issues](https://github.com/YOUR_USERNAME/doc-review-commands/issues) - Report bugs
- 📧 Contact maintainers (see README)

## 📜 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Maintain professional communication

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to Doc Review Commands!** 🎉
