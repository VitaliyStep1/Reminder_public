//
//  Localize.swift
//  Closest
//
//  Created by Vitaliy Stepanenko on 28.11.2025.
//
import SwiftUI

enum Localize {
  private static let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
  private static func localizedResource(_ localizationValue: String.LocalizationValue) -> LocalizedStringResource {
    .init(localizationValue, bundle: Localize.bundleDescription)
  }
  
  static var closestScreenTitle: LocalizedStringResource {
    localizedResource("closestScreenTitle")
  }
  static var closestAllFilterTitle: LocalizedStringResource {
    localizedResource("closestAllFilterTitle")
  }
  static var closestCreateEventButtonTitle: LocalizedStringResource {
    localizedResource("closestCreateEventButtonTitle")
  }
  static var closestAddEventButtonTitle: LocalizedStringResource {
    localizedResource("closestAddEventButtonTitle")
  }
  static var closestNoEventsText: LocalizedStringResource {
    localizedResource("closestNoEventsText")
  }
  static var closestEventsCountFormat: LocalizedStringResource {
    localizedResource("closestEventsCountFormat")
  }
  static var closestThisMonthTitle: LocalizedStringResource {
    localizedResource("closestThisMonthTitle")
  }
  static var closestNextMonthTitle: LocalizedStringResource {
    localizedResource("closestNextMonthTitle")
  }
  static var closestTodayTitle: LocalizedStringResource {
    localizedResource("closestTodayTitle")
  }
  static var closestTomorrowTitle: LocalizedStringResource {
    localizedResource("closestTomorrowTitle")
  }
}
