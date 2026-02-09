# Sync All Branches

## Usage

```txt
/sync-all-branches
```

## Description

Iterate through every repository in the Trifecta folder structure (two levels deep) and for each
branch in each repository, checkout the branch and run `git pull --rebase` to sync with its remote
tracking branch. This ensures all local branches across all repositories are up-to-date with their
remote counterparts.

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
  - Reporting
  - Web

## Steps

For each repository:

1. Navigate to the repository directory
2. Fetch all remote branches: `git fetch --all --prune`
3. Get list of all local branches
4. For each local branch:
   - Checkout the branch: `git checkout <branch>`
   - Pull and rebase: `git pull --rebase`
   - Display status and any changes
5. Return to the original branch when done
6. Report success or any errors

## Output

The command will display progress for each repository and branch:

```txt
📦 Processing NLF/SagebrushStandards...
  🔀 Syncing branch: main
  ✅ Successfully rebased (3 commits pulled)
  🔀 Syncing branch: feature/auth
  ✅ Successfully rebased (up to date)

...
```

## Error Handling

- If a branch has uncommitted changes, it will skip that branch and continue
- If a branch cannot be rebased due to conflicts, it will display a warning and continue
- If a repository doesn't exist, it will skip it and continue
- If git operations fail, it will display the error and continue to the next branch/repository
- The command will restore the originally checked-out branch before moving to the next repository

## Safety

This command is safe because:

- It only operates on local branches that have remote tracking branches
- Uses `--rebase` to maintain clean commit history
- Skips branches with uncommitted changes
- Does not force-push or modify remote branches
- Restores original branch state after processing each repository
