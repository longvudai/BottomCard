// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BottomCard",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "BottomCard",
            targets: ["BottomCard"]
        ),
    ],
    targets: [.target(name: "BottomCard")]
)
