# ck-skills

**Collection of Production-Ready Claude Code Skills**

A modular marketplace of skills for Claude Code including doc-review-commands, skill-builder, and more. Discover, install, and customize skills to enhance your workflow.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-blue)](https://claude.ai/code)
[![GitHub: kimcharli/ck-skills](https://img.shields.io/badge/GitHub-ck--skills-black)](https://github.com/kimcharli/ck-skills)

---

## 🎯 What is This?

**ck-skills** is a marketplace of production-ready skills for Claude Code. Each skill is fully generated, tested, and documented. Use them as-is or customize for your workflow:

- ✅ **doc-review-commands** - Keep documentation in sync with code (70% faster, 88% token savings)
- ✅ **skill-builder** - Create new production-ready skills in minutes
- ✅ More skills coming soon
- ✅ Install from marketplace or use locally
- ✅ Customize templates and extend with your own logic

## 🚀 Quick Start

### Installation (Recommended Approach)

Install plugins directly through Claude Code's plugin system. This is the **official recommended approach** per [Claude Code Plugins Documentation](https://docs.claude.com/en/docs/claude-code/plugins).

```bash
# In Claude Code, run:
/plugin marketplace add github:kimcharli/ck-skills
/plugin install doc-review-commands@ck-skills
/plugin install skill-builder@ck-skills

# Then verify installation:
/ck:doc-review/help
/ck:skill-builder "your skill description"
```

See individual skill README.md files in `plugins/[skill-name]/docs/` for detailed usage.

### Uninstall

```bash
# In Claude Code, run:
/plugin uninstall doc-review-commands
/plugin uninstall skill-builder
```

Plugins are automatically removed from `~/.claude/plugins/marketplaces/ck-skills/plugins/[skill-name]/`

### Basic Usage

```bash
# Quick README/CLAUDE update
/ck:doc-review/core "added new feature X"

# Update SDD artifacts
/ck:doc-review/sdd "Phase 2 complete"

# Quality check before commit
/ck:doc-review/qa

# Full guided update
/ck:doc-review/main "what changed"
```

---

## 📋 Features

### 🎯 Modular Architecture

Six focused commands instead of one monolithic tool:

| Command    | Purpose                 | Token Cost | Time     |
| ---------- | ----------------------- | ---------- | -------- |
| `/main`    | Smart orchestrator      | ~900-1.2K  | Variable |
| `/analyze` | Analysis only           | ~600-800   | < 1s     |
| `/core`    | README/CLAUDE/CHANGELOG | ~1.2-1.5K  | 15-30s   |
| `/sdd`     | SDD artifacts           | ~1.5-1.8K  | 30-60s   |
| `/qa`      | Quality validation      | ~1.8-2K    | 10-20s   |
| `/help`    | Usage guide             | ~200       | Instant  |

### ⚡ Performance

- **88% token reduction** vs monolithic commands
- **70% faster execution** with focused sub-commands
- **External tools** for instant analysis (< 1s)

### 🛠️ Smart Features

- **Analysis Tool**: Bash-based analyzer for instant project insights
- **Progressive Disclosure**: User controls update scope
- **Pattern Config**: Customizable file categorization
- **Template System**: Professional documentation formats
- **SDD Integration**: Spec-driven development support
- **Quality Validation**: 7-category QA scoring (0-100)

### 🔧 Customizable

- Modify templates in `commands/*.md`
- Customize patterns in `config/categories.json`
- Extend analyzer with custom bash functions
- Add your own sub-commands

---

## 📚 Documentation

### Getting Started

- [Quick Start](docs/QUICKSTART.md) - Get running in 5 minutes
- [Installation](docs/INSTALLATION.md) - Complete installation guide with troubleshooting

### User Guides

- [Usage Guide](docs/USAGE.md) - Detailed command documentation
- [Architecture](docs/ARCHITECTURE.md) - System design and philosophy
- [Templates](docs/TEMPLATES.md) - Documentation templates reference
- [Customization](docs/CUSTOMIZATION.md) - How to customize for your project
- [Migration](docs/MIGRATION.md) - Migrate from older versions

### Examples

- [Basic Usage](examples/basic-usage.md) - Common workflows
- [Advanced Workflows](examples/advanced-workflows.md) - Power user patterns
- [Custom Config](examples/custom-config.json) - Example configuration

---

## 🏗️ Architecture

### Repository Structure

This is the marketplace source repository:

```
ck-skills/
├── .claude-plugin/
│   └── marketplace.json              # Central plugin registry
├── plugins/
│   ├── doc-review-commands/
│   │   ├── commands/                 # Command definitions (.md files)
│   │   ├── tools/                    # Bash executables
│   │   ├── config/                   # Configuration files
│   │   ├── docs/                     # Documentation
│   │   ├── tests/                    # Test suite
│   │   └── manifest.json             # Plugin manifest
│   └── skill-builder/
│       ├── commands/                 # Command definitions (.md files)
│       ├── tools/                    # Bash executables
│       ├── docs/                     # Documentation
│       ├── tests/                    # Test suite
│       └── templates/                # Skill templates
├── README.md
└── CHANGELOG.md
```

### Installed Plugin Structure

When installed from marketplace, plugins are placed in `~/.claude/plugins/marketplaces/ck-skills/plugins/[skill-name]/`:

```
~/.claude/plugins/marketplaces/ck-skills/plugins/doc-review-commands/
├── commands/
│   ├── main.md              # Main orchestrator
│   ├── analyze.md           # Analysis sub-command
│   ├── core.md              # Core files update
│   ├── sdd.md               # SDD artifacts update
│   ├── qa.md                # Quality validation
│   └── help.md              # Help documentation
├── config/
│   └── categories.json      # Pattern configuration
└── tools/
    └── analyzer.sh          # Analysis tool
```

### Command Flow

```
User invokes command
      ↓
Context loads (analysis via analyzer.sh)
      ↓
Command processes with focused logic
      ↓
Updates files OR returns analysis
      ↓
Structured summary returned
```

### Token Efficiency

```
Original monolithic: ~10-12K tokens per invocation
Phase 3 modular:      ~900-2K tokens per command
Savings:              88% token reduction
```

---

## 🎓 Usage Patterns

### Pattern 1: Quick Core Update (Most Common)

```bash
# Added new feature, need docs
/ck:doc-review/core "ApstraWorkModule implementation"

# Updates: README.md, CLAUDE.md, CHANGELOG.md
# Time: ~20s | Tokens: ~1.2K
```

### Pattern 2: Analysis First

```bash
# Understand what needs updating
/ck:doc-review/analyze

# Then update based on recommendations
/ck:doc-review/core "feature X"
```

### Pattern 3: Full Orchestrated Update

```bash
# Complete major work
/ck:doc-review/main "Phase 2 implementation"

→ Analysis shown
→ User selects scope
→ Sub-commands execute
→ Summary presented
```

### Pattern 4: QA Before Commit (Best Practice)

```bash
# Before git commit
/ck:doc-review/qa

→ Fix issues
→ Re-run QA
→ Commit with confidence
```

---

## 🔍 Commands Reference

### `/ck:doc-review/main` - Orchestrator

Smart orchestration with user control.

**What it does:**

- Runs comprehensive analysis
- Asks which areas to update
- Delegates to sub-commands
- Shows aggregated summary

**When to use:** Full updates or when unsure what to update

---

### `/ck:doc-review/analyze` - Analysis

Analysis only, zero file changes.

**What it does:**

- Extracts documentation principles
- Analyzes structure and metrics
- Assesses change impact
- Provides recommendations

**When to use:** "What docs need updating?"

---

### `/ck:doc-review/core` - Core Files

Updates README, CLAUDE, CHANGELOG.

**What it does:**

- README.md: Features, usage, installation
- CLAUDE.md: AI context, module docs
- CHANGELOG.md: Version entry

**When to use:** Quick updates after feature work

---

### `/ck:doc-review/sdd` - SDD Artifacts

Updates specification-driven development docs.

**What it does:**

- spec.md: Mark requirements complete
- plan.md: Update phase status
- tasks.md: Mark tasks done
- contracts/\*.md: Update API specs

**When to use:** After completing implementation phases

---

### `/ck:doc-review/qa` - Quality Validation

Comprehensive quality checks, zero changes.

**What it does:**

- Validates links (finds broken links)
- Checks file:line references
- Verifies terminology consistency
- Validates version numbers
- Checks SDD traceability
- Generates scored report (0-100)

**When to use:** Before committing documentation

---

### `/ck:doc-review/help` - Help

Comprehensive usage guide.

**What it does:**

- Shows all commands
- Provides usage patterns
- Decision tree for choosing commands
- Token budget examples
- Troubleshooting guide

**When to use:** First time, or need reminder

---

## 🛠️ Configuration

### Pattern Categories (`config/categories.json`)

Define how files are categorized:

```json
{
  "categories": {
    "developer": {
      "patterns": ["## API", "### Endpoints", "curl.*http"],
      "description": "API documentation"
    },
    "user": {
      "patterns": ["## Installation", "### Setup"],
      "description": "User guides"
    }
  }
}
```

Customize patterns for your project's documentation style.

---

## 🧪 Testing

```bash
# Test installation
./tests/test-install.sh

# Test commands
./tests/test-commands.sh
```

---

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Development setup
- Code style guidelines
- Testing requirements
- Pull request process

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Built for [Claude Code](https://claude.ai/code) by Anthropic
- Inspired by specification-driven development practices
- Community feedback and contributions

---

## 📊 Stats & Metrics

- **Commands:** 6 modular sub-commands
- **Token Efficiency:** 88% reduction vs monolithic
- **Execution Speed:** 70% faster with focused commands
- **Lines of Code:** ~1,500 (commands + tools)
- **External Dependencies:** Zero (just bash + Claude Code)

---

## 🔗 Links

- [GitHub Repository](https://github.com/kimcharli/doc-review-commands)
- [Issues](https://github.com/kimcharli/doc-review-commands/issues)
- [Discussions](https://github.com/kimcharli/doc-review-commands/discussions)
- [Releases](https://github.com/kimcharli/doc-review-commands/releases)

---

## 📮 Support

- 🐛 [Report bugs](https://github.com/kimcharli/doc-review-commands/issues)
- 💡 [Request features](https://github.com/kimcharli/doc-review-commands/issues)
- 💬 [Ask questions](https://github.com/kimcharli/doc-review-commands/discussions)

---

## 🎯 Roadmap

- [ ] v1.0: Initial release with 6 core commands
- [ ] v1.1: Add diagram generation sub-command
- [ ] v1.2: Multi-language template support
- [ ] v2.0: Claude Skills integration
- [ ] v2.1: CI/CD integration mode
- [ ] v3.0: Documentation metrics dashboard

---

## 📚 References & Documentation

### Claude Code Official Documentation

- [Claude Code Plugins Guide](https://docs.claude.com/en/docs/claude-code/plugins)
- [Plugin Marketplaces](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)
- [Claude Code Overview](https://claude.ai/code)

### Related Resources

- [GitHub: ck-skills Repository](https://github.com/kimcharli/ck-skills)
- [GitHub: doc-review-commands Plugin](https://github.com/kimcharli/ck-skills/tree/main/doc-review-commands)
- [Claude Code Marketplace](https://claudecodemarketplace.com/)

### Tools & Technologies

- [markdownlint](https://github.com/igorshubovych/markdownlint-cli) - Markdown style checker and auto-fixer
- [prettier](https://prettier.io/) - Code formatter

### Inspiration

- Specification-Driven Development (SDD) methodology
- Modular command architecture for Claude Code
- Zero-dependency tool design philosophy

---

**Made with ❤️ for better documentation workflows**
