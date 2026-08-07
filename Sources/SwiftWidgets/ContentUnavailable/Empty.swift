import SwiftUI

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    /// A default empty-state view displaying a standard "No Content" message and tray icon.
    static var empty: some View {
        ContentUnavailableView {
            SwiftUI.Label("No Content", systemImage: "tray.fill")
        } description: {
            Text("Please switch to a different tab or add some content")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == AsyncButton<SwiftUI.Label<Text, Image>> {
    /// Creates an empty-state view for a specific item type with an asynchronous retry action button.
    ///
    /// - Parameters:
    ///   - item: The name of the missing item category (e.g. "Channels", "Items"). Defaults to `"content"` if nil.
    ///   - retry: An asynchronous closure to execute when tapping the refresh button.
    /// - Returns: A configured `ContentUnavailableView`.
    @ViewBuilder
    static func empty(item: String? = nil, retry: @escaping () async throws -> Void) -> some View {
        ContentUnavailableView {
            SwiftUI.Label("No \(item, default: "content")", systemImage: "tray.fill")
        } description: {
            Text("Please click the button below to refresh")
        } actions: {
            AsyncButton("Refresh", systemImage: "arrow.triangle.2.circlepath", action: retry)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text? {
    /// Creates an empty-state view for a specific item type with custom action views.
    ///
    /// - Parameters:
    ///   - item: The name of the missing item category (e.g. "Channels"). Defaults to `"content"` if nil.
    ///   - actions: A view builder producing action controls (such as buttons).
    /// - Returns: A configured `ContentUnavailableView`.
    @ViewBuilder
    static func empty(item: String? = nil, @ViewBuilder actions: () -> Actions) -> some View {
        ContentUnavailableView {
            SwiftUI.Label("No \(item, default: "content")", systemImage: "tray.fill")
        } description: {
            Text("Please click the button below to refresh")
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
