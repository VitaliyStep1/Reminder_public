// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Analytics",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "Analytics",
            targets: ["Analytics"]
        ),
    ],
    dependencies: [
      .package(path: "../AnalyticsContracts"),
      .package(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework-Static", branch: "main")
    ],
    targets: [
        .target(
            name: "Analytics",
            dependencies: [
              "AnalyticsContracts",
              .product(name: "AppsFlyerLib-Static", package: "AppsFlyerFramework-Static")
            ]
        ),
    ]
)
