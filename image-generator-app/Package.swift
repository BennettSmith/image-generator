// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "image-generator-app",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "ImageGeneratorUseCases",
            targets: ["ImageGeneratorUseCases"]),
        .library(
            name: "ImageGeneratorInteractors",
            targets: ["ImageGeneratorInteractors"]),
    ],
    dependencies: [
        .package(path: "../image-generator-core"),
    ],
    targets: [
        .target(
            name: "ImageGeneratorUseCases"
        ),
        .testTarget(
            name: "ImageGeneratorUseCasesTests",
            dependencies: ["ImageGeneratorUseCases"]
        ),
        
        .target(
            name: "ImageGeneratorInteractors",
            dependencies: [
                "ImageGeneratorUseCases",
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
