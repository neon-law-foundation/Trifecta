# Create Commit

## Usage

```txt
/create-commit
```

Create a commit, push to a feature branch, and ensure a PR exists. **NEVER
pushes directly to main branch.**

## Steps

1. **Check current branch and handle main branch protection**:
   - Run `git branch --show-current` to get the current branch
   - If on `main` or `master`:
     - Create a feature branch based on the changes:
       `git checkout -b feature/descriptive-name-based-on-changes`
     - Inform the user about the branch creation
   - If already on a feature branch, continue

2. Review all changes with `git status` and `git diff`

3. Stage all changes with `git add .`

4. Run `swift test` to ensure all tests pass. Do not proceed if tests fail.
   That means that `swift test` must have an exit code of 0. If tests fail, go
   back to plan mode and have a dialogue with the developer. Note: `swift test`
   can take up to 10 minutes to complete, so be patient and wait for it to
   finish.

5. Create a commit message following Conventional Commits format (e.g.,
   `feat:`, `fix:`, `docs:`, etc.)

6. Commit the changes with `git commit -m "<type>[scope]: <description>"`

7. **IMPORTANT: Check PR tagging** - If this commit is going to an existing PR
   and completes roadmap tasks, update relevant roadmaps with PR number and
   commit SHA before pushing

8. Push to the feature branch: `git push -u origin $(git branch --show-current)`

9. **Check for existing PR and create if needed**:
   - Check if a PR already exists for this branch:
     `gh pr list --head $(git branch --show-current) --state open`
   - If a PR already exists: Report the PR URL and done
   - If no PR exists: Create a PR using `gh pr create` with:
     - Descriptive title based on the commit message
     - Summary of changes in the body
     - Link to any relevant GitHub issues

10. Report the PR URL to the user.
