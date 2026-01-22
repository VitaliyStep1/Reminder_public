// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Settings",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "Settings",
            targets: ["Settings"]),
    ],
    dependencies: [
      .package(url: "https://github.com/Swinject/Swinject.git", from: "2.10.0"),
      .package(path: "DomainContracts"),
      .package(path: "DesignSystem"),
      .package(path: "NavigationContracts"),
      .package(path: "Language"),
    ],
    targets: [
        .target(
          name: "Settings",
          dependencies: [
            .product(name: "Swinject", package: "Swinject"),
            "DomainContracts",
            "NavigationContracts",
            "DesignSystem",
            "Language",
          ],
          resources: [
            .process("Resources")
          ]
        ),

    ]
)
