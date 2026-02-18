# Check Open PRs

## Usage

```txt
/check-open-prs
```

## Description

Check for open pull requests across all Git repositories two levels deep from
the `~/Trifecta` folder. Uses the `gh` CLI to query GitHub for open PRs in
each repository.

## Implementation

For each repository two levels deep under `~/Trifecta`, run `gh pr list` and
aggregate the results. Use Bash to iterate:

```bash
for org in ~/Trifecta/*/; do
  for repo in "$org"*/; do
    if [ -d "$repo/.git" ]; then
      echo "--- $(basename $org)/$(basename $repo) ---"
      remote=$(git -C "$repo" remote get-url origin | sed 's|.*github.com[:/]||;s|\.git$||')
      gh pr list --state open --repo "$remote" 2>/dev/null || echo "(no PRs or not a GitHub repo)"
    fi
  done
done
```

## Steps

1. Discover all directories two levels deep under `~/Trifecta`
2. Filter to those containing a `.git` folder
3. For each git repository, resolve the GitHub remote URL
4. Run `gh pr list --state open` targeting the resolved repo
5. Display results grouped by repository

## Output

```txt
--- NLF/SagebrushStandards ---
#42  fix: correct parser logic   feature/fix-parser   about 2 hours ago

--- NLF/Web ---
(no open PRs)

--- NeonLaw/Web ---
#7   feat: add dashboard page    feature/dashboard    about 1 day ago
...
```

## Error Handling

- Repositories with no GitHub remote are skipped with a note
- Repositories with no open PRs display `(no open PRs)`
- If `gh` is not authenticated, an error is shown and the loop continues
- Directories that are not git repositories are silently skipped
