#!/bin/bash
# CCA Post-Edit Hook
# Auto-formats files and tracks changes for note suggestions

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
CCA_DIR="$PROJECT_DIR/.cca"

# Read the tool input from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)

# Exit if no file path
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Get file extension
EXT="${FILE_PATH##*.}"

# Track edit in session log (for note suggestions later)
if [ -d "$CCA_DIR" ]; then
    SESSION_LOG="$CCA_DIR/.session_edits"
    echo "$(date +%s):$FILE_PATH" >> "$SESSION_LOG" 2>/dev/null
fi

# Auto-format based on extension
format_result=""

case "$EXT" in
    ts|tsx|js|jsx|json|md|css|scss|html)
        if [ -f "$PROJECT_DIR/node_modules/.bin/prettier" ]; then
            format_result=$(npx prettier --write "$FILE_PATH" 2>&1)
            if [ $? -eq 0 ]; then
                echo "✨ Formatted: $FILE_PATH"
            fi
        elif command -v prettier &> /dev/null; then
            format_result=$(prettier --write "$FILE_PATH" 2>&1)
            if [ $? -eq 0 ]; then
                echo "✨ Formatted: $FILE_PATH"
            fi
        fi
        ;;
    py)
        if command -v ruff &> /dev/null; then
            ruff format "$FILE_PATH" 2>/dev/null && echo "✨ Formatted: $FILE_PATH (ruff)"
        elif command -v black &> /dev/null; then
            black -q "$FILE_PATH" 2>/dev/null && echo "✨ Formatted: $FILE_PATH (black)"
        fi
        ;;
    rs)
        if command -v rustfmt &> /dev/null; then
            rustfmt "$FILE_PATH" 2>/dev/null && echo "✨ Formatted: $FILE_PATH (rustfmt)"
        fi
        ;;
    go)
        if command -v gofmt &> /dev/null; then
            gofmt -w "$FILE_PATH" 2>/dev/null && echo "✨ Formatted: $FILE_PATH (gofmt)"
        fi
        ;;
    cs)
        # dotnet format is slower, only run if explicitly configured
        if [ -f "$CCA_DIR/config.json" ]; then
            if jq -e '.autoFormat.csharp == true' "$CCA_DIR/config.json" >/dev/null 2>&1; then
                dotnet format --include "$FILE_PATH" 2>/dev/null && echo "✨ Formatted: $FILE_PATH"
            fi
        fi
        ;;
    java|kt)
        # Google Java Format or ktlint - usually project-specific
        if [ -f "$PROJECT_DIR/gradlew" ]; then
            # Check if spotless is available
            if grep -q "spotless" "$PROJECT_DIR/build.gradle" 2>/dev/null || \
               grep -q "spotless" "$PROJECT_DIR/build.gradle.kts" 2>/dev/null; then
                echo "💡 Run './gradlew spotlessApply' to format Java/Kotlin files"
            fi
        fi
        ;;
esac

exit 0
