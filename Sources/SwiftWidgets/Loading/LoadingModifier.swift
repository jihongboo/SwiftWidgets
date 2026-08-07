import SwiftUI

private struct LoadingModifier: ViewModifier {
    @State private var loading = LoadingState()

    func body(content: Content) -> some View {
        content
            .environment(\.loading, loading)
            .overlay {
                switch loading.state {
                case .start(_):
                    ProgressView()
                case .stop:
                    EmptyView()
                }
            }
            .animation(.smooth, value: loading.state)
    }
}

public extension View {
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

