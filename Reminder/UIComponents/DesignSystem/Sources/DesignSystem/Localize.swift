//
//  Localize.swift
//  DesignSystem
//
//  Created by OpenAI Assistant on 28.11.2025.
//
import SwiftUI

enum Localize {
  private static let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
  private static func localizedResource(_ localizationValue: String.LocalizationValue) -> LocalizedStringResource {
    .init(localizationValue, bundle: Localize.bundleDescription)
  }

  static var delete: LocalizedStringResource { localizedResource("delete") }
  static var cancel: LocalizedStringResource { localizedResource("cancel") }
  static var error: LocalizedStringResource { localizedResource("error") }
  static var ok: LocalizedStringResource { localizedResource("ok") }
}
