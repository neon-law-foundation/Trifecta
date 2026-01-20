# Commit and Push

## Usage

```txt
/commit-push
```

## Description

Commit and push the current changes to a feature branch and create a pull
request. This command ensures ALL tests pass and markdown formatting is correct
before committing. **NEVER pushes directly to main branch.**

**IMPORTANT**: This command works on the repository relevant to your current
working directory. Repositories are located two layers beneath `~/Trifecta`.
For example:

- `~/Trifecta/NLF/Standards` is a repository
- `~/Trifecta/Sagebrush/Web` is a repository

Claude Code will automatically detect which repository you're working in based
on your current directory and run all validation/test commands within that
repository context.

## Steps

1. **Check current branch and handle main branch protection**:
   - Run `git branch --show-current` to get the current branch
   - If on `main` or `master`:
     - Create a feature branch based on the changes:
       `git checkout -b feature/descriptive-name-based-on-changes`
     - Inform the user about the branch creation
   - If already on a feature branch, continue

2. **MANDATORY**: Run markdown formatting validation using
   `./scripts/validate-markdown.sh --fix` and then
   `./scripts/validate-markdown.sh` to ensure it exits with code 0.

3. **MANDATORY**: Run `CI=true swift test` to ensure ALL tests pass with exit
   code 0. If any tests fail, DO NOT proceed with commit.

4. Run `git add .` to stage all changes.

5. Create a descriptive commit message following conventional commit format.

6. Push the changes to the feature branch:
   `git push -u origin $(git branch --show-current)`

7. **Check for existing PR and create if needed**:
   - Check if a PR already exists for this branch:
     `gh pr list --head $(git branch --show-current) --state open`
   - If a PR already exists: Report the PR URL and done
   - If no PR exists: Create a PR using `gh pr create` with:
     - Descriptive title based on the commit message
     - Summary of changes in the body
     - Link to any relevant GitHub issues

8. Report the PR URL to the user.
