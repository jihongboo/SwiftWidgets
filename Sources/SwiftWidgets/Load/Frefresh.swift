//
//  ThrowingTaskModifier.swift
//  FluxTV
//
//  Created by Codex on 3/8/26.
//

import SwiftUI

struct RefreshModifier: ViewModifier {
    let action: () async throws -> Void
    
    @State private var didLoad = false
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
            .task {
                await task()
            }
            .refreshable {
                await task(shouldShowLoading: false, force: true)
            }
#if os(tvOS)
            .onPlayPauseCommand {
                Task {
                    await task()
                }
            }
#endif
    }
}

private extension RefreshModifier {
    func task(shouldShowLoading: Bool = true, force: Bool = false) async {
        if force {
            
        } else {
            if didLoad { return }
        }
        defer { didLoad = true }
        
        if shouldShowLoading {
            loading.start()
        }
        defer {
            if shouldShowLoading {
                loading.stop()
            }
        }
        do {
            try await action()
        } catch is CancellationError {
            // Task 取消时不记录错误
        } catch {
            if let error = error as? URLError,
               error.code == .cancelled {
                // do nothing
            } else {
                self.error = error
            }
            print(error)
        }
    }
}

public extension View {
    /// Runs an asynchronous data loading task when the view appears, displaying loading overlay and error retry interfaces automatically.
    ///
    /// - Parameter action: An asynchronous throwing closure executed when the view appears.
    /// - Returns: A view modified to handle loading and error overlay states automatically.
    func refresh(
        _ action: @escaping () async throws -> Void
    ) -> some View {
        modifier(RefreshModifier(action: action))
    }
}

#Preview {
    ScrollView {
        
    }
    .load {
        throw URLError(.notConnectedToInternet)
    }
}
