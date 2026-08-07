# Swift & SwiftUI 编程规范 (code-style.md)

## 规范细则

### 1. 结构与导入
- 文件顶部仅导入必要的模块（如 `SwiftUI`, `Foundation`, `Testing`）。
- View 组件定义需严格遵循 `View` 协议，UI 逻辑全部收拢在 `body` 属性中。
- 代码缩进使用 4 个空格，保持适当空行分隔结构块。

### 2. 状态与属性
- SwiftUI 内部视图状态使用 `@State private var`。
- 不变属性与常量统一使用 `let`。
- 为 `@Observable` 宏修饰的模型属性确保基础类型符合 `Equatable`，以优化 SwiftUI 视图刷新性能。

### 3. Swift 6 并发支持
- 遵守 Package.swift 中启用的 `StrictConcurrency` 规则。
- 异步操作统一采用 `Task { @MainActor in ... }` 或 `async/await`，禁止使用 Combine 的 `Publisher`/`AnyCancellable`。
