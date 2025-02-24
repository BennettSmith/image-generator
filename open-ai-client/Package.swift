// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "open-ai-client",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(name: "OpenAIClient", targets: ["OpenAIClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.6.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.7.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-http-types.git", from: "1.0.0"),
        .package(url: "https://github.com/thebarndog/swift-dotenv.git", .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        .target(
            name: "OpenAIClient",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
            ],
            plugins: [.plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")]
        ),
        .testTarget(name: "OpenAIClientTests", dependencies: [
            "OpenAIClient",
            .product(name: "SwiftDotenv", package: "swift-dotenv")
        ]),
    ]
)
