// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ai",
    platforms: [
        .macOS(.v26),
    ],
    products: [
        .executable(
            name: "ai",
            targets: ["ai"]
        ),
    ],
    targets: [
        .executableTarget(
            name: "ai"
        ),
        .testTarget(
            name: "aiTests",
            dependencies: ["ai"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
