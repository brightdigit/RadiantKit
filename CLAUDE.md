# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RadiantKit is a Swift Package Manager library providing SwiftUI utilities across Apple platforms (iOS 15+, macOS 12+, tvOS 15+, watchOS 8+, visionOS 1+). The package contains four distinct modules with clear separation of concerns.

## Common Commands

### Building and Testing
```bash
# Build the package (Swift 6.0+ required)
swift build

# Run tests
swift test

# Build for specific platform (requires Xcode)
xcodebuild -scheme RadiantKit-Package -destination 'platform=iOS Simulator,name=iPhone 16'

# Run single test
swift test --filter RadiantKitTests.<TestClassName>/<testMethodName>
```

### Linting and Formatting
```bash
# Run full lint (formats code, adds headers, then validates)
./Scripts/lint.sh

# Format only (skip validation)
FORMAT_ONLY=1 ./Scripts/lint.sh

# Strict mode (treats warnings as errors)
LINT_MODE=STRICT ./Scripts/lint.sh

# Skip linting entirely
LINT_MODE=NONE ./Scripts/lint.sh
```

The lint script uses Mint for dependency management and runs:
- swift-format (formatting and linting)
- swiftlint (Swift style validation)
- header.sh (copyright header management)

### Documentation Generation
```bash
# Generate Swift-DocC documentation
./Scripts/swift-doc.sh

# Watch mode for documentation development
./Scripts/watch-docc.sh
```

### Development Tools
```bash
# Install Mint dependencies
mint bootstrap -m Mintfile

# Run periphery (dead code detection)
mint run periphery scan
```

## Architecture

### Module Structure

**RadiantKit** (Core Foundation)
- Property wrappers: `@AppStored`, `@DefaultWrapped` for persistent storage patterns
- View utilities: `IdentifiableView`, `IdentifiableViewBuilder` for collection-based navigation
- `Binding.map()`: Type-safe binding transformations
- Platform adapters: NSWindowDelegate wrappers for macOS
- Custom views: GuidedLabeledContent, SliderStepperView, Video, ValueTextBubble

**RadiantDocs** (depends on RadiantKit)
- Document management for SwiftUI apps
- Core protocols: `CodablePackage`, `FileTypeSpecification`, `InitializablePackage`
- `DocumentFile<FileType>`: Generic, type-safe file wrapper
- `CodablePackageDocument<T>`: FileDocument implementation for package files
- File panel abstractions and UTType integration

**RadiantPaging** (depends on RadiantKit)
- Page-based navigation UI patterns
- `PageView`: Main component for sequential page display
- Environment-based actions: `NextPageAction`, `PreviousPageAction`, `CancelPageAction`
- `PageNavigationAvailability`: Controls which navigation buttons appear
- Integrates with `IdentifiableView` from RadiantKit

**RadiantProgress** (independent, depends on swift-log for Linux)
- Progress tracking for file operations and downloads
- `ProgressOperation<ValueType>`: Protocol for any progress-reporting operation
- `DownloadOperation`: Observable implementation with URLSession integration
- `FileOperationProgress`: SwiftUI-friendly wrapper for any ProgressOperation
- `ObservableDownloader`: Combines Observation and Combine patterns

### Key Architectural Patterns

**Property Wrappers**
- `AppStored` protocol defines key-based storage contracts
- `DefaultWrapped` extends AppStored with default value support
- UserDefaults extensions provide type-safe retrieval

**Generic Type Systems**
- `DocumentFile<FileType: FileTypeSpecification>`: Type-safe file handling
- `ProgressOperation<ValueType: BinaryInteger & Sendable>`: Flexible progress reporting
- Extensive use of generics to prevent runtime errors

**Observable/Reactive**
- `@Observable` macro for iOS 17+ reactive state
- MainActor isolation throughout for UI thread safety
- Sendable conformance for cross-actor communication

**Protocol-Based Design**
- Interface segregation (small, focused protocols)
- Protocol extensions for shared functionality
- Generic constraints for type safety

**SwiftUI Environment Integration**
- Page navigation actions injected via environment
- Custom environment keys for cross-view communication

### Module Dependencies

```
RadiantKit (foundation)
   ↑         ↑
   |         |
   |         |
RadiantDocs  RadiantPaging

RadiantProgress (independent)
```

## Swift 6 & Experimental Features

This project uses Swift 6.0 with multiple experimental features enabled:
- AccessLevelOnImport
- BitwiseCopyable
- IsolatedAny
- MoveOnlyPartialConsumption
- NestedProtocols
- NoncopyableGenerics
- TransferringArgsAndResults
- VariadicGenerics
- FullTypedThrows (upcoming)
- InternalImportsByDefault (upcoming)

Code must be compatible with strict concurrency checking and Sendable requirements.

## Code Style

### Formatting
- Uses swift-format (v600.0.0) with configuration in `.swift-format`
- SwiftLint (v0.58.0) with rules in `.swiftlint.yml`
- All source files require copyright headers (managed by `Scripts/header.sh`)

### Concurrency
- All UI components are `@MainActor` isolated
- Closures crossing actor boundaries must be `@Sendable`
- Use `nonisolated` sparingly and only when necessary

### Naming Conventions
- Protocols use descriptive nouns (CodablePackage, ProgressOperation)
- Generic type parameters use full words (FileType, ValueType)
- Environment keys follow pattern: `<Action>Key` (NextPageKey, PreviousPageKey)

## Testing

Tests are located in `Tests/RadiantKitTests/`. The CI pipeline runs tests across:
- Ubuntu (Swift 6.0, 6.1, nightly 6.2)
- macOS/iOS/tvOS/watchOS/visionOS simulators with Xcode 16.1 and 16.4

When adding features:
1. Add tests to RadiantKitTests targeting the appropriate module
2. Ensure tests pass on both macOS and Linux (note: RadiantProgress uses swift-log on Linux)
3. CI enforces strict code coverage requirements via Codecov

## Platform Support

Minimum deployment targets:
- iOS 15.0 / iPadOS 15.0
- macOS 12.0
- tvOS 15.0
- watchOS 8.0
- visionOS 1.0
- Mac Catalyst 15.0

Platform-specific code should use `#if canImport()` or `#if os()` directives.

## Adding New Modules

If creating a new target:
1. Add to `Package.swift` products and targets arrays
2. Apply `swiftSettings` for experimental features
3. Update module dependency graph (RadiantKit as foundation, others can depend on it)
4. Add corresponding test target
5. Update `.github/workflows/RadiantKit.yml` if platform-specific testing needed
