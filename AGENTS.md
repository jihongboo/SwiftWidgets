# SwiftWidgets Agent 指南

详细的 Agent 配置文件及规则已初始化在 `.agents/` 目录中：

- [AGENTS.md](file:///Users/jihongbo/Developer/SwiftWidgets/.agents/AGENTS.md): 项目概览、架构准则与构建测试流程
- [code-style.md](file:///Users/jihongbo/Developer/SwiftWidgets/.agents/rules/code-style.md): Swift 6 & SwiftUI 代码规范

---

## 核心要点简记

1. **项目类型**: SwiftUI 组件库 (iOS 17+, macOS 14+)
2. **Swift 6**: 严格并发检查 (Strict Concurrency)，默认隔离为 `@MainActor`
3. **异步范式**: 优先使用 `async/await`，避免 Combine
4. **测试框架**: 必须使用 Swift `Testing` 框架 (`@Test`)
