# Commit and Push

## Usage

```txt
/commit-push
```

## Description

Commit and push the current changes to the remote repository. This command ensures ALL tests pass and markdown
formatting is correct before committing.

**IMPORTANT**: This command works on the repository relevant to your current working directory. Repositories are
located two layers beneath `~/Code`. For example:
- `~/Code/NLF/Standards` is a repository
- `~/Code/Sagebrush/Web` is a repository
- `~/Code/ShookFamily/Web` is a repository

Claude Code will automatically detect which repository you're working in based on your current directory and run
all validation/test commands within that repository context.

## Steps

1. Check that we are not on the main branch.
2. **MANDATORY**: Run markdown formatting validation using `./scripts/validate-markdown.sh --fix` and then
   `./scripts/validate-markdown.sh` to ensure it exits with code 0.
3. **MANDATORY**: Run `CI=true swift test` to ensure ALL tests pass with exit code 0. If any tests
   fail, DO NOT proceed with commit.
4. Run `git add .` to stage all changes.
5. Create a descriptive commit message following conventional commit format.
6. Push the changes to the remote repository.
