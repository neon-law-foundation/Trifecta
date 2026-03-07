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
      remote=$(git -C "$repo" remote get-url origin 2>/dev/null | sed 's|.*github.com[:/]||;s|\.git$||')
      if [ -z "$remote" ]; then
        echo "(no GitHub remote)"
        continue
      fi
      prs=$(gh pr list --state open --repo "$remote" --json number,title,headRefName,createdAt 2>/dev/null)
      if [ -z "$prs" ] || [ "$prs" = "[]" ]; then
        echo "(no open PRs)"
      else
        echo "$prs" | jq -r '.[].number' | while read -r pr_num; do
          title=$(echo "$prs" | jq -r ".[] | select(.number == $pr_num) | .title")
          branch=$(echo "$prs" | jq -r ".[] | select(.number == $pr_num) | .headRefName")
          echo "#$pr_num  $title  [$branch]"
          checks=$(gh pr checks "$pr_num" --repo "$remote" 2>/dev/null)
          if [ -z "$checks" ]; then
            echo "  (no checks)"
          else
            echo "$checks" | while IFS=$'\t' read -r check_name check_state rest; do
              case "$check_state" in
                pass)    dot="🟢" ;;
                fail)    dot="🔴" ;;
                *)       dot="🟡" ;;
              esac
              echo "  $dot $check_name"
            done
          fi
        done
      fi
    fi
  done
done
```

## Steps

1. Discover all directories two levels deep under `~/Trifecta`
2. Filter to those containing a `.git` folder
3. For each git repository, resolve the GitHub remote URL
4. Run `gh pr list --state open` targeting the resolved repo
5. For each open PR, run `gh pr checks` to get CI check results
6. Display each check by name with 🟢 (pass), 🔴 (fail), or 🟡 (pending)

## Output

```txt
--- NLF/Harness ---
#34  docs: establish terminology parity  [docs/terminology-parity]
  🟢 enable-auto-merge
  🟢 tests (macos-26)
  🟡 tests (ubuntu-latest)

--- Sagebrush/AWS ---
#33  docs: add NLF Web infrastructure plan  [docs/add-nlf-web-infrastructure-plan]
  🔴 tests
  🟢 enable-auto-merge
  🟢 lint-markdown

--- NLF/Web ---
(no open PRs)
...
```

## Error Handling

- Repositories with no GitHub remote are skipped with a note
- Repositories with no open PRs display `(no open PRs)`
- PRs with no checks configured display `(no checks)`
- If `gh` is not authenticated, an error is shown and the loop continues
- Directories that are not git repositories are silently skipped
