# Next Prompt

## Usage

```txt
/next-prompt
```

## Description

Analyzes the current Claude Code session context and generates an optimized prompt to continue work in a new session. The prompt is automatically copied to your clipboard, ready to paste into a fresh Claude Code session.

This is useful when:
- Approaching context window limits
- Wanting to start fresh while maintaining continuity
- Needing to switch sessions but preserve progress tracking

## Behavior

When invoked, this command will:

1. **Analyze Current Context:**
   - Review conversation history to identify the main task(s)
   - Check for any active todos or roadmap items
   - Identify recent file changes and work in progress
   - Note any important decisions or architectural choices made
   - Capture any blockers or pending questions

2. **Generate Continuation Prompt:**
   - Create a concise summary of what's been accomplished
   - Identify the current state and next steps
   - Include relevant file paths and context
   - Preserve important decisions and constraints
   - List any pending todos or roadmap items

3. **Copy to Clipboard:**
   - Format the prompt for optimal clarity
   - Copy to system clipboard using `pbcopy`
   - Confirm the prompt is ready to use

## Output Format

The generated prompt will follow this structure:

```
Continuing work on [main task/feature].

**Context:**
- [Summary of what's been done so far]
- [Key decisions made]
- [Important files/locations]

**Current State:**
- [What's working]
- [What's in progress]
- [Any blockers or issues]

**Next Steps:**
- [Immediate next action]
- [Remaining todos or roadmap items]

**Additional Notes:**
- [Any important constraints or preferences]
- [Relevant file paths or references]
```

## Implementation Notes

- The prompt should be **concise** (ideally 200-400 words) to leave room for new work
- Focus on **actionable information** rather than detailed history
- Include **specific file paths** when relevant
- Preserve **architectural decisions** and patterns being followed
- Highlight any **blockers** or **questions** that need resolution
