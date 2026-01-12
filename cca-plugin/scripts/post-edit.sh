#!/bin/bash
# CCA Post-Edit Hook
# Automatically formats files based on language after edits

# Read the tool input from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)

# Exit if no file path
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Get file extension
EXT="${FILE_PATH##*.}"

# Auto-format based on extension (if formatters are available)
case "$EXT" in
    ts|tsx|js|jsx|json|md)
        # Check for Prettier
        if [ -f "node_modules/.bin/prettier" ]; then
            npx prettier --write "$FILE_PATH" 2>/dev/null
        fi
        ;;
    py)
        # Check for Ruff or Black
        if command -v ruff &> /dev/null; then
            ruff format "$FILE_PATH" 2>/dev/null
        elif command -v black &> /dev/null; then
            black "$FILE_PATH" 2>/dev/null
        fi
        ;;
    rs)
        # Check for rustfmt
        if command -v rustfmt &> /dev/null; then
            rustfmt "$FILE_PATH" 2>/dev/null
        fi
        ;;
    go)
        # Go has built-in formatting
        if command -v gofmt &> /dev/null; then
            gofmt -w "$FILE_PATH" 2>/dev/null
        fi
        ;;
    cs)
        # Check for dotnet format
        if command -v dotnet &> /dev/null; then
            dotnet format --include "$FILE_PATH" 2>/dev/null
        fi
        ;;
esac

exit 0
