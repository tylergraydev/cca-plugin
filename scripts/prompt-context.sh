#!/bin/bash
# CCA Prompt Context Hook
# Analyzes user prompt and injects relevant notes

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
CCA_DIR="$PROJECT_DIR/.cca"

# Read the prompt from stdin
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)

# Exit if CCA not initialized or no prompt
if [ ! -d "$CCA_DIR/notes" ] || [ -z "$PROMPT" ]; then
    exit 0
fi

# Convert prompt to lowercase for matching
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Check for debugging indicators
is_debugging() {
    echo "$PROMPT_LOWER" | grep -qE "(error|bug|fix|broken|not working|issue|problem|debug|crash|fail)"
}

# Check for specific file mentions
get_mentioned_files() {
    echo "$PROMPT" | grep -oE '[a-zA-Z0-9_/-]+\.(ts|js|py|rs|go|cs|java|tsx|jsx)' | head -3
}

# Search notes for relevant content
search_notes() {
    local search_term="$1"
    local found=""
    
    for note in "$CCA_DIR/notes"/*.md; do
        [ -f "$note" ] || continue
        if grep -qi "$search_term" "$note" 2>/dev/null; then
            title=$(head -1 "$note" | sed 's/^# //')
            filename=$(basename "$note")
            found="$found\n- $title ($filename)"
        fi
    done
    
    echo -e "$found"
}

# Build context additions
CONTEXT=""

# If debugging, search for related bug notes
if is_debugging; then
    # Extract potential keywords
    KEYWORDS=$(echo "$PROMPT_LOWER" | grep -oE '\b[a-z]{4,}\b' | sort -u | head -5)
    
    for keyword in $KEYWORDS; do
        matches=$(search_notes "$keyword")
        if [ -n "$matches" ]; then
            CONTEXT="$CONTEXT\n📚 Possibly relevant notes for '$keyword':$matches"
        fi
    done
fi

# Check for mentioned files
MENTIONED_FILES=$(get_mentioned_files)
if [ -n "$MENTIONED_FILES" ]; then
    for file in $MENTIONED_FILES; do
        matches=$(search_notes "$file")
        if [ -n "$matches" ]; then
            CONTEXT="$CONTEXT\n📚 Notes mentioning $file:$matches"
        fi
    done
fi

# Output context if any found
if [ -n "$CONTEXT" ]; then
    echo -e "\n[CCA Context]$CONTEXT\n"
    echo "Use /cca:recall to load full note content."
fi

exit 0
