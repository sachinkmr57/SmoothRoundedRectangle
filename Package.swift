// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "SmoothRoundedRectangle",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "SmoothRoundedRectangle", targets: ["SmoothRoundedRectangle"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SmoothRoundedRectangle", path: "src"),
    ]
)
