// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "image-generator-app",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "ImageGeneratorApp",
            targets: ["ImageGeneratorApp"]),
    ],
    dependencies: [
        .package(path: "../image-generator-core"),
    ],
    targets: [
        .target(
            name: "ImageGeneratorApp",
            dependencies: [
                .product(name: "ImageGeneratorCore", package: "image-generator-core"),
            ]
        ),
        .testTarget(
            name: "ImageGeneratorAppTests",
            dependencies: ["ImageGeneratorApp"]
        ),
    ]
)
