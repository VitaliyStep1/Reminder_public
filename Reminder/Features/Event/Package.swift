// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Event",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "Event",
            targets: ["Event"]),
    ],
    dependencies: [
      .package(path: "../NavigationContracts"),
      .package(path: "../DomainContracts"),
      .package(path: "../DesignSystem"),
      .package(path: "../Platform"),
      .package(path: "../DomainLocalization"),
      .package(path: "../UserDefaultsStorage"),
      .package(path: "../AnalyticsContracts"),
    ],
    targets: [
        .target(
            name: "Event",
            dependencies: [
              "NavigationContracts",
              "DomainContracts",
              "DesignSystem",
              "Platform",
              "DomainLocalization",
              "UserDefaultsStorage",
              "AnalyticsContracts",
            ],
            resources: [
              .process("Resources")
            ]
        ),

    ]
)
