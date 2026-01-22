//
//  Localize.swift
//  Domain
//
//  Created by OpenAI Assistant on 28.11.2025.
//
import SwiftUI
import AppServices

enum Localize {
  private static let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
  static func localizedResource(_ localizationValue: String.LocalizationValue) -> LocalizedStringResource {
    .init(localizationValue, bundle: Localize.bundleDescription)
  }
  
  static func localized(categoryKey: DefaultCategoriesDataService.CategoryKeyEnum) -> LocalizedStringResource {
    let key = categoryKey.key
    let localizationValue = Localize.localizationValue(string: key)
    return Localize.localizedResource(localizationValue)
  }
  
  static func localizationValue(string: String) -> String.LocalizationValue {
    String.LocalizationValue(stringLiteral: string)
  }
}
