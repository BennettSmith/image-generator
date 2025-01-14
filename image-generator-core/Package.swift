// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "image-generator-core",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(name: "ImageGeneratorCore", targets: ["ImageGeneratorCore"]),
        .library(name: "ImageGeneratorRepositories", targets: ["ImageGeneratorRepositories"]),
    ],
    targets: [
        .target(
            name: "ImageGeneratorCore"),
        .testTarget(
            name: "ImageGeneratorCoreTests",
            dependencies: ["ImageGeneratorCore"]
        ),
        
        .target(
            name: "ImageGeneratorRepositories",
            dependencies: ["ImageGeneratorCore"]
        ),
        .testTarget(
            name: "ImageGeneratorRepositoriesTests",
            dependencies: ["ImageGeneratorRepositories"]
        ),
    ]
)
