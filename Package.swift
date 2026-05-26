// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "BarKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "BarKit",
            targets: ["BarKit"]
        )
    ],
    targets: [
        .target(
            name: "BarKit",
            path: "Sources/BarKit",
            resources: [
                .process("Metal")
            ]
        )
    ]
)
