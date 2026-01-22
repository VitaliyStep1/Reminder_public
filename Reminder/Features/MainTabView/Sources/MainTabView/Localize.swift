//
//  Localize.swift
//  MainTabView
//
//  Created by OpenAI Assistant on 28.11.2025.
//
import SwiftUI

enum Localize {
  private static let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
  private static func localizedResource(_ localizationValue: String.LocalizationValue) -> LocalizedStringResource {
    .init(localizationValue, bundle: Localize.bundleDescription)
  }

  static var closestTabTitle: LocalizedStringResource { localizedResource("closestTabTitle") }
  static var createTabTitle: LocalizedStringResource { localizedResource("createTabTitle") }
  static var settingsTabTitle: LocalizedStringResource { localizedResource("settingsTabTitle") }
}
