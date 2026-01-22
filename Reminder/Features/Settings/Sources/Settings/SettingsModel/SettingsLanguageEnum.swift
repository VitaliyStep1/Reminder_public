//
//  SettingsLanguageEnum.swift
//  SettingsTab
//
//  Created by Vitaliy Stepanenko on 20.11.2025.
//

import Language

enum SettingsLanguageEnum: String, CaseIterable, Identifiable {
  case eng
  case ukr
  
  init(languageEnum: LanguageEnum) {
    switch languageEnum {
    case .eng:
      self = .eng
    case .ukr:
      self = .ukr
    }
  }
  
  var id: String {
    rawValue
  }
  
  var languageEnum : LanguageEnum {
    switch self {
    case .eng:
      return .eng
    case .ukr:
      return .ukr
    }
  }
  
  var title: String {
    switch self {
    case .eng:
      return "English"
    case .ukr:
      return "Українська"
    }
  }
}
