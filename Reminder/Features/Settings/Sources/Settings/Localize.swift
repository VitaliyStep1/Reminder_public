//
//  Localize.swift
//  Settings
//
//  Created by OpenAI Assistant on 28.11.2025.
//
import SwiftUI

enum Localize {
  private static let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
  private static func localizedResource(_ localizationValue: String.LocalizationValue) -> LocalizedStringResource {
    .init(localizationValue, bundle: Localize.bundleDescription)
  }

  static var settingsTitle: LocalizedStringResource { localizedResource("settingsTitle") }
  static var defaultRemindTimeLabel: LocalizedStringResource { localizedResource("defaultRemindTimeLabel") }
  static var language_column: LocalizedStringResource { localizedResource("language_column") }
  static var language: LocalizedStringResource { localizedResource("language") }
  static var support: LocalizedStringResource { localizedResource("support") }
  static var supportPrompt: LocalizedStringResource { localizedResource("supportPrompt") }
  static var rateUs: LocalizedStringResource { localizedResource("rateUs") }
  static var privacyPolicy: LocalizedStringResource { localizedResource("privacyPolicy") }
  static var termOfUse: LocalizedStringResource { localizedResource("termOfUse") }
}

extension LocalizedStringResource {
  func localed(_ locale: Locale) -> LocalizedStringResource {
    var resource = self
    resource.locale = locale
    return resource
  }
}
