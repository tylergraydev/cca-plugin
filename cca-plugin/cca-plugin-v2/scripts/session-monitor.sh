#!/bin/bash
# CCA Session Monitor Hook
# Monitors for note-worthy events and session length

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
CCA_DIR="$PROJECT_DIR/.cca"

# Exit if CCA not initialized
if [ ! -d "$CCA_DIR" ]; then
    exit 0
fi

# Read the stop event from stdin
INPUT=$(cat)

# Track session metrics
SESSION_FILE="$CCA_DIR/.session_state"
EDITS_FILE="$CCA_DIR/.session_edits"

# Initialize or read session state
if [ ! -f "$SESSION_FILE" ]; then
    echo "start_time=$(date +%s)" > "$SESSION_FILE"
    echo "message_count=0" >> "$SESSION_FILE"
    echo "edit_count=0" >> "$SESSION_FILE"
fi

# Source current state
source "$SESSION_FILE"

# Increment message count
message_count=$((message_count + 1))
echo "start_time=$start_time" > "$SESSION_FILE"
echo "message_count=$message_count" >> "$SESSION_FILE"

# Count edits
if [ -f "$EDITS_FILE" ]; then
    edit_count=$(wc -l < "$EDITS_FILE" | tr -d ' ')
else
    edit_count=0
fi
echo "edit_count=$edit_count" >> "$SESSION_FILE"

# Calculate session duration
current_time=$(date +%s)
duration=$((current_time - start_time))
duration_mins=$((duration / 60))

# Session length warnings
if [ $duration_mins -ge 60 ] && [ $((message_count % 10)) -eq 0 ]; then
    echo ""
    echo "⏱️ CCA: Session running for ${duration_mins}m with $edit_count edits."
    echo "   Consider using /cca:reflect to capture learnings."
    echo ""
fi

# Check if we should suggest notes based on conversation patterns
# This is a simplified heuristic - the real magic happens in the skill prompts

# Long session with many edits = probably solved something
if [ $edit_count -ge 5 ] && [ $duration_mins -ge 30 ]; then
    if [ ! -f "$CCA_DIR/.note_suggested" ]; then
        echo ""
        echo "💡 CCA: You've made $edit_count edits over ${duration_mins}m."
        echo "   If you solved a tricky problem, consider /cca:note to document it."
        echo ""
        touch "$CCA_DIR/.note_suggested"
    fi
fi

exit 0
