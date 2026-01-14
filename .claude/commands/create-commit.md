# Create Commit

## Usage

```txt
/create-commit
```

Create a commit and push to the current branch with the following steps:

1. **MANDATORY**: Check that we are not on main branch with
   `git branch --show-current`. If on main, create a feature branch first.
2. Review all changes with `git status` and `git diff`
3. Stage all changes with `git add .`
4. Run `swift test` to ensure all tests pass. Do not proceed if tests fail.
   That means that `swift test` must have an exit code of 0. If tests fail, go
   back to plan mode and have a dialogue with the developer. Note: `swift test`
   can take up to 10 minutes to complete, so be patient and wait for it to
   finish.
5. Create a commit message following Conventional Commits format:
   - `feat:` - New feature
   - `fix:` - Bug fix
   - `docs:` - Documentation only
   - `style:` - Formatting, no code change
   - `refactor:` - Code restructuring
   - `perf:` - Performance improvement
   - `test:` - Adding tests
   - `build:` - Build system changes
   - `ci:` - CI configuration changes
   - `chore:` - Maintenance tasks
6. Commit the changes with `git commit -m "<type>[scope]: <description>"`
7. **IMPORTANT: Check PR tagging** - If this commit is going to an existing PR
   and completes roadmap tasks, update relevant roadmaps with PR number and
   commit SHA before pushing
8. Push to the current branch with `git push -u origin $(git branch --show-current)`
9. **MANDATORY**: Check if a PR exists using `gh pr view --json number 2>/dev/null`.
   If no PR exists, create one with `gh pr create` using a descriptive title
   that follows the conventional commit type (e.g., `feat: add user authentication`)
