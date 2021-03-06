// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "samin",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(
            name: "samin",
            targets: ["samin-cli"]
        ),
        .library(
            name: "libsamin",
            targets: ["samin"]),
    ],
    dependencies: [
        .package(name: "Inject", url: "https://github.com/illescasDaniel/Inject-Swift.git", .branch("master")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .branch("main")),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "samin-cli",
            dependencies: ["samin", .product(name: "ArgumentParser", package: "swift-argument-parser"), .product(name: "NIO", package: "swift-nio")]
        ),
        .target(
            name: "samin",
            dependencies: ["Inject"]),
        .testTarget(
            name: "saminTests",
            dependencies: ["Inject", "samin"]),
    ]
)
