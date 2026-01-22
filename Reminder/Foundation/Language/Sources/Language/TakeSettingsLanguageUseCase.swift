//
//  TakeSettingsLanguageUseCase.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 20.11.2025.
//

import Foundation
import UserDefaultsStorage

public class TakeSettingsLanguageUseCase: TakeSettingsLanguageUseCaseProtocol {
  private let userDefaultsService: UserDefaultsServiceProtocol
  
  public init(userDefaultsService: UserDefaultsServiceProtocol) {
    self.userDefaultsService = userDefaultsService
  }
  
  public func execute() -> LanguageEnum {
    var language: LanguageEnum
    if let savedLanguageId = userDefaultsService.settingsLanguageId, let savedLanguage = LanguageEnum(id: savedLanguageId) {
      
      language = savedLanguage
    } else {
      let defaultLanguage = takeDefaultLanguage()
      language = defaultLanguage
    }
    return language
  }
  
  func takeDefaultLanguage() -> LanguageEnum {
    let locale = Locale.current
    let languageIdentifier = locale.language.languageCode?.identifier
    if languageIdentifier == "uk" {
      return .ukr
    }
    return .eng
  }
}
