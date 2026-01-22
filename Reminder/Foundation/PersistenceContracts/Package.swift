// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PersistenceContracts",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "PersistenceContracts",
            targets: ["PersistenceContracts"]),
    ],
    targets: [
        .target(
            name: "PersistenceContracts"),

    ]
)
