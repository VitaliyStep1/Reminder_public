// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Domain",
    defaultLocalization: "en",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]),
    ],
    dependencies: [
      .package(path: "../AppServicesContracts"),
      .package(path: "../DomainContracts"),
      .package(path: "../Persistence"),
      .package(path: "../PersistenceContracts"),
      .package(path: "../Configurations"),
      .package(path: "../UserDefaultsStorage"),
      .package(path: "../Language"),
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
              "AppServicesContracts",
              "DomainContracts",
              "Persistence",
              "PersistenceContracts",
              "Configurations",
              "UserDefaultsStorage",
              "Language",
            ]
        ),
    ]
)
