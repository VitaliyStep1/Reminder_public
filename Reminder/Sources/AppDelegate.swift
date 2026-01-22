//
//  AppDelegate.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 19.01.2026.
//

import UIKit
import AppsFlyerLib


class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                   [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    AppsFlyerLib.shared().appleAppID = ""
    AppsFlyerLib.shared().appsFlyerDevKey = ""
//    AppsFlyerLib.shared().isDebug = true
    AppsFlyerLib.shared().start()
    
    return true
  }
  
}
