//
//  ThrowingTaskModifier.swift
//  FluxTV
//
//  Created by Codex on 3/8/26.
//

import SwiftUI

struct LoadModifier: ViewModifier {
    let action: @Sendable () async throws -> Void
    
    @State private var error: Error?
    @Environment(\.loading) private var loading

    func body(content: Content) -> some View {
        content
            .overlay {
                if let error {
                    ContentUnavailableView {
                        Label(
                            "Something went wrong",
                            systemImage: "exclamationmark.triangle"
                        )
                    } description: {
                        Text(error.localizedDescription)
                    } actions: {
                        Button("Retry") {
                            Task {
                                await task()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.background)
                }
            }
            .task(task)
    }
}

private extension LoadModifier {
    func task() async {
        loading.start()
        defer {
            loading.stop()
        }
        do {
            try await action()
        } catch {
            self.error = error
            print(error)
        }
    }
}

public extension View {
    func load(
        _ action: @escaping @Sendable () async throws -> Void
    ) -> some View {
        modifier(LoadModifier(action: action))
    }
}

#Preview {
    ScrollView {
        
    }
    .load {
        throw URLError(.notConnectedToInternet)
    }
}
