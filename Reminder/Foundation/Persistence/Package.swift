// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Persistence",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "Persistence",
            targets: ["Persistence"]),
    ],
    dependencies: [
      .package(url: "https://github.com/Swinject/Swinject.git", from: "2.10.0"),
      .package(path: "../PersistenceContracts")
    ],
    targets: [
        .target(
            name: "Persistence",
            dependencies: [
              .product(name: "Swinject", package: "Swinject"),
              "PersistenceContracts",
            ],
            resources: [
              .process("Model.xcdatamodeld")
            ]
        ),
    ]
)
