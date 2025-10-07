# Code Feature Implementation

## Usage

```txt
/code FEATURE_NAME DESCRIPTION
```

Where `FEATURE_NAME` is the name for the new feature (e.g., `UserAuthentication`, `BlogManagement`).

Where `DESCRIPTION` is a brief description of the feature to implement.

## Steps

This command orchestrates the implementation of new features through a structured, multi-agent approach. Follow these steps:

1. **Planning Phase**: Ask intelligent questions to understand requirements
2. **Database Layer**: Use database-developer agent for data foundation
3. **Feature Layer**: Use feature-developer agent for API/business logic
4. **Testing Phase**: Use tester agent to ensure quality

## Planning Questions

Before implementation, ask these 5 intelligent questions to understand the feature requirements:

### 1. Data Model Requirements

"What data entities need to be created or modified? Please describe the fields,
relationships, and any business constraints."

### 2. API Interface Design

"What API endpoints are needed? Describe the request/response patterns, authentication
requirements, and integration points."

### 3. Business Logic Complexity

"What business rules and validation logic need to be implemented? Are there any complex
workflows or state transitions?"

### 4. Dependencies and Integration

"What existing systems, services, or external APIs does this feature need to integrate
with?"

### 5. Testing and Quality Requirements

"What are the key success criteria and edge cases that need to be tested? Are there
performance or security considerations?"

## Implementation Workflow

### Phase 1: Database Foundation (if data changes needed)

Use the `database-developer` agent to:
- Implement the 4-part data pattern (Migration, Model, Repository, Seeds)
- Create database schema with proper constraints
- Build repository layer with full CRUD operations
- Provide seed data for development/testing

### Phase 2: Feature Implementation

Use the `feature-developer` agent to:
- Build Vapor controllers and routes
- Implement OpenAPI-first API design
- Create service layer with business logic
- Handle request/response validation
- Integrate with database layer

### Phase 3: Quality Validation

Use the `tester` agent to:
- Run `swift test` and analyze failures
- Fix failing tests (no skipping allowed)
- Validate quality compliance
- Ensure exit code 0 for all tests

## Agent Coordination

### Database → Feature Handoff

The database-developer agent completes when:

- ✅ All 4 components implemented (Migration, Model, Repository, Seeds)
- ✅ `swift test` passes for data layer
- ✅ Database schema applies/reverts cleanly

### Feature → Tester Handoff

The feature-developer agent completes when:

- ✅ All API endpoints implemented
- ✅ Business logic complete
- ✅ Code compiles without warnings
- ✅ OpenAPI integration working

### Final Completion

The tester agent completes when:

- ✅ All tests pass with exit code 0
- ✅ Quality standards met
- ✅ No compilation warnings
- ✅ Real database tests passing

## Quality Standards

All implementations must follow the CLAUDE.md guidelines:

- **Swift-only codebase** (except .sql, .md, assets)
- **Protocol-oriented design** with dependency injection
- **Swift Testing framework** (never XCTest)
- **Real database testing** (no mocks)
- **Modern concurrency** with actors and async/await
- **OpenAPI-first** API development
- **Clean code** with no trailing whitespace

## Error Handling

If any phase fails:
1. **Database issues**: Fix schema, constraints, or repository errors
2. **Feature issues**: Resolve API, business logic, or integration problems  
3. **Test failures**: Debug and fix without skipping tests
4. **Quality issues**: Address warnings, formatting, or compliance problems

## Success Criteria

A feature implementation is complete when:
1. 🗄️ **Database layer** is solid and tested
2. 🚀 **Feature layer** implements all requirements
3. ✅ **All tests pass** with exit code 0
4. 📋 **Quality standards** are met
5. 🔄 **Integration** works end-to-end

The `/code` command ensures systematic, high-quality implementation through coordinated
specialist agents, following the layered architecture principle of database foundation
first, then feature implementation, then validation.
