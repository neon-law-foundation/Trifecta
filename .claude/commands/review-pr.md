# Review PR

## Usage

```txt
/review-pr
```

Review a PR and automatically fix all failing tests, ensuring compatibility with both macOS and Linux platforms.

## 🚨 CRITICAL: macOS/Linux Platform Parity

**⚠️ GitHub Actions runs on Linux, local development runs on macOS - EVERY fix must consider both platforms!**

### Platform Difference Checklist

- **Foundation**: Some Foundation APIs differ between macOS/Linux
- **File Paths**: Linux uses case-sensitive paths, macOS typically doesn't
- **System Libraries**: Not all system libraries available on both platforms
- **Process APIs**: Process spawning and signals differ
- **Network Stack**: Socket behavior and DNS resolution can vary
- **Timezones**: Different timezone database locations

### When Platform-Specific Code is Necessary

If a test fundamentally cannot work on Linux (e.g., requires macOS-specific APIs), disable it for CI with appropriate guards:
- Use `#if !os(Linux)` for macOS-only code
- Use `#if os(Linux)` for Linux-specific workarounds
- Check for `Environment.get("CI")` to skip tests in CI environment
- **ALWAYS** document why the test is platform-specific with a comment

## Common Platform-Specific Issues & Solutions

### Issue: URLSession/URLRequest differences

- **macOS**: Full URLSession implementation
- **Linux**: Limited URLSession, may need FoundationNetworking import
- **Fix**: `#if canImport(FoundationNetworking) import FoundationNetworking #endif`

### Issue: FileManager path handling

- **macOS**: Case-insensitive by default
- **Linux**: Always case-sensitive
- **Fix**: Always use exact case in file paths

### Issue: Date/TimeZone handling

- **macOS**: Uses system timezone database
- **Linux**: Uses tzdata package (must be installed)
- **Fix**: Use UTC for tests or mock timezone data

### Issue: Process/Task APIs

- **macOS**: Process class fully available
- **Linux**: Some Process features missing
- **Fix**: Use conditional compilation or simpler process spawning

## Steps

1. **Analyze GitHub Actions failures first**: Use `gh pr checks` and `gh run view <run-id> --log-failed` to identify the
   root cause
   - Look specifically for:
     - `connectionRequestTimeout` errors (database connection pool issues)
     - Memory allocation failures
     - Platform-specific compilation errors
     - Test timeout issues
     - Resource exhaustion problems

2. **Determine failure type**:
   - **Build errors**: Compilation failures, missing dependencies, platform issues
   - **Test errors**: Failed assertions, runtime errors in tests

3. **If BUILD ERROR**: Continue with build analysis and fixes
   - **CRITICAL: Run `swift build` locally** to check for compilation errors that may be caused by cross-platform issues
     (GitHub Actions runs on Linux, local development runs on macOS). Specifically look for:
     - macOS-only libraries or frameworks (like Foundation components that don't work on Linux)
     - Platform-specific file paths or system calls
     - Dependencies that aren't available on Linux Swift
     - Import statements that work on macOS but fail on Linux
   - Fix build issues systematically using platform-specific code when necessary

4. **If TEST ERROR**: Collect test failures and STOP
   - **Collect all failing tests**: Use `swift test` or review CI logs to gather complete list of test failures
   - **Document test failure details**: Include test names, error messages, and failure context
   - **STOP and present to developer**: Show the failing tests with their error messages
   - **WAIT for developer plan**: Do not attempt fixes until developer provides specific guidance on how to address the
     test failures

5. **After receiving developer's plan (TEST ERRORS ONLY)**:
   - **Database Connection Pool Analysis**: If seeing `connectionRequestTimeout` errors:
     - Check for database connection leaks in test code
     - Verify proper connection cleanup in test teardown methods
     - Consider database connection pool configuration (max connections, timeout settings)
     - Look for tests that don't properly close database resources
   - **Memory and Resource Management**: For memory-related failures:
     - Use Swift test flags to limit memory usage: `--jobs 1`, `--no-parallel`
     - Consider environment variables: `SWIFT_MAX_MEMORY_MB`, `MALLOC_CONF`
     - Remove custom memory profiling scripts that may interfere with standard Swift testing
     - Run tests with fewer parallel processes to reduce memory pressure
   - **Fix root causes systematically**:
     - **Database connection timeouts**: Fix connection pool configuration and test cleanup
     - **Platform compatibility**: Use conditional compilation (#if os(macOS)) when needed
     - **Memory issues**: Optimize test execution order and resource cleanup
     - **Resource leaks**: Ensure proper cleanup in test teardown methods

6. **Test execution strategy**:
   - Run tests with `swift test` to prevent resource conflicts
   - Use `swift test --filter [TestName]` for targeted testing after fixes
   - Avoid custom test execution scripts that may interfere with Swift's memory management

7. **Verify fixes**:
   - Run full test suite locally: `swift test`
   - Ensure proper resource cleanup between tests
   - Verify cross-platform compatibility for any platform-specific fixes

8. **Clean up and commit**:
   - Remove any problematic custom test scripts
   - Clean up any existing roadmap issues by marking them as complete.
   - Commit changes with descriptive message detailing the root cause and fix

## Platform Detection Quick Reference

```swift
// Compile-time platform detection
#if os(macOS)
    // macOS-only code
#elseif os(Linux)
    // Linux-only code
#endif

// Runtime CI detection
if ProcessInfo.processInfo.environment["CI"] != nil {
    // Running in CI environment (GitHub Actions)
}

// Combined platform + CI check
#if os(Linux) || os(macOS)
    if ProcessInfo.processInfo.environment["CI"] == nil {
        // Local development (not CI)
    }
#endif

// Import platform-specific modules
#if canImport(FoundationNetworking)
    import FoundationNetworking  // Linux needs this for URLSession
#endif
```

## Remember: Test Locally on Both Platforms

When possible, test your fixes on both platforms:
- **macOS**: `swift test` (local development)
- **Linux**: Use Docker: `docker run --rm -v "$PWD":/app -w /app swift:latest swift test`
