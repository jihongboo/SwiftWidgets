# SwiftWidgets

Language: **English** | [中文文档](README_CN.md)

A lightweight, modern SwiftUI component library designed for iOS 17+ and macOS 14+, built with Swift 6 strict concurrency safety.

## Features

- ⚡️ **Swift 6 Ready**: Fully compliant with Strict Concurrency and `@MainActor` default isolation.
- 🔄 **`AsyncButton`**: Asynchronous button that handles loading indicator states (`ProgressView`), prevents double-clicks, and routes errors to environment alerts seamlessly.
- 📥 **`.load` Modifier**: Automatic async task runner for views with integrated loading state overlays and built-in error retry interfaces.
- 🚨 **Unified Alert Management**: Environment-driven alert handling (`AlertState`, `AlertModifier`) for clean global and localized error popups.
- ⏳ **Loading State System**: Environment-based loading states (`LoadingState`, `LoadingModifier`) to control full-screen or local progress views.
- 📭 **Content Unavailable Views**: Modern SwiftUI views for empty states and error retries.

---

## Requirements

| Platform | Minimum Version |
| --- | --- |
| iOS | 17.0+ |
| macOS | 14.0+ |
| Swift | 6.0+ |
| Xcode | 15.0+ |

---

## Installation

Add **SwiftWidgets** to your package dependencies in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/SwiftWidgets.git", from: "1.0.0")
]
```

Or add it directly via Xcode: **File** > **Add Package Dependencies...** and enter the repository URL.

---

## Usage

### 1. `AsyncButton`

`AsyncButton` encapsulates async operations into a button. While executing, it disables interaction, displays a spinner, and catches thrown errors automatically.

```swift
import SwiftUI
import SwiftWidgets

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Text Label
            AsyncButton("Save Changes") {
                try await saveProfileData()
            }
            .buttonStyle(.borderedProminent)

            // Custom Label
            AsyncButton {
                try await refreshFeed()
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.bordered)
        }
    }

    private func saveProfileData() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }

    private func refreshFeed() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
```

### 2. `.load` Modifier

Automatically run async setup tasks on view appearance with automatic loading and error state rendering.

```swift
import SwiftUI
import SwiftWidgets

struct DetailView: View {
    @State private var items: [String] = []

    var body: some View {
        List(items, id: \.self) { item in
            Text(item)
        }
        .load {
            // Automatically shows loading indicator
            // Renders error retry UI if an error is thrown
            self.items = try await fetchItems()
        }
    }

    private func fetchItems() async throws -> [String] {
        // Fetch logic
        return ["Item 1", "Item 2", "Item 3"]
    }
}
```

### 3. Alert & Error Handling

Use environment alerts to trigger popups from any child view.

```swift
import SwiftUI
import SwiftWidgets

struct RootView: View {
    var body: some View {
        ContentView()
            .alert() // Enables global alert environment modifier
    }
}

struct ContentView: View {
    @Environment(\.alert) private var alert

    var body: some View {
        Button("Trigger Error") {
            alert.error(MyError.networkFailed)
        }
    }
}
```

---

## Architecture & Code Style

- Built with Swift 6 Strict Concurrency enabled.
- Avoids legacy Combine dependencies; utilizes native `async/await` and `@Observable`.
- Conforms to clean, single-responsibility SwiftUI design patterns.

---

## License

SwiftWidgets is released under the MIT License. See [LICENSE](LICENSE) for details.
