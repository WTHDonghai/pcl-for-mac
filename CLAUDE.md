# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PCL.Mac is an unofficial macOS port of [Plain Craft Launcher (PCL)](https://github.com/Meloong-Git/PCL), a Minecraft launcher. Built entirely with SwiftUI, it supports macOS 12.0+ on both Intel and Apple Silicon.

## Build & Development

**Requirements:** macOS 14.5+, Xcode 16+

```bash
# Build (from project root)
xcodebuild -project PCL.Mac.xcodeproj -scheme PCL.Mac build

# Run tests
xcodebuild -project PCL.Mac.xcodeproj -scheme PCL.Mac -testPlan PCL.Mac.xctestplan test

# Run a single test file
xcodebuild -project PCL.Mac.xcodeproj -scheme PCL.Mac -testPlan PCL.Mac.xctestplan -only-testing:PCL.Mac.Tests/<TestClassName> test
```

Tests run with `PCL_MAC_TESTING=1` environment variable set.

## Architecture

The project has two main targets:

- **PCL.Mac** — SwiftUI app (UI layer): Views, ViewModels, Components, Managers
- **PCL.Mac.Core** — Business logic framework (imported as `Core`): Services, Models, Utils, Tasks

### Key Patterns

**MVVM with ObservableObject:** ViewModels and Managers use `ObservableObject` with `@Published` properties. Views observe them via `@ObservedObject` or `@StateObject`.

**Singleton Managers:** Most managers use `static let shared` pattern (e.g., `AppRouter.shared`, `TaskManager.shared`, `HintManager.shared`).

**Navigation:** `AppRouter` manages a navigation stack of `AppRoute` enums. Routes define both root pages (launch, download, multiplayer, settings, more) and sub-pages.

**Task System:** `MyTask<Model>` orchestrates sequential subtask groups. Subtasks with the same `ordinal` run concurrently; different ordinals run sequentially. Use `TaskManager.shared.execute(task:)` to run tasks with UI feedback.

**Logging:** Use global functions `log()`, `warn()`, `err()`, `debug()` (defined in `LogManager.swift`). These log to both console and file.

**Hints:** Call global `hint("message", type: .info/.finish/.critical)` for toast-style notifications.

**Error Handling:** Define domain-specific errors in `PCL.Mac.Core/Utils/Errors.swift`. Use `SimpleError` for ad-hoc errors.

### Important Files

- `PCL.Mac/App/AppRouter.swift` — Navigation system and route definitions
- `PCL.Mac/Views/ContentView.swift` — Root view with sidebar, overlays, and drag-drop handling
- `PCL.Mac/Views/Sidebar.swift` — `Sidebar` protocol (all sidebars implement `width` property)
- `PCL.Mac.Core/Task/MyTask.swift` — Task orchestration system
- `PCL.Mac.Core/Utils/URLConstants.swift` — All file system paths
- `PCL.Mac/App/LauncherConfig.swift` — Persistent configuration (JSON-backed)

## Code Conventions

- UI strings and comments are in **Simplified Chinese**
- The `Core` module is imported explicitly in files that use it: `import Core`
- Custom UI components are prefixed with `My` (e.g., `MyButton`, `MyCard`, `MyText`, `MyLoading`)
- `PCL.Mac.Core/` is MIT licensed separately from the main project
- When reviewing PRs: use Simplified Chinese, flag spelling errors, allow `public` access in `internal`/`private` classes
