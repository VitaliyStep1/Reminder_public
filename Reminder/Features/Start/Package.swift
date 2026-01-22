// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Start",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "Start",
            targets: ["Start"]),
    ],
    dependencies: [
      .package(path: "../Configurations"),
      .package(path: "../NavigationContracts"),
      .package(path: "../Domain"),
      .package(path: "../DomainContracts"),
      .package(path: "../DesignSystem"),
      .package(path: "../Closest"),
      .package(path: "../Categories"),
      .package(path: "../MainTabView"),
      .package(path: "../Settings"),
      .package(path: "../Language"),
    ],
    targets: [
        .target(
            name: "Start",
            dependencies: [
              "Configurations",
              "NavigationContracts",
              "Domain",
              "DomainContracts",
              "DesignSystem",
              "Closest",
              "Categories",
              "MainTabView",
              "Settings",
              "Language",
            ],
            resources: [
              .process("Resources")
            ]
        ),

    ]
)
