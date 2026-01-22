//
//  LanguageService.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 21.11.2025.
//

import Foundation

//@MainActor
//@Observable
public class LanguageService: ObservableObject {
  let takeSettingsLanguageUseCase: TakeSettingsLanguageUseCaseProtocol

  @Published public private(set) var locale: Locale
  
  public init(takeSettingsLanguageUseCase: TakeSettingsLanguageUseCaseProtocol) {
    self.takeSettingsLanguageUseCase = takeSettingsLanguageUseCase
    
    let language = takeSettingsLanguageUseCase.execute()
    
    switch language {
    case .ukr:
      locale =  Locale(identifier: "uk")
    case .eng:
      locale =  Locale(identifier: "en")
    }
  }

  private func makeLocale(from languageEnum: LanguageEnum) -> Locale {
    switch languageEnum {
    case .ukr:
      return Locale(identifier: "uk")
    case .eng:
      return Locale(identifier: "en")
    }
  }
  
  public func updateLanguage(_ languageEnum: LanguageEnum) {
    locale = makeLocale(from: languageEnum)
  }
}
