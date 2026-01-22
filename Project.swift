import ProjectDescription

let projectSettings: Settings = .settings(
  base: [
    "CODE_SIGN_STYLE": "Automatic",
    "DEVELOPMENT_TEAM": "",
    "CODE_SIGN_IDENTITY": "",
    "CURRENT_PROJECT_VERSION": "1",
    "MARKETING_VERSION": "1.0",
    "SWIFT_VERSION": "6.2",
    "IPHONEOS_DEPLOYMENT_TARGET": "17.0"
  ],
  configurations: [
    .debug(name: "Debug"),
    .release(name: "Release")
  ],
  defaultSettings: .recommended
)

let appSettings: Settings = .settings(
  base: [
    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
    "ENABLE_PREVIEWS": "YES",
    "INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents": "YES",
    "INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad": "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown",
    "INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone": "UIInterfaceOrientationPortrait",
    "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks"],
    "SWIFT_EMIT_LOC_STRINGS": "YES",
    "TARGETED_DEVICE_FAMILY": "1,2",
    "DEVELOPMENT_LANGUAGE": "en",
  ]
)

let reminderScheme: Scheme = .scheme(
  name: "Reminder",
  shared: true,
  buildAction: .buildAction(targets: ["Reminder"]),
  runAction: .runAction(configuration: "Debug"),
  archiveAction: .archiveAction(configuration: "Release"),
  profileAction: .profileAction(configuration: "Release"),
  analyzeAction: .analyzeAction(configuration: "Debug")
)

