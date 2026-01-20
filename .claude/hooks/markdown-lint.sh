#!/bin/bash
# Claude Code hook: Lint markdown files after write/edit operations

# Read JSON input from stdin
input=$(cat)

# Extract file_path from the JSON
file_path=$(echo "$input" | python3 -c "import sys, json; data = json.load(sys.stdin); print(data.get('tool_input', {}).get('file_path', ''))" 2>/dev/null)

# Exit if no file path or not a markdown file
if [[ -z "$file_path" ]] || [[ ! "$file_path" =~ \.md$ ]]; then
    exit 0
fi

# Exit if file doesn't exist
if [[ ! -f "$file_path" ]]; then
    exit 0
fi

# Load nvm and use Node 20
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    . "$NVM_DIR/nvm.sh"
    nvm use 20 >/dev/null 2>&1
fi

# Check if markdownlint-cli2 is available
if ! command -v markdownlint-cli2 &>/dev/null; then
    echo "markdownlint-cli2 not found, skipping lint"
    exit 0
fi

# Run markdownlint-cli2 on the specific file
markdownlint-cli2 "$file_path"
