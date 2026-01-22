// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdsUI",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "AdsUI",
            targets: ["AdsUI"]),
    ],
    dependencies: [
      .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "12.0.0")
    ],
    targets: [
        .target(
            name: "AdsUI",
            dependencies: [
              .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ]
        ),

    ]
)
