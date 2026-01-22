// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppServices",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "AppServices",
            targets: ["AppServices"]
        ),
    ],
    dependencies: [
      .package(path: "../AppServicesContracts"),
      .package(path: "../Configurations"),
      .package(path: "../Domain"),
      .package(path: "../DomainContracts"),
      .package(path: "../Language"),
      .package(path: "../Platform"),
      .package(path: "../PersistenceContracts"),
      .package(path: "../UserDefaultsStorage")
    ],
    targets: [
        .target(
            name: "AppServices",
            dependencies: [
              "AppServicesContracts",
              "Configurations",
              "Domain",
              "DomainContracts",
              "Language",
              "Platform",
              "PersistenceContracts",
              "UserDefaultsStorage"
            ],
            resources: [
              .process("Resources")
            ]
        ),
    ]
)
