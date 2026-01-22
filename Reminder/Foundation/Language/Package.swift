// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Language",
    platforms: [
      .iOS(.v17),
    ],
    products: [
        .library(
            name: "Language",
            targets: ["Language"]),
    ],
    dependencies: [
      .package(path: "../UserDefaultsStorage"),
    ],
    targets: [
      .target(
        name: "Language",
        dependencies: [
          "UserDefaultsStorage",
        ],
      ),
    ]
)
