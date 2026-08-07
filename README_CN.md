# SwiftWidgets

语言: [English](README.md) | **中文**

SwiftWidgets 是一个专为 iOS 17+ 和 macOS 14+ 设计的轻量级现代 SwiftUI 组件库，全量采用 Swift 6 严格并发安全（Strict Concurrency）构建。

## 核心特性

- ⚡️ **支持 Swift 6**: 完全符合严格并发检查与 `@MainActor` 默认隔离规范。
- 🔄 **`AsyncButton` 异步按钮**: 自动管理加载中状态（显示 `ProgressView` 菊花）、防止重复点击，并将异步异常无缝路由至环境弹窗。
- 📥 **`.load` 修饰符**: 视图载入时自动运行异步任务，集成全局加载遮罩与内置的错误重试 UI。
- 🚨 **统一 Alert 弹窗管理**: 基于 SwiftUI Environment 机制 (`AlertState`, `AlertModifier`)，实现全局与局部的统一错误及信息弹窗提示。
- ⏳ **Loading 加载状态系统**: 基于 Environment 的加载状态（`LoadingState`, `LoadingModifier`），方便灵活控制全屏或局部的进度展示。
- 📭 **Content Unavailable 视图**: 优雅封装的空状态与错误重试页面 (`Empty`, `Error`)。

---

## 环境要求

| 平台 | 最低版本要求 |
| --- | --- |
| iOS | 17.0+ |
| macOS | 14.0+ |
| Swift | 6.0+ |
| Xcode | 15.0+ |

---

## 安装方式

在 SPM `Package.swift` 文件中添加 **SwiftWidgets** 依赖：

```swift
dependencies: [
    .package(url: "https://github.com/your-username/SwiftWidgets.git", from: "1.0.0")
]
```

或直接在 Xcode 中集成：依次点击 **File** > **Add Package Dependencies...** 并输入仓库地址。

---

## 快速上手

### 1. `AsyncButton` 异步按钮

`AsyncButton` 封装了异步操作。在任务执行过程中自动禁用按钮、展示加载动画，并自动捕获发生的错误。

```swift
import SwiftUI
import SwiftWidgets

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 16) {
            // 文字按钮
            AsyncButton("保存修改") {
                try await saveProfileData()
            }
            .buttonStyle(.borderedProminent)

            // 自定义 Label 按钮
            AsyncButton {
                try await refreshFeed()
            } label: {
                Label("刷新数据", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.bordered)
        }
    }

    private func saveProfileData() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }

    private func refreshFeed() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
```

### 2. `.load` 视图数据加载器

在视图出现时自动执行异步初始化逻辑，并在发生错误时提供一键重试界面：

```swift
import SwiftUI
import SwiftWidgets

struct DetailView: View {
    @State private var items: [String] = []

    var body: some View {
        List(items, id: \.self) { item in
            Text(item)
        }
        .load {
            // 自动展示加载状态
            // 若抛出异常，将自动渲染“发生错误/重试”视图
            self.items = try await fetchItems()
        }
    }

    private func fetchItems() async throws -> [String] {
        return ["数据项 1", "数据项 2", "数据项 3"]
    }
}
```

### 3. Alert 统一弹窗管理

通过 SwiftUI 环境上下文在任意子视图发起弹窗：

```swift
import SwiftUI
import SwiftWidgets

struct RootView: View {
    var body: some View {
        ContentView()
            .alert() // 挂载 Alert 环境修饰符
    }
}

struct ContentView: View {
    @Environment(\.alert) private var alert

    var body: some View {
        Button("触发网络错误提示") {
            alert.error(MyError.networkFailed)
        }
    }
}
```

---

## 架构与规范

- 全量开启 Swift 6 Strict Concurrency 模式。
- 摒弃旧版 Combine 框架，全量基于 Swift 原生 `async/await` 和 `@Observable` 响应式状态。
- 符合单一职责的现代 SwiftUI 架构设计原则。

---

## 开源协议

SwiftWidgets 基于 MIT 协议开源，详见 [LICENSE](LICENSE)。
