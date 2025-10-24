# doc-review-commands Optimization Analysis

**Date:** 2025-10-24
**Status:** Comprehensive optimization in progress
**Goal:** Maximize speed, minimize token usage, leverage bash scripts

---

## 1. Current Token Cost Analysis

### File Sizes (Approximate Token Count)
```
analyze.md    ~  2.4K  → ~600-800 tokens
core.md       ~  3.9K  → ~1.2-1.5K tokens
help.md       ~ 15.0K  → ~3-4K tokens (rarely loaded)
main.md       ~  3.1K  → ~900-1.2K tokens
qa.md         ~  9.2K  → ~1.8-2K tokens
sdd.md        ~  6.5K  → ~1.5-1.8K tokens
─────────────────────────────────────────────
TOTAL         ~ 40KB   → ~9-11K tokens per full run
```

### Token Cost Breakdown

**Current Implementation Issues:**
1. ✅ Modular sub-commands exist (good)
2. ❌ No caching - script results re-run each time
3. ❌ Long inline instructions instead of script references
4. ❌ Help text included in every command (~3K tokens)
5. ❌ Template examples not stripped from AI prompts

### Per-Command Token Usage
- `:help` - 3-4K (includes full documentation)
- `:analyze` - 600-800 (script output varies)
- `:core` - 1.2-1.5K (inline instructions)
- `:sdd` - 1.5-1.8K (template-heavy)
- `:qa` - 1.8-2K (QA procedures)
- `main` - 900-1.2K (orchestrator)

---

## 2. Optimization Strategies

### Strategy 1: Result Caching
**Token Savings:** 20-30% per repeat run

Create `.cache/doc-review/` directory to store:
- Analysis results (expires after 1 hour)
- Link validation results (expires after 4 hours)
- Metrics (expires after 24 hours)

**Implementation:**
```bash
CACHE_DIR="${HOME}/.cache/doc-review"
CACHE_LIFETIME_ANALYSIS=3600      # 1 hour
CACHE_LIFETIME_LINKS=14400         # 4 hours
CACHE_LIFETIME_METRICS=86400       # 24 hours

# Check cache before running
if [ -f "$CACHE_DIR/analysis.json" ]; then
    if [ $(($(date +%s) - $(stat -f%m "$CACHE_DIR/analysis.json"))) -lt $CACHE_LIFETIME_ANALYSIS ]; then
        cat "$CACHE_DIR/analysis.json"
        exit 0
    fi
fi
```

### Strategy 2: Bash Script Expansion
**Token Savings:** 30-40% by moving logic from AI to scripts

Move mechanical tasks to `analyzer.sh`:
- ✅ Already does: linting, principles, structure, categorize, impact, metrics
- ❌ Missing: link validation, version consistency checks, file reference validation
- ❌ Missing: simple edit operations (adding sections, replacing text)

**New bash functions needed:**
```bash
validate_links()           # Check all markdown links
validate_references()      # Check file:line references
validate_versions()        # Check version consistency
suggest_edits()           # Generate edit suggestions (bash-based)
extract_variables()       # Pull from CLAUDE.md and configs
```

### Strategy 3: Lightweight Mode Command
**Token Savings:** 50-70% for simple updates

Create `/ck:doc-review:quick` command:
- Skip analysis entirely
- Direct file editing without justification
- No validation
- Fast path for known, simple updates

Example:
```bash
# Instead of asking AI to update README, just do it
/ck:doc-review:quick core "Add feature X"
# Runs: analyzer.sh lint → Direct edit → Done (< 1K tokens)
```

### Strategy 4: Smart Template Stripping
**Token Savings:** 10-15% token reduction

Current: Templates included in full command output
Better: Store templates in separate `.templates/` files and reference them

Example:
```bash
# Instead of including 20 lines of template
# Reference the template:
"See template at ~/.claude/commands/ck/doc-review/.templates/requirement.md"
```

### Strategy 5: Configuration-Driven Behavior
**Token Savings:** 5-10% by reducing instructions

Move instruction text to `config/` and reference:
- `config/instructions/core.md` - Core file update procedure
- `config/instructions/sdd.md` - SDD update procedure
- `config/instructions/qa.md` - QA procedure

---

## 3. Implementation Roadmap

### Phase 1: Caching Layer (Est. 1-2 hours)
- [ ] Create cache directory structure
- [ ] Add cache check/write functions to analyzer.sh
- [ ] Add TTL validation
- [ ] Document cache management

**Token Savings:** 20-30% per repeat analysis

### Phase 2: Bash Script Expansion (Est. 2-3 hours)
- [ ] Add `validate_links()` function
- [ ] Add `validate_references()` function
- [ ] Add `validate_versions()` function
- [ ] Add `suggest_edits()` function
- [ ] Test scripts thoroughly

**Token Savings:** 30-40% by moving logic

### Phase 3: Lightweight Mode (Est. 1-2 hours)
- [ ] Create `quick.md` command file
- [ ] Skip analysis entirely
- [ ] Direct file updates only
- [ ] Fast path execution

**Token Savings:** 50-70% for simple updates

### Phase 4: Documentation & Benchmarking (Est. 1 hour)
- [ ] Measure actual token usage before/after
- [ ] Document findings
- [ ] Create performance report
- [ ] Update help text with real numbers

---

## 4. Expected Results

### Before Optimization
```
Full doc-review run:      11-13K tokens
:core quick update:       1.2-1.5K tokens
:analyze (repeat):        600-800 tokens
Monthly budget (20x):     ~25-30K tokens
```

### After Optimization
```
Full doc-review run:      8-10K tokens (-20%)
:core quick update:       800-1K tokens (-30%)
:quick simple update:     400-600 tokens (-50%)
:analyze (cached):        100-200 tokens (-85%)
Monthly budget (20x):     ~18-22K tokens (-25%)
```

### Additional Benefits
- ✅ Faster execution (bash cache vs re-running linting)
- ✅ More predictable token usage
- ✅ Better for quota-limited environments
- ✅ Can run without AI for mechanical tasks
- ✅ Clearer separation of concerns

---

## 5. Key Metrics to Track

| Metric | Current | Target | Method |
|--------|---------|--------|--------|
| Analysis tokens | 600-800 | 100-200 | Cache + bash |
| Core update tokens | 1.2-1.5K | 800-1K | Template extraction |
| Quick update tokens | N/A | 400-600 | New lightweight mode |
| Cache hit rate | 0% | 60-80% | Track cache usage |
| Avg execution time | 2-3s | 0.5-1s | With caching |
| Bash vs AI ratio | 30:70 | 60:40 | Move logic to scripts |

---

## 6. Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Cache staleness | TTL validation + manual clear command |
| Script errors | Comprehensive error handling + fallback to AI |
| Template maintenance | Centralized template directory with version tracking |
| Performance regression | Benchmark before/after each phase |

---

## 7. Success Criteria

- [ ] All caching functions implemented and tested
- [ ] Bash functions cover 80% of mechanical tasks
- [ ] Lightweight mode works without AI for simple updates
- [ ] Actual token usage reduced by 25%+
- [ ] Documentation updated with real benchmarks
- [ ] No regression in functionality or quality

