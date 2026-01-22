// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppDI",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "AppDI",
            targets: ["AppDI"]),
    ],
    dependencies: [
      .package(url: "https://github.com/Swinject/Swinject.git", from: "2.10.0"),
      .package(path: "../AppServicesContracts"),
      .package(path: "../Domain"),
      .package(path: "../DomainContracts"),
      .package(path: "../Persistence"),
      .package(path: "../PersistenceContracts"),
      .package(path: "../Configurations"),
      .package(path: "../Analytics"),
      .package(path: "../AnalyticsContracts"),
      .package(path: "../UserDefaultsStorage"),
      .package(path: "../Platform"),
      .package(path: "../Closest"),
      .package(path: "../Categories"),
      .package(path: "../Event"),
      .package(path: "../Settings"),
      .package(path: "../MainTabView"),
      .package(path: "../MainTabViewContracts"),
      .package(path: "../Start"),
      .package(path: "../Language"),
    ],
    targets: [
      .target(
        name: "AppDI",
        dependencies: [
          .product(name: "Swinject", package: "Swinject"),
          "AppServicesContracts",
          "Domain",
          "DomainContracts",
          "Persistence",
          "PersistenceContracts",
          "Configurations",
          "Analytics",
          "AnalyticsContracts",
          "UserDefaultsStorage",
          "Platform",
          "Closest",
          "Categories",
          "Event",
          "Settings",
          "MainTabView",
          "MainTabViewContracts",
          "Start",
          "Language",
        ]),
      
    ]
)
