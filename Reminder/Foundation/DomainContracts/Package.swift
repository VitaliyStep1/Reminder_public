// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DomainContracts",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "DomainContracts",
            targets: ["DomainContracts"]),
    ],
    dependencies: [
      .package(path: "../PersistenceContracts"),
      .package(path: "../UserDefaultsStorage"),
      .package(path: "../Configurations"),
    ],
    targets: [
        .target(
            name: "DomainContracts",
            dependencies: [
              "PersistenceContracts",
              "UserDefaultsStorage",
              "Configurations",
            ],
        ),

    ]
)
