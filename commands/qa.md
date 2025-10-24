---
description: Quality validation - check links, consistency, completeness
allowed-tools: Bash(find:*), Bash(grep:*), Bash(git:*), Read(*), Grep(*), Glob(*)
---

## Context

- All markdown files: !`find . -name "*.md" | wc -l`
- Recent doc changes: !`git log -5 --oneline -- "*.md" 2>/dev/null || echo "No recent doc commits"`

## Task

**Quality validation of documentation** - No changes made, only validation and reporting.

---

## QA Check 1: Link Validation

### Find All Markdown Links

Search for markdown links in all .md files:
```bash
# Find all links
find . -name "*.md" -exec grep -o '\[.*\](.*\.md)' {} +

# Find relative links
find . -name "*.md" -exec grep -o '](\.\.*/.*\.md)' {} +
```

### Validate Links

For each link found:
- Check if target file exists
- Note broken links
- Note external links (for manual review)

**Report Format:**
```
✅ Valid links: [count]
❌ Broken links: [count]
⚠️  External links: [count] (manual review needed)

Broken Links Found:
- file.md:123 → links to missing-file.md
- [...]
```

---

## QA Check 2: Cross-Reference Consistency

### File:Line References

Find all code references (e.g., `path/to/file.py:123`):
```bash
find . -name "*.md" -exec grep -o '[a-zA-Z0-9_/.-]*\.[a-z]*:[0-9]*' {} +
```

### Validate References

For each reference:
- Check if file exists
- Optionally check if line number is reasonable (file has that many lines)

**Report Format:**
```
✅ Valid references: [count]
❌ Invalid file references: [count]
⚠️  Questionable line numbers: [count]

Issues Found:
- README.md mentions deleted_file.py:50
- CLAUDE.md references file.py:999 (file only has 200 lines)
```

---

## QA Check 3: Terminology Consistency

### Extract Key Terms

Find variations of important terms:
```bash
# Example: Find all variations of "apstra"
grep -i "apstra\|APSTRA\|Apstra" . -r --include="*.md"

# Check for inconsistent capitalization
# Check for inconsistent naming (e.g., "doc review" vs "doc-review")
```

### Common Inconsistencies to Check

- Product names (capitalization)
- Feature names (hyphenation)
- Technical terms (spelling variations)
- Version numbers (consistency)

**Report Format:**
```
📝 Terminology Review:

Consistent:
- ✅ "Apstra" used consistently (capitalized)
- ✅ "NetworkX" spelling consistent

Inconsistent:
- ⚠️  "doc-review" vs "doc review" (3 vs 2 occurrences)
- ⚠️  "Python" vs "python" mixed usage

Recommendations:
- Standardize on "doc-review" (hyphenated)
- Use "Python" (capitalized) for language name
```

---

## QA Check 4: Version Number Consistency

### Find All Version References

```bash
# Find version patterns
grep -E "v?[0-9]+\.[0-9]+\.[0-9]+" . -r --include="*.md"
grep -E "version.*[0-9]" . -r --include="*.md" -i
```

### Check Consistency

- Same version mentioned in multiple places?
- CHANGELOG.md version matches README.md?
- pyproject.toml version matches documentation?

**Report Format:**
```
📊 Version Consistency:

Found Versions:
- README.md: v1.2.0
- CHANGELOG.md: 1.2.0 (latest entry)
- pyproject.toml: 1.1.5

Issues:
- ❌ Version mismatch: README (1.2.0) vs pyproject.toml (1.1.5)

Recommendation:
- Update pyproject.toml to 1.2.0 or clarify version strategy
```

---

## QA Check 5: SDD Consistency (if applicable)

### Check Requirement Traceability

Find all requirement IDs (FR-*, NFR-*):
```bash
grep -E "(FR|NFR)-[0-9]+" . -r --include="*.md"
```

### Validate Traceability

- Are requirements in spec.md referenced in plan.md?
- Are completed requirements (✅) in spec.md also marked done in tasks.md?
- Are all requirements accounted for?

**Report Format:**
```
🔍 SDD Traceability:

Requirements in spec.md: [count]
Requirements in plan.md: [count]
Requirements in tasks.md: [count]

Orphaned Requirements:
- FR-005 appears in spec.md but not in tasks.md
- [...]

Completed but Not Marked:
- FR-003 marked done in tasks.md but not in spec.md
```

---

## QA Check 6: Code Example Syntax

### Find Code Blocks

```bash
# Find all code fences
grep -E "^\`\`\`" . -r --include="*.md"
```

### Basic Syntax Check

- Are code fences properly closed?
- Is language specified (```python vs ```)?
- Look for obvious syntax errors in examples

**Report Format:**
```
💻 Code Example Review:

Code blocks found: [count]
Language specified: [count]/[total]
Unclosed fences: [count]

Issues:
- README.md:50 - Code fence not closed
- CLAUDE.md:120 - No language specified
```

---

## QA Check 7: Completeness Check

### Required Sections

Check if standard files have expected sections:

**README.md:**
- [ ] Project description
- [ ] Installation
- [ ] Usage examples
- [ ] Configuration
- [ ] License

**CLAUDE.md:**
- [ ] Project overview
- [ ] Core architecture
- [ ] Key modules
- [ ] Common workflows

**CHANGELOG.md:**
- [ ] Recent version entries
- [ ] Categorized changes (Added/Changed/Fixed)
- [ ] Dates

**Report Format:**
```
📋 Completeness Check:

README.md:
- ✅ Has installation section
- ✅ Has usage examples
- ❌ Missing troubleshooting section

CLAUDE.md:
- ✅ Has architecture overview
- ⚠️  Core modules section is sparse
```

---

## Output: QA Summary Report

### 📊 Documentation Quality Assurance Report

**Validation Date:** [YYYY-MM-DD]

**Overall Score:** [X]/100

---

### Link Validation
- ✅ Valid links: [count]
- ❌ Broken links: [count]
- Score: [X]/20

### Cross-Reference Validation
- ✅ Valid references: [count]
- ❌ Invalid references: [count]
- Score: [X]/15

### Terminology Consistency
- Inconsistencies found: [count]
- Score: [X]/15

### Version Consistency
- Matches found: [count]
- Mismatches: [count]
- Score: [X]/15

### SDD Consistency
- Orphaned requirements: [count]
- Traceability: [X]%
- Score: [X]/15

### Code Example Quality
- Syntax issues: [count]
- Score: [X]/10

### Completeness
- Missing sections: [count]
- Score: [X]/10

---

### Priority Issues

**High Priority (Fix Immediately):**
1. [Issue description and location]
2. [...]

**Medium Priority (Fix Soon):**
1. [Issue description and location]
2. [...]

**Low Priority (Nice to Have):**
1. [Issue description and location]
2. [...]

---

### Recommended Actions

1. **Fix broken links:**
   - [Specific links to fix]

2. **Update version numbers:**
   - [Where to update]

3. **Standardize terminology:**
   - Use "[term]" instead of "[variation]"

4. **Complete missing sections:**
   - Add troubleshooting to README.md
   - [...]

---

## Next Steps

- [ ] Fix high-priority issues
- [ ] Review and fix medium-priority issues
- [ ] Consider low-priority improvements
- [ ] Re-run QA after fixes: `/ck:doc-review:qa`
- [ ] Commit QA fixes: `git commit -m "docs: Fix QA issues"`
