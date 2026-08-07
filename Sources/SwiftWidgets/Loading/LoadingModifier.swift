import SwiftUI

private struct LoadingModifier: ViewModifier {
    @State private var loading = LoadingState()

    func body(content: Content) -> some View {
        content
            .environment(\.loading, loading)
            .overlay {
                switch loading.state {
                case .start:
                    ProgressView()
                case .stop:
                    EmptyView()
                }
            }
            .animation(.smooth, value: loading.state)
    }
}

public extension View {
    /// Attaches a ``LoadingState`` environment modifier to the view hierarchy, displaying a progress overlay when active.
    ///
    /// - Returns: A view modified with automatic loading overlay capabilities.
    func loading() -> some View {
        modifier(LoadingModifier())
    }
}

#Preview("Loading") {
    VStack(spacing: 12) {
        Text("Demo Content")
        Button("Action") {}
    }
    .padding()
    .loading()
}

#Preview("Idle") {
    VStack(spacing: 12) {
        Text("Demo Content")
        Button("Action") {}
    }
    .padding()
    .loading()
}

