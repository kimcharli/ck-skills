#!/usr/bin/env bats
#
# Tests for plugins/sdd-project-init/tools/create-project.sh
#
# Uses work/ (gitignored) as a temp directory for generated projects.
#

SCRIPT="$BATS_TEST_DIRNAME/../plugins/sdd-project-init/tools/create-project.sh"
WORK_DIR="$BATS_TEST_DIRNAME/../work"

setup() {
    rm -rf "$WORK_DIR"
    mkdir -p "$WORK_DIR"
}

teardown() {
    rm -rf "$WORK_DIR"
}

# Helper: run create-project with common defaults
run_create() {
    run bash "$SCRIPT" \
        --name "my-tool" \
        --purpose "Does X so that Y" \
        --stack "Python/uv" \
        --runtime "CLI" \
        --integrations "Apstra REST API" \
        --path "$WORK_DIR/my-tool" \
        "$@"
}

# ── Argument parsing & validation ────────────────────────────────────────────

@test "fails when --name is missing" {
    run bash "$SCRIPT" \
        --purpose "something" \
        --path "$WORK_DIR/test"
    [ "$status" -ne 0 ]
    [[ "$output" == *"--name, --purpose, and --path are required"* ]]
}

@test "fails when --purpose is missing" {
    run bash "$SCRIPT" \
        --name "foo" \
        --path "$WORK_DIR/test"
    [ "$status" -ne 0 ]
    [[ "$output" == *"--name, --purpose, and --path are required"* ]]
}

@test "fails when --path is missing" {
    run bash "$SCRIPT" \
        --name "foo" \
        --purpose "something"
    [ "$status" -ne 0 ]
    [[ "$output" == *"--name, --purpose, and --path are required"* ]]
}

@test "fails on unknown argument" {
    run bash "$SCRIPT" --bogus "value"
    [ "$status" -ne 0 ]
    [[ "$output" == *"Unknown argument: --bogus"* ]]
}

@test "succeeds with all required arguments" {
    run_create
    [ "$status" -eq 0 ]
}

# ── Directory structure ──────────────────────────────────────────────────────

@test "creates project root directory" {
    run_create
    [ -d "$WORK_DIR/my-tool" ]
}

@test "creates docs/ subdirectory" {
    run_create
    [ -d "$WORK_DIR/my-tool/docs" ]
}

@test "creates specs/ subdirectory" {
    run_create
    [ -d "$WORK_DIR/my-tool/specs" ]
}

@test "creates specs/features/ subdirectory" {
    run_create
    [ -d "$WORK_DIR/my-tool/specs/features" ]
}

# ── File generation ──────────────────────────────────────────────────────────

@test "generates AGENTS.md" {
    run_create
    [ -f "$WORK_DIR/my-tool/AGENTS.md" ]
}

@test "generates README.md" {
    run_create
    [ -f "$WORK_DIR/my-tool/README.md" ]
}

@test "generates .gitignore" {
    run_create
    [ -f "$WORK_DIR/my-tool/.gitignore" ]
}

@test "generates .markdownlint.json" {
    run_create
    [ -f "$WORK_DIR/my-tool/.markdownlint.json" ]
}

@test "generates specs/requirements.md" {
    run_create
    [ -f "$WORK_DIR/my-tool/specs/requirements.md" ]
}

@test "generates specs/design.md" {
    run_create
    [ -f "$WORK_DIR/my-tool/specs/design.md" ]
}

@test "generates specs/tasks.md" {
    run_create
    [ -f "$WORK_DIR/my-tool/specs/tasks.md" ]
}

@test "generates specs/features/_template.md" {
    run_create
    [ -f "$WORK_DIR/my-tool/specs/features/_template.md" ]
}

@test "generates docs/sdd-how-to-apply.md" {
    run_create
    [ -f "$WORK_DIR/my-tool/docs/sdd-how-to-apply.md" ]
}

# ── Template substitution: PROJECT_NAME ──────────────────────────────────────

@test "substitutes PROJECT_NAME in AGENTS.md" {
    run_create
    grep -q "my-tool" "$WORK_DIR/my-tool/AGENTS.md"
}

@test "substitutes PROJECT_NAME in README.md" {
    run_create
    grep -q "# my-tool" "$WORK_DIR/my-tool/README.md"
}

# ── Template substitution: PROJECT_PURPOSE ───────────────────────────────────

@test "substitutes PROJECT_PURPOSE in AGENTS.md" {
    run_create
    grep -q "Does X so that Y" "$WORK_DIR/my-tool/AGENTS.md"
}

@test "substitutes PROJECT_PURPOSE in README.md" {
    run_create
    grep -q "Does X so that Y" "$WORK_DIR/my-tool/README.md"
}

# ── Template substitution: LANGUAGE_STACK & RUNTIME_TARGET ───────────────────

@test "substitutes LANGUAGE_STACK in AGENTS.md" {
    run_create
    grep -q "Python/uv" "$WORK_DIR/my-tool/AGENTS.md"
}

@test "substitutes RUNTIME_TARGET in AGENTS.md" {
    run_create
    grep -q "CLI" "$WORK_DIR/my-tool/AGENTS.md"
}

