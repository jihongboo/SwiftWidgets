import SwiftUI

extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    /// 默认的错误状态视图（无操作按钮）
    @ViewBuilder
    static func error(
        _ error: Error,
        title: String = "Something went wrong",
        systemImage: String = "exclamationmark.triangle"
    ) -> some View {
        ContentUnavailableView {
            SwiftUI.Label(title, systemImage: systemImage)
        } description: {
            Text(error.localizedDescription)
        }
    }
}

extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == AsyncButton<SwiftUI.Label<Text, Image>> {
    /// 默认的错误状态视图（带异步重试按钮）
    @ViewBuilder
    static func error(
        _ error: Error,
        title: String = "Something went wrong",
        systemImage: String = "exclamationmark.triangle",
        retry: @escaping () async throws -> Void
    ) -> some View {
        ContentUnavailableView {
            SwiftUI.Label(title, systemImage: systemImage)
        } description: {
            Text(error.localizedDescription)
        } actions: {
            AsyncButton("Retry", systemImage: "arrow.triangle.2.circlepath", action: retry)
        }
    }
}

extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text? {
    /// 默认的错误状态视图（自定义 Action 视图）
    @ViewBuilder
    static func error(
        _ error: Error,
        title: String = "Something went wrong",
        systemImage: String = "exclamationmark.triangle",
        @ViewBuilder actions: () -> Actions
    ) -> some View {
        ContentUnavailableView {
            SwiftUI.Label(title, systemImage: systemImage)
        } description: {
            Text(error.localizedDescription)
        } actions: {
            actions()
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
