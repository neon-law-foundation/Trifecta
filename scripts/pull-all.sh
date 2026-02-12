#!/bin/bash

# Pull all repositories in the Trifecta structure
# This script fetches and pulls the latest changes from all Git repositories
# in the NLF, NeonLaw, and Sagebrush organizations.

set -e

TRIFECTA_DIR="$HOME/Trifecta"

echo "🔄 Pulling all Trifecta repositories..."
echo ""

cd "$TRIFECTA_DIR"

for org in NLF NeonLaw Sagebrush; do
  if [ -d "$org" ]; then
    for repo in "$org"/*; do
      if [ -d "$repo/.git" ]; then
        repo_name=$(basename "$repo")
        echo "📦 Pulling $org/$repo_name..."
        cd "$repo"

        # Check for uncommitted changes
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
          echo "⚠️  Warning: Uncommitted changes detected"
        fi

        # Fetch all branches and prune deleted remotes
        if git fetch --all --prune 2>&1 | grep -v "^Fetching"; then
          :
        fi

        # Get current branch
        current_branch=$(git branch --show-current)

        # Pull latest changes
        if git pull 2>&1 | grep -v "^From"; then
          :
        fi

        # Show status
        if git diff --quiet && git diff --cached --quiet; then
          echo "✅ Successfully updated ($current_branch branch, clean)"
        else
          echo "✅ Successfully updated ($current_branch branch, has changes)"
        fi

        echo ""
        cd "$TRIFECTA_DIR"
      fi
    done
  fi
done

echo "✨ All repositories updated!"
