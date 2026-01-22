//
//  SettingsLanguageOptionViewStore.swift
//  SettingsTab
//
//  Created by Vitaliy Stepanenko on 20.11.2025.
//

import SwiftUI
import Language

@Observable
class SettingsLanguageOptionViewStore {
  var selectedLanguage: SettingsLanguageEnum = .eng
  let languages: [SettingsLanguageEnum] = SettingsLanguageEnum.allCases
  
  let selectedLanguageChangedHandler: (SettingsLanguageEnum) -> Void
  
  init(selectedLanguageChangedHandler: @escaping (SettingsLanguageEnum) -> Void) {
    self.selectedLanguageChangedHandler = selectedLanguageChangedHandler
  }
  
  func setSettingsLanguage(_ language: LanguageEnum) {
    self.selectedLanguage = SettingsLanguageEnum(languageEnum: language)
  }
}
