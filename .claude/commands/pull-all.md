# Pull All

## Usage

```txt
/pull-all
```

## Description

Fetch and pull the latest changes from all Git repositories in the Trifecta folder structure, then
re-run `setup.sh` to refresh symlinks and clone any missing repositories. Executes the
`pull-all.sh` script which iterates through all one-level deep repositories in NLF, NeonLaw, and
Sagebrush organizations, fetching all branches, pruning deleted remote branches, and pulling the
latest changes. `setup.sh` is idempotent — it only clones repositories that do not already exist
and always refreshes the `CLAUDE.md` and `.claude` symlinks.

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

After pulling all repositories:

1. Re-run `setup.sh` to refresh `CLAUDE.md` and `.claude` symlinks
2. Clone any repositories listed in `setup.sh` that are missing from `~/Trifecta`

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
