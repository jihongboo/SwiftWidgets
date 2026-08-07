import SwiftUI

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    /// A default empty-state view displaying a standard "No Content" message and tray icon.
    static var empty: some View {
        ContentUnavailableView {
            SwiftUI.Label {
                Text("No Content", bundle: .module)
            } icon: {
                Image(systemName: "tray.fill")
            }
        } description: {
            Text("Please switch to a different tab or add some content", bundle: .module)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == AsyncButton<SwiftUI.Label<Text, Image>> {
    /// Creates an empty-state view for a localized item key with an asynchronous retry action button.
    ///
    /// - Parameters:
    ///   - item: The key for the localized item category (e.g. `"Channels"`). Defaults to `"content"` if nil.
    ///   - retry: An asynchronous closure to execute when tapping the refresh button.
    /// - Returns: A configured `ContentUnavailableView`.
    @ViewBuilder
    static func empty(item: LocalizedStringKey? = nil, retry: @escaping () async throws -> Void) -> some View {
        let titleText: Text = if let item {
            Text("No \(Text(item))", bundle: .module)
        } else {
            Text("No Content", bundle: .module)
        }
        ContentUnavailableView {
            SwiftUI.Label {
                titleText
            } icon: {
                Image(systemName: "tray.fill")
            }
        } description: {
            Text("Please click the button below to refresh", bundle: .module)
        } actions: {
            AsyncButton("Refresh", systemImage: "arrow.triangle.2.circlepath", bundle: .module, action: retry)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }

    /// Creates an empty-state view for a string item title with an asynchronous retry action button.
    ///
    /// - Parameters:
    ///   - item: The string title of the missing item category.
    ///   - retry: An asynchronous closure to execute when tapping the refresh button.
    /// - Returns: A configured `ContentUnavailableView`.
    @ViewBuilder
    @_disfavoredOverload
    static func empty<S: StringProtocol>(item: S, retry: @escaping () async throws -> Void) -> some View {
        ContentUnavailableView {
            SwiftUI.Label {
                Text("No \(Text(item))", bundle: .module)
            } icon: {
                Image(systemName: "tray.fill")
            }
        } description: {
            Text("Please click the button below to refresh", bundle: .module)
        } actions: {
            AsyncButton("Refresh", systemImage: "arrow.triangle.2.circlepath", bundle: .module, action: retry)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text? {
    /// Creates an empty-state view for a localized item key with custom action views.
    ///
    /// - Parameters:
    ///   - item: The key for the localized item category (e.g. `"Channels"`). Defaults to `"content"` if nil.
    ///   - actions: A view builder producing action controls (such as buttons).
    /// - Returns: A configured `ContentUnavailableView`.
    @ViewBuilder
    static func empty(item: LocalizedStringKey? = nil, @ViewBuilder actions: () -> Actions) -> some View {
        let titleText: Text = if let item {
            Text("No \(Text(item))", bundle: .module)
        } else {
            Text("No Content", bundle: .module)
        }
        ContentUnavailableView {
            SwiftUI.Label {
                titleText
            } icon: {
                Image(systemName: "tray.fill")
            }
        } description: {
            Text("Please click the button below to refresh", bundle: .module)
        } actions: {
            actions()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }

    /// Creates an empty-state view for a string item title with custom action views.
    ///
    /// - Parameters:
    ///   - item: The string title of the missing item category.
    ///   - actions: A view builder producing action controls (such as buttons).
    /// - Returns: A configured `ContentUnavailableView`.
    @ViewBuilder
    @_disfavoredOverload
    static func empty<S: StringProtocol>(item: S, @ViewBuilder actions: () -> Actions) -> some View {
        ContentUnavailableView {
            SwiftUI.Label {
                Text("No \(Text(item))", bundle: .module)
            } icon: {
                Image(systemName: "tray.fill")
            }
        } description: {
            Text("Please click the button below to refresh", bundle: .module)
        } actions: {
            actions()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}

#Preview {
    ContentUnavailableView.empty(item: "Channels") {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
