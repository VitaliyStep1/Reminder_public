//
//  CategoryLocalizationManager.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 28.11.2025.
//

import Foundation
import AppServices

public class CategoryLocalizationManager {
  public static let shared = CategoryLocalizationManager()
  private init() {}
  
  lazy var categoryTitleEnumDict: [String: DefaultCategoriesDataService.CategoryKeyEnum] = {
    var dict: [String: DefaultCategoriesDataService.CategoryKeyEnum] = [:]
    for value in DefaultCategoriesDataService.CategoryKeyEnum.allCases {
      dict[value.key] = value
    }
    return dict
  }()
  
  public func localize(categoryTitle: String, locale: Locale) -> String {
    guard let categoryKeyEnum = categoryTitleEnumDict[categoryTitle] else {
      return categoryTitle
    }
    var resource = Localize.localized(categoryKey: categoryKeyEnum)
    resource.locale = locale
    return String(localized: resource)
  }
}
