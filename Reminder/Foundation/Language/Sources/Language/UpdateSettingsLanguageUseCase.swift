//
//  UpdateSettingsLanguageUseCaseProtocol.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 21.11.2025.
//

import Foundation
import UserDefaultsStorage

public class UpdateSettingsLanguageUseCase: UpdateSettingsLanguageUseCaseProtocol {
  private let userDefaultsService: UserDefaultsServiceProtocol
  private let languageService: LanguageService
  
  public init(userDefaultsService: UserDefaultsServiceProtocol, languageService: LanguageService) {
    self.userDefaultsService = userDefaultsService
    self.languageService = languageService
  }
  
  public func execute(language: LanguageEnum) {
    userDefaultsService.settingsLanguageId = language.id
    changeLanguageInUI(language: language)
  }
  
  private func changeLanguageInUI(language: LanguageEnum) {
    languageService.updateLanguage(language)
    
    let languageCode: String
    switch language {
    case .eng:
      languageCode = "en"
    case .ukr:
      languageCode = "uk"
    }
    
    UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
    UserDefaults.standard.synchronize()
  }
}
