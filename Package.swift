// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Macros",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(
            name: "Macros",
            targets: ["Macros"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Macros",
            dependencies: []),
        .testTarget(
            name: "MacrosTests",
            dependencies: ["Macros"]),
    ]
)
