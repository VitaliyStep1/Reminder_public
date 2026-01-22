// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Categories",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "Categories",
            targets: ["Categories"]),
    ],
    dependencies: [
      .package(url: "https://github.com/Swinject/Swinject.git", from: "2.10.0"),
      .package(path: "NavigationContracts"),
      .package(path: "DomainContracts"),
      .package(path: "Domain"),
      .package(path: "DesignSystem"),
      .package(path: "Event"),
      .package(path: "AdsUI"),
      .package(path: "Language"),
      .package(path: "DomainLocalization"),
      .package(path: "UserDefaultsStorage"),
    ],
    targets: [
        .target(
            name: "Categories",
            dependencies: [
              .product(name: "Swinject", package: "Swinject"),
              "NavigationContracts",
              "DomainContracts",
              "Domain",
              "DesignSystem",
              "Event",
              "AdsUI",
              "Language",
              "DomainLocalization",
              "UserDefaultsStorage",
            ],
            resources: [
              .process("Resources")
            ]
        ),

    ]
)
