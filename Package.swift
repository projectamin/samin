// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "samin",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "samin",
            targets: ["samin"]),
        .executable(name: "samin-cli", targets: ["samin-cli"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/crossroadlabs/Regex.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "samin",
            dependencies: [
                .product(name: "Regex", package: "Regex"),
                .product(name: "Collections", package: "swift-collections")
            ]),
        .target(
                name: "samin-cli",
                dependencies: ["samin",
                   .product(name: "ArgumentParser", package: "swift-argument-parser")
                ]
        ),
        .testTarget(
            name: "saminTests",
            dependencies: ["samin"]),
    ]
)
