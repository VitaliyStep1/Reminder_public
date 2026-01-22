// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Closest",
    defaultLocalization: "en",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "Closest",
            targets: ["Closest"]),
    ],
    dependencies: [
      .package(url: "https://github.com/Swinject/Swinject.git", from: "2.10.0"),
      .package(path: "MainTabViewContracts"),
      .package(path: "NavigationContracts"),
      .package(path: "DesignSystem"),
      .package(path: "Domain"),
      .package(path: "AdsUI"),
      .package(path: "Language"),
      .package(path: "DomainLocalization"),
      .package(path: "Event"),
    ],
    targets: [
        .target(
            name: "Closest",
            dependencies: [
              .product(name: "Swinject", package: "Swinject"),
              "MainTabViewContracts",
              "NavigationContracts",
              "DesignSystem",
              "Domain",
              "AdsUI",
              "Language",
              "DomainLocalization",
              "Event",
            ],
            resources: [
              .process("Resources")
            ]
        ),
    ]
)
