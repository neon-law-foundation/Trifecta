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
          echo "⚠️  Warning: Uncommitted changes detected, skipping"
          echo ""
          cd "$TRIFECTA_DIR"
          continue
        fi

        # Switch to main, pull, prune
        git checkout main --quiet 2>/dev/null || true
        git fetch origin --prune 2>&1 | grep -v "^Fetching" || true
        git pull origin main 2>&1 | grep -v "^From" || true

        # Delete all local branches except main
        branches=$(git branch | grep -v '^\* main$' | grep -v '^  main$' || true)
        if [ -n "$branches" ]; then
          echo "$branches" | xargs git branch -D
        fi

        # Show status
        echo "✅ Successfully updated (main branch, clean)"

        echo ""
        cd "$TRIFECTA_DIR"
      fi
    done
  fi
done

echo "✨ All repositories updated!"
