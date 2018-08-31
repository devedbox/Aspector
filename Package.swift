// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Aspector",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Aspector",
            targets: ["Aspector"]),
        .library(
            name: "ObjCRuntime",
            targets: ["ObjCRuntime"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "_ObjC",
            dependencies: []),
        .target(
            name: "ObjCRuntime",
            dependencies: []),
        .target(
            name: "Aspector",
            dependencies: ["_ObjC", "ObjCRuntime"]),
        .testTarget(
            name: "AspectorTests",
            dependencies: ["Aspector"]),
        .testTarget(
            name: "ObjCRuntimeTests",
            dependencies: ["ObjCRuntime"]),
    ]
)
