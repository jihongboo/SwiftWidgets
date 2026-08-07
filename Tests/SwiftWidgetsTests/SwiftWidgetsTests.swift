import Testing
@testable import SwiftWidgets

@Test func example() async throws {
    let widgets = SwiftWidgets()
    #expect(widgets.text == "Hello, SwiftWidgets!")
}
