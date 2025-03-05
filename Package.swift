// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SmoothRoundedRectangle",
    platforms: [
        .iOS(.v16),
        .macOS(.v15),
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
