// swift-tools-version: 6.3.3
import PackageDescription

let package = Package(
    name: "SwiftWidgets",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "SwiftWidgets",
            targets: ["SwiftWidgets"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftWidgets",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("AnyAppleOSAvailability"),
                .defaultIsolation(MainActor.self),
            ]
        ),
        .testTarget(
            name: "SwiftWidgetsTests",
            dependencies: ["SwiftWidgets"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("AnyAppleOSAvailability"),
                .defaultIsolation(MainActor.self),
            ]
        ),
    ]
)
