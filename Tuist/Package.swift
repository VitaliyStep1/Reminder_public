// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "ReminderTuistSupport",
  platforms: [
    .iOS(.v17)
  ],
  dependencies: [
    .package(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework-Static", branch: "main"),
    .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", .upToNextMajor(from: "12.0.0")),
    .package(path: "../Reminder/Foundation/Configurations"),
    .package(path: "../Reminder/Foundation/AppDI"),
    .package(path: "../Reminder/Foundation/AppServices"),
    .package(path: "../Reminder/Foundation/AppServicesContracts"),
    .package(path: "../Reminder/Foundation/DomainContracts"),
    .package(path: "../Reminder/Foundation/Domain"),
    .package(path: "../Reminder/Foundation/PersistenceContracts"),
    .package(path: "../Reminder/Foundation/Persistence"),
    .package(path: "../Reminder/Foundation/UserDefaultsStorage"),
    .package(path: "../Reminder/Foundation/AnalyticsContracts"),
    .package(path: "../Reminder/Foundation/Analytics"),
    .package(path: "../Reminder/Foundation/Platform"),
    .package(path: "../Reminder/Foundation/Language"),

    .package(path: "../Reminder/UIComponents/AdsUI"),
    .package(path: "../Reminder/UIComponents/DesignSystem"),
    
    .package(path: "../Reminder/Features/Start"),
    .package(path: "../Reminder/Features/MainTabView"),
    .package(path: "../Reminder/Features/Categories"),
    .package(path: "../Reminder/Features/Event"),
    .package(path: "../Reminder/Features/Closest"),
    .package(path: "../Reminder/Features/Settings"),
    .package(path: "../Reminder/Features/DomainLocalization"),
    .package(path: "../Reminder/Features/NavigationContracts"),
    .package(path: "../Reminder/Features/MainTabViewContracts"),
    
  ]
)
