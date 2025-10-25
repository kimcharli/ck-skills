#!/bin/bash
# Test Skill Builder Generator

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR/../tools"
TEST_SKILLS_DIR="/tmp/test-skills-builder"

echo "Testing Skill Builder Generator..."
echo ""

# Setup
mkdir -p "$TEST_SKILLS_DIR"
export SKILLS_BASE_DIR="$TEST_SKILLS_DIR/skills"

# Test 1: Generate a simple skill
echo "Test 1: Generate basic skill..."
bash "$TOOLS_DIR/generator.sh" "test-skill" "Test description" "Feature 1, Feature 2" 2>&1
SKILL_PATH="$TEST_SKILLS_DIR/skills/test-skill"
if [ -d "$SKILL_PATH" ]; then
    echo "✅ Test 1: Skill directory created"
else
    echo "❌ Test 1: Failed to create skill directory"
    exit 1
fi

# Test 2: Check main command file
if [ -f "$SKILL_PATH/commands/test-skill.md" ]; then
    echo "✅ Test 2: Main command file created"
else
    echo "❌ Test 2: Main command file missing"
    exit 1
fi

# Test 3: Check quick mode command
if [ -f "$SKILL_PATH/commands/test-skill:quick.md" ]; then
    echo "✅ Test 3: Quick mode command created"
else
    echo "❌ Test 3: Quick mode command missing"
    exit 1
fi

# Test 4: Check validation command
if [ -f "$SKILL_PATH/commands/test-skill:validate.md" ]; then
    echo "✅ Test 4: Validation command created"
else
    echo "❌ Test 4: Validation command missing"
    exit 1
fi

# Test 5: Check executor script
if [ -f "$SKILL_PATH/tools/executor.sh" ] && [ -x "$SKILL_PATH/tools/executor.sh" ]; then
    echo "✅ Test 5: Executor script created and executable"
else
    echo "❌ Test 5: Executor script missing or not executable"
    exit 1
fi

# Test 6: Check validator script
if [ -f "$SKILL_PATH/tools/validator.sh" ] && [ -x "$SKILL_PATH/tools/validator.sh" ]; then
    echo "✅ Test 6: Validator script created and executable"
else
    echo "❌ Test 6: Validator script missing or not executable"
    exit 1
fi

# Test 7: Check test file
if [ -f "$SKILL_PATH/tests/test-basic.sh" ] && [ -x "$SKILL_PATH/tests/test-basic.sh" ]; then
    echo "✅ Test 7: Test file created and executable"
else
    echo "❌ Test 7: Test file missing or not executable"
    exit 1
fi

# Test 8: Check documentation
if [ -f "$SKILL_PATH/docs/README.md" ] && [ -f "$SKILL_PATH/docs/GUIDE.md" ]; then
    echo "✅ Test 8: Documentation files created"
else
    echo "❌ Test 8: Documentation files missing"
    exit 1
fi

# Test 9: Run generated test
echo ""
echo "Running generated tests..."
if bash "$SKILL_PATH/tests/test-basic.sh" >/dev/null 2>&1; then
    echo "✅ Test 9: Generated tests pass"
else
    echo "❌ Test 9: Generated tests failed"
    exit 1
fi

# Test 10: Run executor
echo ""
echo "Testing generated executor..."
if bash "$SKILL_PATH/tools/executor.sh" "test input" >/dev/null 2>&1; then
    echo "✅ Test 10: Executor runs successfully"
else
    echo "❌ Test 10: Executor failed"
    exit 1
fi

# Cleanup
echo ""
echo "Cleaning up test files..."
rm -rf "$TEST_SKILLS_DIR"

echo ""
echo "✅ All tests passed!"
