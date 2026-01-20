# Check CI

## Usage

```txt
/check-ci [PR_NUMBER]
```

## Description

Check GitHub Actions CI status for a pull request and display any failures with
their logs. If no PR number is provided, checks the PR associated with the
current branch.

## Steps

1. **Determine the PR to check**:

   - If `PR_NUMBER` argument is provided, use that
   - Otherwise, get the PR for the current branch:

     ```bash
     gh pr list --head $(git branch --show-current) --state open --json number -q '.[0].number'
     ```

   - If no PR found, report error and exit

1. **Get PR check status**:

   ```bash
   gh pr checks $PR_NUMBER
   ```

   - If all checks pass, report success and exit
   - If any checks fail, continue to get details

1. **For each failed check, get the workflow run ID**:

   ```bash
   gh pr checks $PR_NUMBER --json name,state,link --jq '.[] | select(.state == "FAILURE")'
   ```

   - Extract the run ID from the link URL (format:
     `.../actions/runs/{RUN_ID}/job/{JOB_ID}`)

1. **Get failed job details**:

   ```bash
   gh api repos/{owner}/{repo}/actions/runs/{RUN_ID}/jobs --jq '.jobs[] | select(.conclusion == "failure") | {name: .name, steps: [.steps[] | select(.conclusion == "failure") | .name]}'
   ```

1. **Get failed step logs**:

   ```bash
   gh run view $RUN_ID --log-failed
   ```

   - Parse the output to extract relevant error messages
   - Display a summary of what failed and why

## Output Format

Display results in this format:

```txt
## CI Status for PR #XX

### Failed Checks

#### Check Name: {check_name}
**Status**: Failed
**Run ID**: {run_id}
**Failed Steps**:
- {step_name_1}
- {step_name_2}

**Error Summary**:
{Extracted error messages from logs}

### Suggested Fixes

{Based on the error messages, suggest what might fix the issue}
```

## Example Commands Used

```bash
# Get PR checks
gh pr checks 123

# Get workflow run details
gh api repos/owner/repo/actions/runs/123456789/jobs

# Get failed logs
gh run view 123456789 --log-failed

# Get specific job logs
gh api repos/owner/repo/actions/jobs/123456789/logs
```

## Error Handling

- If `gh` CLI is not authenticated, prompt user to run `gh auth login`
- If PR doesn't exist, report error with helpful message
- If no workflow runs found, report that CI hasn't run yet
- Truncate very long log output to keep response readable (first 100 lines of
  each failed step)
