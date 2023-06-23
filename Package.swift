// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuickViewClient",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "QuickViewClient",
            targets: ["QuickViewClient"]),
        
        .library(name: "QuickViewSwiftUI", targets: ["QuickViewSwiftUI"]),
        .library(name: "PluginInterface", targets: ["PluginInterface"]),
        .library(name: "ImageOverlayPlugin", type: .dynamic, targets: ["ImageOverlayPlugin"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "QuickViewClient",
            dependencies: []),
        
        .target(name: "QuickViewSwiftUI"),
        .target(name: "PluginInterface"),
        
        .target(name: "ImageOverlayPlugin",
                dependencies: [
                    "PluginInterface"
                ],
                swiftSettings: [
                    .unsafeFlags(["-emit-module", "-emit-library"]),
                ]),

        .testTarget(
            name: "QuickViewClientTests",
            dependencies: ["QuickViewClient"]),
    ]
)
