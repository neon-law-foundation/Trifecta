# Refresh Trifecta

## Usage

```txt
/refresh-trifecta
```

## Description

Check all Git repositories in the Trifecta folder structure for merged pull requests. For any
repository with a merged PR on the current branch, clean it up by checking out main, pulling the
latest changes, and deleting the merged branch.

## Repositories

The command will process all repositories in:

- **NLF/** - Neon Law Foundation repositories
  - SagebrushStandards
  - Trifecta
  - Web
- **NeonLaw/** - NeonLaw repositories
  - API
  - Web
- **Sagebrush/** - Sagebrush Services repositories
  - API
  - Apple
  - ScheduledReporting
  - Web

## Steps

For each repository:

1. Navigate to the repository directory
2. Get the current branch name
3. If on `main`, skip to fetch/pull only
4. Check if there's a PR for the current branch using `gh pr list`
5. If the PR is **MERGED**:
   - Checkout the `main` branch: `git checkout main`
   - Set upstream if needed: `git branch --set-upstream-to=origin/main main`
   - Pull latest changes: `git pull`
   - Delete the merged branch: `git branch -d <branch-name>`
6. If the PR is **OPEN** or no PR exists, report status but take no action
7. For repos already on `main`, just fetch and pull latest

## Output

After processing all repositories, display a summary table:

```txt
| Repository                  | Branch            | PR Status | Action                                      |
|-----------------------------|-------------------|-----------|---------------------------------------------|
| Sagebrush/ScheduledReporting | add-ci-workflow   | MERGED    | Checked out main, pulled, deleted branch    |
| Sagebrush/Apple             | add-ci-workflow   | MERGED    | Checked out main, pulled, deleted branch    |
| NLF/Trifecta                | docs/enforce-pr   | OPEN      | Skipped - PR not yet merged                 |
| NeonLaw/API                 | main              | -         | Already on main, pulled latest              |
```

The table should show:

- **Repository**: Organization/RepoName format
- **Branch**: The branch that was checked (before any action)
- **PR Status**: MERGED, OPEN, or "-" if on main/no PR
- **Action**: What was done or why it was skipped

## Error Handling

- If a repository has uncommitted changes, display a warning and skip cleanup
- If the branch cannot be deleted (e.g., unmerged commits), display a warning
- If git operations fail, display the error and continue to the next repository
- Always ensure upstream tracking is set for the main branch before pulling

## Safety

This command is safe because:

- It only deletes local branches that have been merged via PR
- Uses `git branch -d` (not `-D`) which refuses to delete unmerged branches
- Checks PR status via GitHub API before taking any action
- Does not force-push or modify remote branches
- Skips repositories with uncommitted changes
