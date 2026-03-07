# Check Open Issues

## Usage

```txt
/check-open-issues
```

## Description

Check for open GitHub issues across all Git repositories two levels deep from
the `~/Trifecta` folder. Uses the `gh` CLI to query GitHub for open issues in
each repository.

## Implementation

For each repository two levels deep under `~/Trifecta`, run `gh issue list` and
aggregate the results. Use Bash to iterate:

```bash
for org in ~/Trifecta/*/; do
  for repo in "$org"*/; do
    if [ -d "$repo/.git" ]; then
      echo "--- $(basename $org)/$(basename $repo) ---"
      remote=$(git -C "$repo" remote get-url origin | sed 's|.*github.com[:/]||;s|\.git$||')
      gh issue list --state open --repo "$remote" 2>/dev/null || echo "(no issues or not a GitHub repo)"
    fi
  done
done
```

## Steps

1. Discover all directories two levels deep under `~/Trifecta`
2. Filter to those containing a `.git` folder
3. For each git repository, resolve the GitHub remote URL
4. Run `gh issue list --state open` targeting the resolved repo
5. Display results grouped by repository

## Output

```txt
--- NLF/Harness ---
#24  [Roadmap] WindowsDistribution: Build and distribute HarnessCLI.exe for Windows   enhancement   about 2 days ago

--- NLF/Web ---
#2   [Roadmap] Migrate from Hummingbird + Elementary to Toucan Static Site Generator              about 40 days ago

--- NeonLaw/Web ---
(no open issues)
...
```

## Error Handling

- Repositories with no GitHub remote are skipped with a note
- Repositories with no open issues display `(no open issues)`
- If `gh` is not authenticated, an error is shown and the loop continues
- Directories that are not git repositories are silently skipped
