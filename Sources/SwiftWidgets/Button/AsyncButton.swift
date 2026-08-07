//
//  AsyncButton.swift
//  ReadOne
//
//  Created by Antigravity on 7/10/26.
//

import SwiftUI

/// A SwiftUI button component designed to handle asynchronous, throwing actions.
///
/// `AsyncButton` automatically manages loading state during task execution, showing a `ProgressView`
/// while disabling user interactions to prevent accidental double taps. Any thrown errors are caught
/// and automatically forwarded to the environment alert handler.
///
/// ```swift
/// AsyncButton("Save Profile") {
///     try await saveUserData()
/// }
/// .buttonStyle(.borderedProminent)
/// ```
public struct AsyncButton<Label: View>: View {
    let role: ButtonRole?
    let action: () async throws -> Void
    let label: Label

    @Environment(\.alert) private var alert
    @State private var isLoading = false

    /// Creates an asynchronous button that performs an action when triggered.
    ///
    /// - Parameters:
    ///   - role: An optional role describing the semantic purpose of the button.
    ///   - action: An asynchronous, throwing closure to execute when tapped.
    ///   - label: A view builder producing the button's content.
    public init(
        role: ButtonRole? = nil,
        action: @escaping () async throws -> Void,
        @ViewBuilder label: () -> Label,
    ) {
        self.role = role
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button(role: role) {
            guard !isLoading else { return }
            Task {
                isLoading = true
                defer { isLoading = false }
                do {
                    try await action()
                } catch {
                    alert.error(error)
                    print(error.localizedDescription)
                }
            }
        } label: {
            ZStack {
                label
                    .opacity(isLoading ? 0 : 1)
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                }
            }
        }
        .disabled(isLoading)
    }
}

public extension AsyncButton where Label == Text {
    /// Creates an asynchronous button with a localized text title.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title.
    ///   - systemImage: An optional SF Symbols image name.
    ///   - role: An optional role describing the button's purpose.
    ///   - bundle: The bundle containing localizable resources.
    ///   - action: An asynchronous, throwing closure executed on tap.
    init(
        _ titleKey: LocalizedStringKey,
        systemImage: String? = nil,
        role: ButtonRole? = nil,
        bundle: Bundle? = nil,
        action: @escaping () async throws -> Void,
    ) {
        self.init(role: role, action: action) {
            Text(titleKey, bundle: bundle)
        }
    }

    /// Creates an asynchronous button with a string title.
    ///
    /// - Parameters:
    ///   - title: The string title for the button.
    ///   - systemImage: An optional SF Symbols image name.
    ///   - role: An optional role describing the button's purpose.
    ///   - action: An asynchronous, throwing closure executed on tap.
    @_disfavoredOverload
    init<S: StringProtocol>(
        _ title: S,
        systemImage: String? = nil,
        role: ButtonRole? = nil,
        action: @escaping () async throws -> Void,
    ) {
        self.init(role: role, action: action) {
            Text(title)
        }
    }
}

public extension AsyncButton where Label == SwiftUI.Label<Text, Image> {
    /// Creates an asynchronous button displaying a localized title and a system image label.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title.
    ///   - systemImage: The SF Symbols icon name.
    ///   - role: An optional role describing the button's purpose.
    ///   - bundle: The bundle containing localizable resources.
    ///   - action: An asynchronous, throwing closure executed on tap.
    init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        role: ButtonRole? = nil,
        bundle: Bundle? = nil,
        action: @escaping () async throws -> Void,
    ) {
        self.init(role: role, action: action) {
            Label {
                Text(titleKey, bundle: bundle)
            } icon: {
                Image(systemName: systemImage)
            }
        }
    }

    /// Creates an asynchronous button displaying a string title and a system image label.
    ///
    /// - Parameters:
    ///   - title: The title string for the button.
    ///   - systemImage: The SF Symbols icon name.
    ///   - role: An optional role describing the button's purpose.
    ///   - action: An asynchronous, throwing closure executed on tap.
    @_disfavoredOverload
    init<S: StringProtocol>(
        _ title: S,
        systemImage: String,
        role: ButtonRole? = nil,
        action: @escaping () async throws -> Void,
    ) {
        self.init(role: role, action: action) {
            Label(title, systemImage: systemImage)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AsyncButton("Click to Load") {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
        .buttonStyle(.borderedProminent)
        
        AsyncButton {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        } label: {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("Refresh Data")
            }
        }
        .buttonStyle(.bordered)
        
        // 测试抛出异常的场景
        AsyncButton("Click to Trigger Error") {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            struct DummyError: LocalizedError {
                var errorDescription: String? { "This is a simulated error message" }
            }
            throw DummyError()
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
    }
    .padding()
}
