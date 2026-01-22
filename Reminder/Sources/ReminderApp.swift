//
//  ReminderApp.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 23.08.2025.
//

import SwiftUI
import DesignSystem
import AppDI
import Language
import GoogleMobileAds
import Configurations

@main
struct ReminderApp: App {
  private let di: AppDI = AppDI.shared
  
  @UIApplicationDelegateAdaptor(AppDelegate.self)
  private var appDelegate: AppDelegate
  
  @StateObject var languageService: LanguageService
  
  init() {
    DesignSystemFonts.registerFonts()
    
    let appConfiguration = di.assembler.resolver.resolve(AppConfigurationProtocol.self)!
    if appConfiguration.isWithBanner {
      MobileAds.shared.start()
    }
    
    let languageService = di.assembler.resolver.resolve(LanguageService.self)!
    _languageService = StateObject(wrappedValue: languageService)
  }
  
  var body: some Scene {
    WindowGroup {
      di.makeRootView()
        .environment(\.locale, languageService.locale)
    }
  }
}
