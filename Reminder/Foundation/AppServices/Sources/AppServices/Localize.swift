//
//  Localize.swift
//  AppServices
//
//  Created by Vitaliy Stepanenko on 14.01.2026.
//

import SwiftUI

enum Localize {
  private static let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
  private static func localizedResource(_ localizationValue: String.LocalizationValue) -> LocalizedStringResource {
    .init(localizationValue, bundle: Localize.bundleDescription)
  }

  static var birthdays: LocalizedStringResource { localizedResource("birthdays") }
  static var aniversaries: LocalizedStringResource { localizedResource("aniversaries") }
}
