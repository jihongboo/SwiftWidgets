//
//  AsyncButton.swift
//  ReadOne
//
//  Created by Antigravity on 7/10/26.
//

import SwiftUI

public struct AsyncButton<Label: View>: View {
    let role: ButtonRole?
    let action: () async throws -> Void
    let label: Label

    @Environment(\.alert) private var alert
    @State private var isLoading = false

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
    init(
        _ titleKey: LocalizedStringKey,
        systemImage: String? = nil,
        role: ButtonRole? = nil,
        action: @escaping () async throws -> Void,
    ) {
        self.init(role: role, action: action) {
            Text(titleKey)
        }
    }

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
    init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        role: ButtonRole? = nil,
        action: @escaping () async throws -> Void,
    ) {
        self.init(role: role, action: action) {
            Label(titleKey, systemImage: systemImage)
        }
    }

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
