// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MainTabView",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "MainTabView",
            targets: ["MainTabView"]),
    ],
    dependencies: [
      .package(path: "NavigationContracts"),
      .package(path: "MainTabViewContracts"),
      .package(path: "Categories"),
    ],
    targets: [
        .target(
            name: "MainTabView",
            dependencies: [
              "NavigationContracts",
              "MainTabViewContracts",
              "Categories",
            ],
            resources: [
              .process("Resources")
            ]
        ),

    ]
)