let project = Project(
  name: "Reminder",
  settings: projectSettings,
  targets: [
    .target(
      name: "Reminder",
      destinations: .iOS,
      product: .app,
      bundleId: "Reminder.Public.Random.sufeuPakqbfGdmeifbw",
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
          ],
          "CFBundleDevelopmentRegion": "en",
          "CFBundleDisplayName": "Reminder",
          "CFBundleLocalizations": [
            "en",
            "uk"
          ],
//          Current GADApplicationIdentifier is only for testing:
          "GADApplicationIdentifier": "ca-app-pub-3940256099942544~1458002511",
          "SKAdNetworkItems": [
            ["SKAdNetworkIdentifier": "cstr6suwn9.skadnetwork"],
            ["SKAdNetworkIdentifier": "4fzdc2evr5.skadnetwork"],
            ["SKAdNetworkIdentifier": "2fnua5tdw4.skadnetwork"],
            ["SKAdNetworkIdentifier": "ydx93a7ass.skadnetwork"],
            ["SKAdNetworkIdentifier": "p78axxw29g.skadnetwork"],
            ["SKAdNetworkIdentifier": "v72qych5uu.skadnetwork"],
            ["SKAdNetworkIdentifier": "ludvb6z3bs.skadnetwork"],
            ["SKAdNetworkIdentifier": "cp8zw746q7.skadnetwork"],
            ["SKAdNetworkIdentifier": "3sh42y64q3.skadnetwork"],
            ["SKAdNetworkIdentifier": "c6k4g5qg8m.skadnetwork"],
            ["SKAdNetworkIdentifier": "s39g8k73mm.skadnetwork"],
            ["SKAdNetworkIdentifier": "3qy4746246.skadnetwork"],
            ["SKAdNetworkIdentifier": "f38h382jlk.skadnetwork"],
            ["SKAdNetworkIdentifier": "hs6bdukanm.skadnetwork"],
            ["SKAdNetworkIdentifier": "mlmmfzh3r3.skadnetwork"],
            ["SKAdNetworkIdentifier": "v4nxqhlyqp.skadnetwork"],
            ["SKAdNetworkIdentifier": "wzmmz9fp6w.skadnetwork"],
            ["SKAdNetworkIdentifier": "su67r6k2v3.skadnetwork"],
            ["SKAdNetworkIdentifier": "yclnxrl5pm.skadnetwork"],
            ["SKAdNetworkIdentifier": "t38b2kh725.skadnetwork"],
            ["SKAdNetworkIdentifier": "7ug5zh24hu.skadnetwork"],
            ["SKAdNetworkIdentifier": "gta9lk7p23.skadnetwork"],
            ["SKAdNetworkIdentifier": "vutu7akeur.skadnetwork"],
            ["SKAdNetworkIdentifier": "y5ghdn5j9k.skadnetwork"],
            ["SKAdNetworkIdentifier": "v9wttpbfk9.skadnetwork"],
            ["SKAdNetworkIdentifier": "n38lu8286q.skadnetwork"],
            ["SKAdNetworkIdentifier": "47vhws6wlr.skadnetwork"],
            ["SKAdNetworkIdentifier": "kbd757ywx3.skadnetwork"],
            ["SKAdNetworkIdentifier": "9t245vhmpl.skadnetwork"],
            ["SKAdNetworkIdentifier": "a2p9lx4jpn.skadnetwork"],
            ["SKAdNetworkIdentifier": "22mmun2rn5.skadnetwork"],
            ["SKAdNetworkIdentifier": "44jx6755aq.skadnetwork"],
            ["SKAdNetworkIdentifier": "k674qkevps.skadnetwork"],
            ["SKAdNetworkIdentifier": "4468km3ulz.skadnetwork"],
            ["SKAdNetworkIdentifier": "2u9pt9hc89.skadnetwork"],
            ["SKAdNetworkIdentifier": "8s468mfl3y.skadnetwork"],
            ["SKAdNetworkIdentifier": "klf5c3l5u5.skadnetwork"],
            ["SKAdNetworkIdentifier": "ppxm28t8ap.skadnetwork"],
            ["SKAdNetworkIdentifier": "kbmxgpxpgc.skadnetwork"],
            ["SKAdNetworkIdentifier": "uw77j35x4d.skadnetwork"],
            ["SKAdNetworkIdentifier": "578prtvx9j.skadnetwork"],
            ["SKAdNetworkIdentifier": "4dzt52r2t5.skadnetwork"],
            ["SKAdNetworkIdentifier": "tl55sbb4fm.skadnetwork"],
            ["SKAdNetworkIdentifier": "c3frkrj4fj.skadnetwork"],
            ["SKAdNetworkIdentifier": "e5fvkxwrpn.skadnetwork"],
            ["SKAdNetworkIdentifier": "8c4e2ghe7u.skadnetwork"],
            ["SKAdNetworkIdentifier": "3rd42ekr43.skadnetwork"],
            ["SKAdNetworkIdentifier": "97r2b46745.skadnetwork"],
            ["SKAdNetworkIdentifier": "3qcr597p9d.skadnetwork"],
          ]
        ]
      ),
      buildableFolders: [
        "Reminder/Sources",
        "Reminder/Resources",
      ],
      dependencies: [
        .external(name: "Configurations"),
        .external(name: "AppDI"),
        .external(name: "AppServices"),
        .external(name: "AppServicesContracts"),
        .external(name: "Domain"),
        .external(name: "DomainContracts"),
        .external(name: "Persistence"),
        .external(name: "PersistenceContracts"),
        .external(name: "UserDefaultsStorage"),
        .external(name: "AnalyticsContracts"),
        .external(name: "Analytics"),
        .external(name: "Platform"),
        .external(name: "Language"),
        .external(name: "GoogleMobileAds"),
        .external(name: "AppsFlyerLib-Static"),

        .external(name: "AdsUI"),
        .external(name: "DesignSystem"),
        
        .external(name: "Start"),
        .external(name: "MainTabView"),
        .external(name: "Closest"),
        .external(name: "Categories"),
        .external(name: "Event"),
        .external(name: "Settings"),
        .external(name: "DomainLocalization"),
        .external(name: "MainTabViewContracts"),
        .external(name: "NavigationContracts"),
      ],
      settings: appSettings
    ),
  ],
  schemes: [reminderScheme]
)
