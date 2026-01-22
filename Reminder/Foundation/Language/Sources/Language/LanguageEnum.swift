//
//  LanguageEnum.swift
//  SettingsTab
//
//  Created by Vitaliy Stepanenko on 20.11.2025.
//

public enum LanguageEnum: String, CaseIterable, Identifiable {
  case eng
  case ukr
  
  public init?(id: String) {
    self.init(rawValue: id)
  }
  
  public var id: String {
    rawValue
  }
  
  public var languageCode: String {
    switch self {
      case .eng:
      return "en"
    case .ukr:
      return "uk"
    }
  }
//
//  var title: String {
//    switch self {
//    case .eng:
//      return "English"
//    case .ukr:
//      return "Українська"
//    }
//  }
}
