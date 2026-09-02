//
//  ThrowingTaskModifier.swift
//  FluxTV
//
//  Created by Codex on 3/8/26.
//

import SwiftUI

struct LoadOnceModifier: ViewModifier {
    let action: () async throws -> Void
    
    @Environment(\.loading) private var loading
    @State private var error: Error?
    @State private var didLoad = false

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

private extension LoadOnceModifier {
    func task() async {
        if didLoad { return }
        defer { didLoad = true }
        
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
    func loadOnce(
        _ action: @escaping () async throws -> Void
    ) -> some View {
        modifier(LoadOnceModifier(action: action))
    }
}

#Preview {
    ScrollView {
        
    }
    .load {
        throw URLError(.notConnectedToInternet)
    }
}