# ── Template substitution: PACKAGE_NAME (hyphen to underscore) ───────────────

@test "converts hyphens to underscores for PACKAGE_NAME" {
    run_create
    grep -q "my_tool" "$WORK_DIR/my-tool/AGENTS.md"
}

# ── Template substitution: INTEGRATIONS_LINE ─────────────────────────────────

@test "substitutes integrations line when provided" {
    run_create
    grep -q "Apstra REST API" "$WORK_DIR/my-tool/AGENTS.md"
}

@test "omits integrations line when empty" {
    run bash "$SCRIPT" \
        --name "bare-project" \
        --purpose "Testing" \
        --stack "Go" \
        --runtime "API" \
        --path "$WORK_DIR/bare-project"
    # Should not contain the integrations marker
    ! grep -q "Integrations" "$WORK_DIR/bare-project/AGENTS.md"
}

# ── Template substitution: SETUP_HINT (Python detection) ────────────────────

@test "generates Python-specific setup hint for Python stack" {
    run_create
    grep -q "uv sync" "$WORK_DIR/my-tool/README.md"
}

@test "generates generic setup hint for non-Python stack" {
    run bash "$SCRIPT" \
        --name "go-svc" \
        --purpose "A service" \
        --stack "Go" \
        --runtime "API" \
        --path "$WORK_DIR/go-svc"
    grep -q "fill in setup commands for Go" "$WORK_DIR/go-svc/README.md"
}

@test "detects lowercase python in stack" {
    run bash "$SCRIPT" \
        --name "py-app" \
        --purpose "A thing" \
        --stack "python3.12" \
        --runtime "CLI" \
        --path "$WORK_DIR/py-app"
    grep -q "uv sync" "$WORK_DIR/py-app/README.md"
}

# ── Template substitution: DATE ──────────────────────────────────────────────

@test "substitutes DATE in specs/requirements.md" {
    run_create
    today="$(date +%Y-%m-%d)"
    grep -q "$today" "$WORK_DIR/my-tool/specs/requirements.md"
}

@test "substitutes DATE in specs/design.md" {
    run_create
    today="$(date +%Y-%m-%d)"
    grep -q "$today" "$WORK_DIR/my-tool/specs/design.md"
}

@test "substitutes DATE in specs/tasks.md" {
    run_create
    today="$(date +%Y-%m-%d)"
    grep -q "$today" "$WORK_DIR/my-tool/specs/tasks.md"
}

# ── No leftover template placeholders ────────────────────────────────────────

@test "no unreplaced {{...}} placeholders remain in any file" {
    run_create
    result=$(grep -r '{{.*}}' "$WORK_DIR/my-tool/" 2>/dev/null || true)
    [ -z "$result" ]
}

# ── .gitignore is copied verbatim (not substituted) ─────────────────────────

@test ".gitignore matches template exactly" {
    run_create
    template_dir="$(cd "$(dirname "$SCRIPT")/../template" && pwd)"
    diff -q "$template_dir/.gitignore" "$WORK_DIR/my-tool/.gitignore"
}

# ── Git initialization ──────────────────────────────────────────────────────

@test "initializes a git repository" {
    run_create
    [ -d "$WORK_DIR/my-tool/.git" ]
}

@test "creates initial commit" {
    run_create
    cd "$WORK_DIR/my-tool"
    run git log --oneline -1
    [ "$status" -eq 0 ]
    [[ "$output" == *"init SDD project structure"* ]]
}

@test "working tree is clean after init" {
    run_create
    cd "$WORK_DIR/my-tool"
    run git status --porcelain
    [ -z "$output" ]
}

# ── Output messages ──────────────────────────────────────────────────────────

@test "prints project name in success banner" {
    run_create
    [[ "$output" == *"my-tool initialized"* ]]
}

@test "prints project path in output" {
    run_create
    [[ "$output" == *"$WORK_DIR/my-tool"* ]]
}

@test "prints next step guidance" {
    run_create
    [[ "$output" == *"specs/requirements.md"* ]]
}

# ── Edge cases ───────────────────────────────────────────────────────────────

@test "handles project name with no hyphens" {
    run bash "$SCRIPT" \
        --name "simple" \
        --purpose "Test" \
        --stack "Python" \
        --runtime "CLI" \
        --path "$WORK_DIR/simple"
    [ "$status" -eq 0 ]
    grep -q "simple" "$WORK_DIR/simple/AGENTS.md"
}

@test "handles purpose with special characters" {
    run bash "$SCRIPT" \
        --name "special" \
        --purpose "Does X & Y for z's benefit" \
        --stack "Python" \
        --runtime "CLI" \
        --path "$WORK_DIR/special"
    [ "$status" -eq 0 ]
    [ -f "$WORK_DIR/special/AGENTS.md" ]
}

@test "creates nested path that does not exist" {
    run bash "$SCRIPT" \
        --name "deep" \
        --purpose "Test" \
        --stack "Go" \
        --runtime "API" \
        --path "$WORK_DIR/a/b/c/deep"
    [ "$status" -eq 0 ]
    [ -d "$WORK_DIR/a/b/c/deep" ]
    [ -f "$WORK_DIR/a/b/c/deep/AGENTS.md" ]
}
