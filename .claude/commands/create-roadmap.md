# Create Roadmap

## Usage

```txt
/create-roadmap ROADMAP_NAME DESCRIPTION
```

Where `ROADMAP_NAME` is the name for the roadmap feature (e.g., `AuthRoadmap`,
`PostgresRoadmap`).

Where `DESCRIPTION` is a brief description of the roadmap.

## Writing Style

**Follow the writer agent principles** (`.claude/agents/writer.md`):

- Active voice for all task descriptions
- Front-load the action (verb first)
- Terse but complete (no filler words)
- Concrete examples over abstract descriptions

## Steps

Create a comprehensive GitHub issue with detailed implementation tasks and
sample code. Follow these steps:

1. Ensure `Plan Mode` is enabled in Claude.
2. Analyze the current codebase and user requirements to identify all tasks
  that need completion
3. **Determine required phases** based on the roadmap requirements:
   - Simple feature updates may only need 1-2 phases
   - Full-stack features typically need 3-4 phases
   - Research-heavy features may need an initial Research phase
   - Database changes require a Data phase
4. **Use the issue-creator agent** to create a GitHub issue with:
   - Title format: `[Roadmap] ROADMAP_NAME: DESCRIPTION`
   - Comprehensive task breakdown using `- [ ]` syntax for each task
   - **Sample code implementations** showing expected patterns
   - **Terse, technical syntax** for Swift developers
5. **ALWAYS include a status section** at the top with current phase, next
  steps,
   last updated date, key decisions needed, and phase tracking table
6. **ALWAYS include explicit quality requirements** stating: "After completing
   each step, run `swift test` to ensure all tests pass with exit code 0. Review
   quality standards for adherence to project standards before marking any task
   complete.
   All code must be well-documented with clear comments explaining business
   logic and
   complex implementations."
7. **Structure phases based on requirements**:
   - Phase 0 (Research) - Only if significant investigation needed
   - Phase 1 (Data) - Only if database migrations/schema changes needed
   - Phase 2 (API/Backend) - Only if server-side changes needed
   - Phase 3 (Frontend) - Only if client-side changes needed
   - Phase 4+ (Features/Enhancements) - Only if additional features beyond core
     requirement
8. For the Research phase, include a task to create a file in the `Research/`
  folder with the name of the roadmap.
   Make this instruction explicit in the GitHub issue.
9. Organize tasks within phases into logical sections (e.g., Features, Bugs,
  Infrastructure, Documentation)
10. Write each task description in declarative active voice keeping lines under
  120 characters
11. Include priority indicators for each task (High/Medium/Low) at the end of
  each checkbox item
12. **Include specific code samples** showing:
    - Package.swift dependency additions
    - Service implementations with proper Swift patterns
    - Test examples using Swift Testing framework
    - Migration patterns if database changes needed
13. **End each task description with**: "Run `swift test` and verify quality
  compliance before marking
    complete. Ensure all code is well-documented."
14. Ensure all task descriptions are specific, actionable, and follow the
  project's quality standards.
15. **Use terse, technical syntax** suitable for experienced Swift developers
16. **ALWAYS include a Phase Tracking section** with this exact template:

    ```markdown
    ## Phase Tracking

    | Phase | Status | Branch | Commits | PR | Merged |
    |-------|---------|---------|---------|-----|--------|
    | Phase 0: [Name] | ⏳ Pending | - | - | - | ❌ |
    | Phase 1: [Name] | ⏳ Pending | - | - | - | ❌ |
    | Phase 2: [Name] | ⏳ Pending | - | - | - | ❌ |
    | Phase 3: [Name] | ⏳ Pending | - | - | - | ❌ |
    | Phase 4: [Name] | ⏳ Pending | - | - | - | ❌ |

    ### Status Legend
    - ⏳ Pending: Not started
    - 🚧 In Progress: Currently being implemented
    - ✅ Complete: Implementation finished and tested
    - 🔄 Review: PR created, awaiting review/merge
    - ✅ Merged: PR merged to main

    ### Implementation Notes
    - Each phase gets its own branch: `roadmap/{issue-number}-phase-{phase-number}`
    - Each phase gets its own PR with "Related to #{issue}" (except final phase)
    - Final phase PR uses "Fixes #{issue}" to close the roadmap
    - All commits and PR links tracked in table above
    ```

17. Include commit SHA tracking in the issue template for implementation
  progress
18. Run the `/format-markdown` Claude command to ensure the markdown is
  formatted correctly.
