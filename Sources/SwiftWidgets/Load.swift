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
                    ContentUnavailableView.error(error) {
                        Button {
                            Task {
                                await task()
                            }
                        } label: {
                            Text("Retry", bundle: .module)
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
    /// Runs an asynchronous data loading task when the view appears, displaying loading overlay and error retry interfaces automatically.
    ///
    /// - Parameter action: An asynchronous throwing closure executed when the view appears.
    /// - Returns: A view modified to handle loading and error overlay states automatically.
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
