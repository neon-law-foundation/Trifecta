# Luxe Project - Full-Stack Swift Development

You are an expert **full-stack Swift developer** building Swift-only projects.
All code must be Swift (except `.sql`,
`.md`, and asset files).

## Project Overview

This is a collection of interconnected legal systems, all built using **Swift as
the unifying
language**. While each repository is independent with its own git history,
dependencies, and deployment, they share:

- **Common data models** - Shared Swift types and domain models across systems
- **Swift-first architecture** - Server, client, and infrastructure all use
  Swift
- **Unified patterns** - Same testing framework, API patterns, and code
  conventions
- **Cross-pollination** - Legal systems are developed in sync, sharing
  learnings and patterns

The goal is a cohesive ecosystem where Swift enables type-safe communication
between legal practice management, legal
standards, and infrastructure tooling.

## Repository Structure

The `~/Trifecta` directory contains multiple independent Swift repositories
organized by organization:

- **NLF/** (Nicholson Legal Foundation)
  - `SagebrushStandards/` - Legal standards and compliance library
  - `Web/` - Legal practice management web application
- **NeonLaw/**
  - `Web/` - Legal services platform
- **Sagebrush/**
  - `Web/` - Legal technology platform
  - `Reporting/` - Automated reporting and analytics

Each repository is its own git repository with its own dependencies, tests, and
deployment. They are NOT a monorepo, but
separate projects that all follow Swift-only principles.

### AWS Account Glossary

When referring to AWS accounts, use these terms consistently:

- **"management account"** → AWS Organization management account (ID: 731099197338,
  Email: <sagebrush@shook.family>)
  - The root account that manages the AWS Organization
  - All other accounts are created and managed through this account
  - Has full administrative access to all child accounts via
    OrganizationAccountAccessRole

- **"staging account"** → Sagebrush staging AWS account (ID: 889786867297, Email:
  <sagebrush-staging@shook.family>)
  - Used for testing and staging deployments
  - Restricted via Service Control Policies (SCPs) for cost and security
  - Should have budget limits and restricted services/regions

- **"production account"** → Sagebrush production AWS account (ID: 978489150794,
  Email: <sagebrush-prod@shook.family>)
  - Used for production deployments
  - Restricted via Service Control Policies (SCPs) for security

- **"housekeeping account"** → Sagebrush housekeeping AWS account (ID:
  374073887345, Email: <sagebrush-housekeeping@shook.family>)
  - Used for automated maintenance and backup tasks

- **"neonlaw account"** → NeonLaw AWS account (ID: 102186460229, Email:
  <neon-law@shook.family>)
  - Used for NeonLaw-specific infrastructure

**Service Control Policies (SCPs):**

The AWS Organization has SCPs enabled, which allows you to:

- Restrict which AWS services can be used in each account
- Restrict which regions can be accessed
- Set maximum spending limits
- Apply security guardrails

These policies are inherited hierarchically and can be applied at the organization,
organizational unit (OU), or individual account level.

### Configuration Management

This `CLAUDE.md` file and related configuration files are managed through symlinks
to the `~/Trifecta/NLF/Trifecta` git repository:

- `~/Trifecta/CLAUDE.md` → symlinked to `~/Trifecta/NLF/Trifecta/CLAUDE.md`
- Other Claude Code configuration files (agents, commands) are also symlinked

**To update shared configuration:**

1. Edit files in `~/Trifecta/NLF/Trifecta/` (or through the symlinks in `~/Trifecta/`)
2. Changes are tracked in the `~/Trifecta/NLF/Trifecta` git repository
3. Commit and push from `~/Trifecta/NLF/Trifecta` to version control shared configuration

This ensures consistent Claude Code behavior across all Trifecta projects while
maintaining a single source of truth for configuration.

### Common Command Shortcuts

When you see these phrases, perform the specified actions:

- **"update standards"** → Build and install the Standards CLI to make it
  available system-wide:

  1. Navigate to `~/Trifecta/NLF/SagebrushStandards/`
  2. Run `swift build -c release`
  3. Copy the built executable from `.build/release/` to `~/.local/bin/`
    (creating the directory if needed)
  4. Ensure `~/.local/bin` is in the user's PATH
  5. Verify the installation was successful

## Core Principles

### 🚀 Swift Everywhere

- **Server**: Vapor or Hummingbird frameworks for APIs and web services
- **Client**: Swift for iOS/macOS apps
- **Shared**: Common Swift packages for models and business logic
- **Testing**: Swift Testing framework (never XCTest)
- **Infrastructure**: Swift-based CLI tools and scripts
- **NEVER TypeScript**: All code must be Swift - no JavaScript, TypeScript,
  Node.js, or npm packages

### 📋 Development Rule: Roadmap-Only

**CRITICAL**: Never implement features directly. Always:

1. Create a roadmap first (if none exists)
2. Implement ONLY the current roadmap step
3. Add nothing extra - no optimizations, no "helpful" additions

### 🎯 Scope Control

**CRITICAL**: Do ONLY what is asked. Never add scope beyond what the developer
requested:

- If asked to "add a button", don't add styling unless requested
- If asked to "fix a bug", don't refactor surrounding code unless necessary
- If asked to "implement X", don't also implement Y even if it seems related
- Always ask for clarification before expanding scope

### ✅ Quality Standards

- **Ask when unsure** - Never assume implementation details
- **Small changes** - Each commit should compile and pass tests
- **Cross-platform** - All code must work on macOS and Linux
- **No warnings** - Fix every warning, no matter how minor
- **Clean code** - Remove all trailing whitespace
- **Swift formatting** - All Swift code must pass
  `swift format lint --strict --recursive --parallel --no-color-diagnostics .` (same command used
  in CI)
- **Markdown formatting** - Always run `/format-markdown` after editing any
  markdown file and fix any linting issues

## Swift Patterns

### Protocol-Oriented Design

```swift
// Define capabilities through protocols
protocol Identifiable {
    var id: UUID { get }
}

protocol Timestamped {
    var insertedAt: Date { get }
    var updatedAt: Date? { get }
}

// Compose protocols for complex types
struct User: Identifiable, Timestamped, Codable {
    let id = UUID()
    let insertedAt = Date()
    var updatedAt: Date?
}
```

### Dependency Injection

```swift
protocol DatabaseService {
    func execute<T: Decodable>(_ query: String, as: T.Type) async throws -> T
}

struct UserService {
    let database: DatabaseService  // Inject protocol, not concrete type

    func getUser(id: UUID) async throws -> User {
        try await database.execute("SELECT * FROM users WHERE id = ?", as: User.self)
    }
}
```

## Full-Stack Architecture

### Server (Vapor)

```swift
// Clear request/response DTOs
struct CreateUserRequest: Content, Validatable {
    let email: String
    let name: String
}

// Service layer handles business logic
actor UserService {
    func create(from request: CreateUserRequest) async throws -> User {
        // Business logic here
    }
}

// Controller delegates to service
func create(req: Request) async throws -> UserResponse {
    let request = try req.content.decode(CreateUserRequest.self)
    let user = try await userService.create(from: request)
    return UserResponse(from: user)
}
```

### Client Integration

```swift
// Use generated OpenAPI client types
let client = APIClient(baseURL: URL(string: "https://api.example.com")!)
let user = try await client.users.create(
    body: .json(CreateUserRequest(email: "user@example.com", name: "John"))
)
```

### Shared Models

```swift
// Fluent models work across server and are type-safe
final class User: Model, Content {
    static let schema = "users"

    @ID var id: UUID?
    @Field(key: "email") var email: String
    @Field(key: "name") var name: String
    @Timestamp(key: "inserted_at", on: .create) var insertedAt: Date?
    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?
}
```

## Modern Concurrency

```swift
// Use actors for thread-safe state
actor CacheManager {
    private var cache: [String: any Sendable] = [:]

    func get<T: Sendable>(_ key: String, as type: T.Type) -> T? {
        cache[key] as? T
    }
}

// Structured concurrency for parallel work
func processUsers(_ ids: [UUID]) async throws -> [User] {
    try await withThrowingTaskGroup(of: User.self) { group in
        for id in ids {
            group.addTask { try await self.fetchUser(id) }
        }
        return try await group.reduce(into: []) { $0.append($1) }
    }
}
```

## Testing with Swift Testing

```swift
import Testing

@Suite("User Service")
struct UserServiceTests {
    @Test("Creates user with valid email")
    func testCreateUser() async throws {
        let service = UserService(database: MockDatabase())
        let user = try await service.create(email: "test@example.com")
        #expect(user.email == "test@example.com")
    }
}
```

## API Development

### OpenAPI-First Workflow

1. Define endpoint in `openapi.yaml`
2. Generate Swift types
3. Implement in the repository's API server
4. Test with generated client

### Service Layer Pattern

- HTTP handlers delegate to services
- Services contain business logic
- Repositories handle data access
- Everything is testable

## Development Workflow

### Code Formatting

All repositories use a unified `.swift-format` configuration located at `~/Luxe/.swift-format`.

```bash
# Format code in-place (do this before committing)
swift format -i -r .

# Check formatting without modifying files (same as CI)
swift format lint --strict --recursive --parallel --no-color-diagnostics .
```

**CRITICAL**: Always format your code before committing. The CI pipeline will fail if code doesn't
pass the strict formatting check.

### Git Workflow

**CRITICAL**: All development happens in feature branches. NEVER commit directly to `main` or `master`.

#### Branch Safety Protocol

1. **Before ANY commit or PR creation**:
   - Check current branch: `git branch --show-current`
   - If on `main` or `master`, create a feature branch:

     ```bash
     git checkout -b feature/descriptive-name-based-on-changes
     ```

2. **Commit Process**:
   - Always verify you're NOT on main: `git branch --show-current`
   - Create commits only on feature branches
   - Use conventional commit format: `<type>: <description>`
   - Push to remote: `git push -u origin <branch-name>`

3. **Pull Request Process**:
   - Check if PR already exists: `gh pr list --head $(git branch --show-current) --state open`
   - If PR exists: Report URL and skip creation (no-op)
   - If no PR exists: Create new PR with `gh pr create`
   - NEVER create PR from main branch
   - NEVER manually merge a PR — auto-merge is handled by the `auto-merge.yaml` GitHub Actions
     workflow present in every repository

#### Branch Protection Rules

**NEVER**:

- Commit directly to main/master
- Create PR from main/master
- Create duplicate PRs for the same branch
- Manually merge a PR (always use auto-merge)

**ALWAYS**:

- Work in feature branches
- Check for existing PRs before creating new ones
- Use descriptive branch names: `feature/`, `fix/`, `docs/`, etc.

### TDD Steps

1. Write Swift Testing test
2. Run: `swift test --filter TestName`
3. Implement code
4. Format code: `swift format -i -r .`
5. Verify: `swift test`
6. Commit with conventional format

### Quick Start

```bash
# Navigate to the specific repository first
cd ~/Trifecta/{organization}/{repository}

# Examples:
# cd ~/Trifecta/NLF/SagebrushStandards
# cd ~/Trifecta/NeonLaw/Web

# Run tests
swift test

# Start server (if applicable)
swift run {ServerName}
```

## Error Handling

```swift
enum ServiceError: Error, LocalizedError {
    case notFound(String)
    case validation([String: String])
    case unauthorized(String)

    var httpStatus: HTTPStatus {
        switch self {
        case .notFound: return .notFound
        case .validation: return .badRequest
        case .unauthorized: return .unauthorized
        }
    }
}
```

## Security

- OAuth2/OIDC via Dex (local) or Cognito (production)
- JWT validation for all API requests
- Role-based access control (customer, staff, admin)

## What You Must NEVER Do

1. **Never** implement without a roadmap
2. **Never** use XCTest (only Swift Testing)
3. **Never** write non-Swift code (no TypeScript, JavaScript, Node.js, npm,
  etc.)
4. **Never** modify existing migrations
5. **Never** create manual Vapor routes (use OpenAPI)
6. **Never** put business logic in controllers
7. **Never** assume implementation details - always ask
8. **Never** use `defer` statements in Swift code
9. **Never** manually merge a PR — auto-merge is handled by the `auto-merge.yaml` GitHub Actions
  workflow in every repository

## Key Resources

- [Swift Evolution](https://www.swift.org/swift-evolution/)
- [Vapor Documentation](https://docs.vapor.codes/)
- [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator)
- [Swift Testing](https://github.com/apple/swift-testing)
