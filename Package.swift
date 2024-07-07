// swift-tools-version: 5.9

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
