# Review PR

## Usage

```txt
/review-pr [@ORG/REPO] [PR_NUMBER]
```

## Description

Work through a pull request's review comments end-to-end: check out the branch,
run the tests, critically evaluate every comment (from Greptile and human
reviewers alike), apply fixes, stage changes chunk by chunk with `git add -p`,
commit, push, and reply to the review.

## Steps

### 1. Determine the repository and PR number

- If `@ORG/REPO` is provided (e.g. `@NLF/Harness`), set:
  ```bash
  REPO_DIR=~/Trifecta/ORG/REPO   # strip @ and expand
  ```
- Otherwise set `REPO_DIR=.`
- If `PR_NUMBER` is not provided, resolve it from the branch:
  ```bash
  cd $REPO_DIR && \
    gh pr list --head $(git branch --show-current) --state open --json number -q '.[0].number'
  ```
- Confirm with the user: "Reviewing **ORG/REPO** PR **#N** — is that correct?"

### 2. Fetch and check out the branch

```bash
cd $REPO_DIR
BRANCH=$(gh pr view $PR_NUMBER --json headRefName -q .headRefName)
git fetch origin $BRANCH
git checkout $BRANCH
```

### 3. Run the tests

```bash
cd $REPO_DIR && swift test
```

Record the result (pass / fail count). If tests fail, report the failures
immediately and stop — do not attempt fixes without a developer-approved plan.

### 4. Fetch all review comments

```bash
cd $REPO_DIR && gh pr view $PR_NUMBER --comments
```

Also fetch inline code comments:

```bash
cd $REPO_DIR && gh api repos/{owner}/{repo}/pulls/$PR_NUMBER/comments \
  --jq '.[] | {path: .path, line: .line, body: .body, author: .user.login}'
```

### 5. Critically evaluate every comment

For **each** comment — whether from Greptile or a human reviewer:

- **Understand the concern** before agreeing with it. Greptile analyses are
  automated; they can be wrong or overly cautious.
- **Verify the claim** against the actual code. If Greptile says a variable is
  unset, check whether it is actually unset in every code path.
- **Distinguish real bugs from style notes**: prioritise correctness issues,
  then logic gaps, then polish.
- **Decide: fix, reject with explanation, or ask for clarification.** Document
  your reasoning for each.

### 6. Apply fixes

For each accepted comment:

- Make the minimal change that addresses the concern — do not refactor
  surrounding code unless necessary.
- Re-run tests after each logical group of fixes:
  ```bash
  cd $REPO_DIR && swift test
  ```

### 7. Stage changes chunk by chunk

Review every diff hunk before staging to ensure only intentional changes go in:

```bash
cd $REPO_DIR && git diff
```

Stage selectively — hunk by hunk — rather than `git add .`:

```bash
cd $REPO_DIR && git add -p
```

For each hunk, ask: "Does this hunk belong in this commit?" Accept (`y`),
skip (`n`), or split further (`s`).

### 8. Commit and push

Use a descriptive conventional commit:

```bash
cd $REPO_DIR && git commit -m "fix: address review comments on PR #N\n\n..."
cd $REPO_DIR && git push
```

### 9. Reply to the review

Post a comment on the PR summarising what was fixed and what was intentionally
left unchanged (with reasoning):

```bash
cd $REPO_DIR && gh pr review $PR_NUMBER --comment --body "..."
```

For comments that were **rejected**, explain clearly why the original code is
correct.

## Critical Evaluation Checklist

Before accepting any review comment as a real bug, verify:

- [ ] Does the reviewer's claim match the actual code at the cited location?
- [ ] Is the issue present in all code paths (not just the happy path)?
- [ ] Is the fix the reviewer suggests actually correct, or does it introduce
      a new problem?
- [ ] Does fixing it break any existing tests?
- [ ] Is the concern a real functional failure or a stylistic preference?

## Platform and Formatting Checks

After applying all fixes:

```bash
# Ensure tests still pass
cd $REPO_DIR && swift test

# Ensure formatting passes CI
cd $REPO_DIR && swift format lint --strict --recursive --parallel --no-color-diagnostics .
```

Fix any formatting violations with:

```bash
cd $REPO_DIR && swift format -i -r .
```
