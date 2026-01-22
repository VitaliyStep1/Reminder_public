// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserDefaultsStorage",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "UserDefaultsStorage",
            targets: ["UserDefaultsStorage"]),
    ],
    targets: [
        .target(
            name: "UserDefaultsStorage"),

    ]
)
