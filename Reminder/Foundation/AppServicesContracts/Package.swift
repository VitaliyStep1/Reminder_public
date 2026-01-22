// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppServicesContracts",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "AppServicesContracts",
            targets: ["AppServicesContracts"]
        ),
    ],
    dependencies: [
      .package(path: "../Configurations"),
      .package(path: "../DomainContracts"),
      .package(path: "../UserDefaultsStorage"),
    ],
    targets: [
        .target(
            name: "AppServicesContracts",
            dependencies: [
              "Configurations",
              "DomainContracts",
              "UserDefaultsStorage",
            ]
        ),
    ]
)
