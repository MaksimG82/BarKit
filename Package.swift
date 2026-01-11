// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AdaptiveTabBar",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AdaptiveTabBar",
            targets: ["AdaptiveTabBar"]),
    ],
    targets: [
        .target(
            name: "AdaptiveTabBar",
            path: "Sources/AdaptiveTabBar") // Explicitly point to the source files
    ]
)
