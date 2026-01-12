#!/bin/bash
# CCA Session Start Hook
# Loads project context, notes, and language detection

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
CCA_DIR="$PROJECT_DIR/.cca"

# Check if CCA is initialized
if [ ! -d "$CCA_DIR" ]; then
    echo "⚠️ CCA not initialized in this project."
    echo "Run /cca:init to set up the Confucius Code Agent system."
    echo ""
    exit 0
fi

# Header
echo "🤖 CCA (Confucius Code Agent) Active"
echo "════════════════════════════════════════"

# Language detection
detect_language() {
    if [ -f "$PROJECT_DIR/package.json" ]; then
        if [ -f "$PROJECT_DIR/tsconfig.json" ]; then
            echo "TypeScript"
        else
            echo "JavaScript"
        fi
    elif [ -f "$PROJECT_DIR/Cargo.toml" ]; then
        echo "Rust"
    elif [ -f "$PROJECT_DIR/go.mod" ]; then
        echo "Go"
    elif [ -f "$PROJECT_DIR/pyproject.toml" ] || [ -f "$PROJECT_DIR/requirements.txt" ]; then
        echo "Python"
    elif ls "$PROJECT_DIR"/*.csproj >/dev/null 2>&1 || ls "$PROJECT_DIR"/*.sln >/dev/null 2>&1; then
        echo "C#"
    elif [ -f "$PROJECT_DIR/pom.xml" ] || [ -f "$PROJECT_DIR/build.gradle" ]; then
        echo "Java"
    else
        echo "Unknown"
    fi
}

# Package manager detection
detect_package_manager() {
    if [ -f "$PROJECT_DIR/pnpm-lock.yaml" ]; then
        echo "pnpm"
    elif [ -f "$PROJECT_DIR/yarn.lock" ]; then
        echo "yarn"
    elif [ -f "$PROJECT_DIR/bun.lockb" ]; then
        echo "bun"
    elif [ -f "$PROJECT_DIR/package-lock.json" ]; then
        echo "npm"
    elif [ -f "$PROJECT_DIR/poetry.lock" ]; then
        echo "poetry"
    elif [ -f "$PROJECT_DIR/Pipfile.lock" ]; then
        echo "pipenv"
    elif [ -f "$PROJECT_DIR/uv.lock" ]; then
        echo "uv"
    else
        echo ""
    fi
}

LANG=$(detect_language)
PKG_MGR=$(detect_package_manager)
BRANCH=$(git -C "$PROJECT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no git")
NOTE_COUNT=$(ls -1 "$CCA_DIR/notes"/*.md 2>/dev/null | wc -l | tr -d ' ')

echo "📚 Notes: $NOTE_COUNT | 🔤 $LANG | 🌿 $BRANCH"
[ -n "$PKG_MGR" ] && echo "📦 Package Manager: $PKG_MGR"
echo ""

# Load recent/relevant notes summary
if [ "$NOTE_COUNT" -gt 0 ]; then
    echo "📖 Knowledge Base Loaded:"
    
    # Get the 3 most recent notes
    for note in $(ls -t "$CCA_DIR/notes"/*.md 2>/dev/null | head -3); do
        # Extract title from first line
        title=$(head -1 "$note" | sed 's/^# //')
        filename=$(basename "$note")
        echo "   • $title"
    done
    
    echo ""
    echo "💡 Tip: Use /cca:recall [topic] to search notes"
fi

# Git status summary
MODIFIED=$(git -C "$PROJECT_DIR" status --short 2>/dev/null | wc -l | tr -d ' ')
if [ "$MODIFIED" -gt 0 ]; then
    echo ""
    echo "📝 Git: $MODIFIED file(s) modified"
fi

echo ""
echo "════════════════════════════════════════"
echo ""

# Output context for Claude (this goes into the conversation)
echo "CCA CONTEXT LOADED:"
echo "- Language: $LANG"
echo "- Branch: $BRANCH"
echo "- Notes available: $NOTE_COUNT"
echo ""
echo "CCA will automatically:"
echo "- Format files after edits"
echo "- Suggest notes when bugs are fixed"
echo "- Monitor session length"
echo ""

exit 0
