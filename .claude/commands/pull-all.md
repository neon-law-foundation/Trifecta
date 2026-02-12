# Pull All

## Usage

```txt
/pull-all
```

## Description

Fetch and pull the latest changes from all Git repositories in the Trifecta folder structure. This
command executes the `pull-all.sh` script which iterates through all one-level deep repositories
in NLF, NeonLaw, and Sagebrush organizations, fetching all branches, pruning deleted remote
branches, and pulling the latest changes.

## Implementation

Run the pull-all script:

```bash
~/Trifecta/NLF/Trifecta/scripts/pull-all.sh
```

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
  - AWS
  - Reporting
  - Web

## Steps

For each repository:

1. Navigate to the repository directory
2. Fetch all remote branches: `git fetch --all --prune`
3. Pull latest changes for current branch: `git pull`
4. Display current branch and status
5. Report success or any errors

## Output

The command will display progress for each repository:

```txt
📦 Pulling NLF/SagebrushStandards...
✅ Successfully updated (main branch, up to date)

...
```

## Error Handling

- If a repository has uncommitted changes, it will display a warning but continue
- If a repository doesn't exist, it will skip it and continue
- If git operations fail, it will display the error and continue to the next repository
