// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AdaptiveTabBar",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "AdaptiveTabBar",
            targets: ["AdaptiveTabBar"],
        ),
    ],
    targets: [
        .target(
            name: "AdaptiveTabBar",
            path: "Sources/AdaptiveTabBar",
        ),
    ],
)
