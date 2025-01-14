// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "image-generator-app",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ImageGenerator",
            targets: ["ImageGenerator"]),
        .library(
            name: "ImageGeneratorInteractors",
            targets: ["ImageGeneratorInteractors"]),
    ],
    dependencies: [
        .package(path: "../image-generator-core"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ImageGenerator"
        ),
        .testTarget(
            name: "ImageGeneratorTests",
            dependencies: ["ImageGenerator"]
        ),
        
        .target(
            name: "ImageGeneratorInteractors",
            dependencies: [
                "ImageGenerator",
                .product(name: "ImageGeneratorCore", package: "image-generator-core"),
                .product(name: "ImageGeneratorRepositories", package: "image-generator-core"),
            ]
        ),
        .testTarget(
            name: "ImageGeneratorInteractorsTests",
            dependencies: ["ImageGeneratorInteractors"]
        ),
    ]
)
