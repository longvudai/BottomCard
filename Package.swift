// swift-tools-version: 5.6


import PackageDescription

let package = Package(
    name: "BottomCard",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "BottomCard",
            targets: ["BottomCard"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BottomCard",
            dependencies: []
        )
    ]
)
