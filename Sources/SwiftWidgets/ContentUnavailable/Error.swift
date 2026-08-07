import SwiftUI

public enum ContentUnavailableError: Error, Equatable {
    case empty
}

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    /// Creates an error-state view with an error description and no action buttons.
    ///
    /// - Parameters:
    ///   - error: The error whose `localizedDescription` will be displayed.
    ///   - title: The localized title key for the error header. Defaults to `nil` (`"Something went wrong"`).
    ///   - systemImage: The SF Symbols icon name. Defaults to `"exclamationmark.triangle"`.
    /// - Returns: A configured `ContentUnavailableView`.
    @ViewBuilder
    static func error(
        _ error: Error,
        title: LocalizedStringKey? = nil,
        systemImage: String = "exclamationmark.triangle"
    ) -> some View {
        if let error = error as? ContentUnavailableError, error == .empty {
            ContentUnavailableView.empty
        } else {
            let titleText: Text = if let title {
                Text(title)
            } else {
                Text("Something went wrong", bundle: .module)
            }
            ContentUnavailableView {
                SwiftUI.Label {
                    titleText
                } icon: {
                    Image(systemName: systemImage)
                }
            } description: {
                Text(error.localizedDescription)
            }
        }
    }

    /// Creates an error-state view with a dynamic string title for the error header.
    @ViewBuilder
    @_disfavoredOverload
    static func error<S: StringProtocol>(
        _ error: Error,
        title: S,
        systemImage: String = "exclamationmark.triangle"
    ) -> some View {
        if let error = error as? ContentUnavailableError, error == .empty {
            ContentUnavailableView.empty
        } else {
            ContentUnavailableView {
                SwiftUI.Label {
                    Text(title)
                } icon: {
                    Image(systemName: systemImage)
                }
            } description: {
                Text(error.localizedDescription)
            }
        }
    }
}

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == AsyncButton<SwiftUI.Label<Text, Image>> {
    /// Creates an error-state view displaying the error description and an asynchronous retry button.
    ///
    /// - Parameters:
    ///   - error: The error whose `localizedDescription` will be displayed.
    ///   - title: The localized title key for the error header. Defaults to `nil` (`"Something went wrong"`).
    ///   - systemImage: The SF Symbols icon name. Defaults to `"exclamationmark.triangle"`.
    ///   - retry: An asynchronous closure to execute when tapping the retry button.
    /// - Returns: A configured `ContentUnavailableView`.
    @ViewBuilder
    static func error(
        _ error: Error,
        title: LocalizedStringKey? = nil,
        systemImage: String = "exclamationmark.triangle",
        retry: @escaping () async throws -> Void
    ) -> some View {
        if let error = error as? ContentUnavailableError, error == .empty {
            ContentUnavailableView.empty(retry: retry)
        } else {
            let titleText: Text = if let title {
                Text(title)
            } else {
                Text("Something went wrong", bundle: .module)
            }
            ContentUnavailableView {
                SwiftUI.Label {
                    titleText
                } icon: {
                    Image(systemName: systemImage)
                }
            } description: {
                Text(error.localizedDescription)
            } actions: {
                AsyncButton("Retry", systemImage: "arrow.triangle.2.circlepath", bundle: .module, action: retry)
            }
        }
    }

    /// Creates an error-state view displaying the error description and a retry button with a dynamic string title.
    @ViewBuilder
    @_disfavoredOverload
    static func error<S: StringProtocol>(
        _ error: Error,
        title: S,
        systemImage: String = "exclamationmark.triangle",
        retry: @escaping () async throws -> Void
    ) -> some View {
        if let error = error as? ContentUnavailableError, error == .empty {
            ContentUnavailableView.empty(retry: retry)
        } else {
            ContentUnavailableView {
                SwiftUI.Label {
                    Text(title)
                } icon: {
                    Image(systemName: systemImage)
                }
            } description: {
                Text(error.localizedDescription)
            } actions: {
                AsyncButton("Retry", systemImage: "arrow.triangle.2.circlepath", bundle: .module, action: retry)
            }
        }
    }
}

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text? {
    /// Creates an error-state view displaying the error description with custom action controls.
    ///
    /// - Parameters:
    ///   - error: The error whose `localizedDescription` will be displayed.
    ///   - title: The localized title key for the error header. Defaults to `nil` (`"Something went wrong"`).
    ///   - systemImage: The SF Symbols icon name. Defaults to `"exclamationmark.triangle"`.
    ///   - actions: A view builder producing custom action controls.
    /// - Returns: A configured `ContentUnavailableView`.
    @ViewBuilder
    static func error(
        _ error: Error,
        title: LocalizedStringKey? = nil,
        systemImage: String = "exclamationmark.triangle",
        @ViewBuilder actions: () -> Actions
    ) -> some View {
        if let error = error as? ContentUnavailableError, error == .empty {
            ContentUnavailableView.empty(actions: actions)
        } else {
            let titleText: Text = if let title {
                Text(title)
            } else {
                Text("Something went wrong", bundle: .module)
            }
            ContentUnavailableView {
                SwiftUI.Label {
                    titleText
                } icon: {
                    Image(systemName: systemImage)
                }
            } description: {
                Text(error.localizedDescription)
            } actions: {
                actions()
            }
        }
    }

    /// Creates an error-state view displaying the error description with custom action controls and a dynamic string title.
    @ViewBuilder
    @_disfavoredOverload
    static func error<S: StringProtocol>(
        _ error: Error,
        title: S,
        systemImage: String = "exclamationmark.triangle",
        @ViewBuilder actions: () -> Actions
    ) -> some View {
        if let error = error as? ContentUnavailableError, error == .empty {
            ContentUnavailableView.empty(actions: actions)
        } else {
            ContentUnavailableView {
                SwiftUI.Label {
                    Text(title)
                } icon: {
                    Image(systemName: systemImage)
                }
            } description: {
                Text(error.localizedDescription)
            } actions: {
                actions()
            }
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
