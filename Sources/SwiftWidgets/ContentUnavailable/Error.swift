import SwiftUI

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    /// Creates an error-state view with an error description and no action buttons.
    ///
    /// - Parameters:
    ///   - error: The error whose `localizedDescription` will be displayed.
    ///   - title: The title text for the error header. Defaults to `"Something went wrong"`.
    ///   - systemImage: The SF Symbols icon name. Defaults to `"exclamationmark.triangle"`.
    /// - Returns: A configured `ContentUnavailableView`.
    @ViewBuilder
    static func error(
        _ error: Error,
        title: String = "Something went wrong",
        systemImage: String = "exclamationmark.triangle"
    ) -> some View {
        ContentUnavailableView {
            SwiftUI.Label(title, systemImage: systemImage)
        } description: {
            Text(error.localizedDescription)
        }
    }
}

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == AsyncButton<SwiftUI.Label<Text, Image>> {
    /// Creates an error-state view displaying the error description and an asynchronous retry button.
    ///
    /// - Parameters:
    ///   - error: The error whose `localizedDescription` will be displayed.
    ///   - title: The title text for the error header. Defaults to `"Something went wrong"`.
    ///   - systemImage: The SF Symbols icon name. Defaults to `"exclamationmark.triangle"`.
    ///   - retry: An asynchronous closure to execute when tapping the retry button.
    /// - Returns: A configured `ContentUnavailableView`.
    @ViewBuilder
    static func error(
        _ error: Error,
        title: String = "Something went wrong",
        systemImage: String = "exclamationmark.triangle",
        retry: @escaping () async throws -> Void
    ) -> some View {
        ContentUnavailableView {
            SwiftUI.Label(title, systemImage: systemImage)
        } description: {
            Text(error.localizedDescription)
        } actions: {
            AsyncButton("Retry", systemImage: "arrow.triangle.2.circlepath", action: retry)
        }
    }
}

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text? {
    /// Creates an error-state view displaying the error description with custom action controls.
    ///
    /// - Parameters:
    ///   - error: The error whose `localizedDescription` will be displayed.
    ///   - title: The title text for the error header. Defaults to `"Something went wrong"`.
    ///   - systemImage: The SF Symbols icon name. Defaults to `"exclamationmark.triangle"`.
    ///   - actions: A view builder producing custom action controls.
    /// - Returns: A configured `ContentUnavailableView`.
    @ViewBuilder
    static func error(
        _ error: Error,
        title: String = "Something went wrong",
        systemImage: String = "exclamationmark.triangle",
        @ViewBuilder actions: () -> Actions
    ) -> some View {
        ContentUnavailableView {
            SwiftUI.Label(title, systemImage: systemImage)
        } description: {
            Text(error.localizedDescription)
        } actions: {
            actions()
        }
    }
}

#Preview {
    struct SampleError: LocalizedError {
        var errorDescription: String? { "Failed to connect to the server." }
    }

    return ContentUnavailableView.error(SampleError()) {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
