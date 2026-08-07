# SwiftWidgets Agent 指南 (AGENTS.md)

本文件定义了针对 **SwiftWidgets** 项目的 Agent 行为准则、架构规范与工作流程。

---

## 1. 项目概览

- **项目名称**: SwiftWidgets
- **目标平台**: iOS 17.0+, macOS 14.0+
- **构建工具**: Swift Package Manager (SPM)
- **语言版本**: Swift 6 (Strict Concurrency Enabled)
- **默认并发隔离**: `@MainActor`

---

## 2. 代码规范与架构指南

### Swift & SwiftUI 最佳实践
- **并发与异步**: 严格遵循 Swift 6 并发模型（Strict Concurrency）。优先使用 `async/await` 和 Swift Concurrency 结构，避免使用 Combine 框架。
- **并发隔离**: 核心 UI 与组件默认采用 `@MainActor` 隔离。在非 Actor 上下文中操作 UI 时，确保显式声明 `@MainActor`。
- **命名规范**:
  - 类型/协议: `PascalCase`（如 `LoadingView`, `WidgetStyle`）
  - 属性/方法: `camelCase`（如 `isLoading`, `updateConfiguration()`）
- **状态管理**: 优先使用现代 SwiftUI 状态管理（`@State`, `@Binding`, `@Observable` 宏），遵从单向数据流原则。
- **安全性**: 充分利用 Swift 强类型系统，禁止无安全保障的强解包 (`!`)。

---

## 3. 构建与测试规范

- **项目构建**:
  - 优先使用 Xcode 整合工具（如 `BuildProject`）或 SPM 指令（`swift build`）校验编译。
- **单元测试**:
  - 必须使用 Apple 的现代 **Swift Testing** 框架（`import Testing`，使用 `@Test` 宏）撰写测试，不使用传统的 XCTest。
- **诊断校验**:
  - 在修改 `.swift` 文件后，可利用 Xcode 实时诊断（`XcodeRefreshCodeIssuesInFile`）快速验证编译正确性。

---

## 4. Agent 变更与协作原则

1. **精准修改**: 严格将代码修改限制在用户请求的范围之内，避免对无关文件产生副作用。
2. **改后验证**: 任何代码或配置更改后，必须运行编译/测试以确认变更符合要求且未引入 regression。
3. **保留注释**: 尊重并保留已有的文档注释（DocC / inline comments）。
