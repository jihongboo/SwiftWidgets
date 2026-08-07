import SwiftUI

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    /// 默认的空白/无内容状态视图
    static var empty: some View {
        ContentUnavailableView {
            SwiftUI.Label("No Content", systemImage: "tray.fill")
        } description: {
            Text("Please switch to a different tab or add some content")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == AsyncButton<SwiftUI.Label<Text, Image>> {
    @ViewBuilder
    static func empty(item: String? = nil, retry: @escaping () async throws -> Void) -> some View {
        ContentUnavailableView {
            SwiftUI.Label("No \(item, default: "content")", systemImage: "tray.fill")
        } description: {
            Text("Please click the button below to refresh")
        } actions: {
            AsyncButton("Refresh", systemImage: "arrow.triangle.2.circlepath", action: retry)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text? {
    @ViewBuilder
    static func empty(item: String? = nil, @ViewBuilder actions: () -> Actions) -> some View {
        ContentUnavailableView {
            SwiftUI.Label("No \(item, default: "content")", systemImage: "tray.fill")
        } description: {
            Text("Please click the button below to refresh")
        } actions: {
            actions()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}

#Preview {
    ContentUnavailableView.empty(item: "Channels") {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
