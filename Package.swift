// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "SwiftFast",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SwiftFast",
            targets: ["SwiftFast"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftFast",
            dependencies: [],
            path: "Sources"
        )
    ]
)
