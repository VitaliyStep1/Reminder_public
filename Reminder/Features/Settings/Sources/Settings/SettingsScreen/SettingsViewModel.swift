//
//  SettingsViewModel.swift
//  SettingsTab
//
//  Created by Vitaliy Stepanenko on 24.10.2025.
//

import Foundation
import Configurations
import DomainContracts
import Language

@MainActor
public final class SettingsViewModel: ObservableObject {
  let appConfiguration: AppConfigurationProtocol
  let takeDefaultRemindTimeDateUseCase: TakeDefaultRemindTimeDateUseCaseProtocol
  let updateDefaultRemindTimeDateUseCase: UpdateDefaultRemindTimeDateUseCaseProtocol

  let takeSettingsLanguageUseCase: TakeSettingsLanguageUseCaseProtocol
  let updateSettingsLanguageUseCase: UpdateSettingsLanguageUseCaseProtocol
  
  @Published public var defaultRemindTimeDate: Date {
    didSet {
      guard defaultRemindTimeDate != oldValue else {
        return
      }
      
      updateDefaultRemindTimeDateUseCase.execute(date: defaultRemindTimeDate)
    }
  }
  
  let languageOptionViewStore: SettingsLanguageOptionViewStore

  public init(
    appConfiguration: AppConfigurationProtocol,
    takeDefaultRemindTimeDateUseCase: TakeDefaultRemindTimeDateUseCaseProtocol,
    updateDefaultRemindTimeDateUseCase: UpdateDefaultRemindTimeDateUseCaseProtocol,
    takeSettingsLanguageUseCase: TakeSettingsLanguageUseCaseProtocol,
    updateSettingsLanguageUseCase: UpdateSettingsLanguageUseCaseProtocol
  ) {
    self.appConfiguration = appConfiguration
    self.takeDefaultRemindTimeDateUseCase = takeDefaultRemindTimeDateUseCase
    self.updateDefaultRemindTimeDateUseCase = updateDefaultRemindTimeDateUseCase
    self.takeSettingsLanguageUseCase = takeSettingsLanguageUseCase
    self.updateSettingsLanguageUseCase = updateSettingsLanguageUseCase
    
    languageOptionViewStore = SettingsLanguageOptionViewStore {
      let languageEnum = $0.languageEnum
      updateSettingsLanguageUseCase.execute(language: languageEnum)
    }
    
    self.defaultRemindTimeDate = takeDefaultRemindTimeDateUseCase.execute()
    
    let settingsLanguage = takeSettingsLanguageUseCase.execute()
    self.languageOptionViewStore.setSettingsLanguage(settingsLanguage)
  }

  var supportEmail: String { appConfiguration.supportEmail }

  var supportEmailURL: URL? {
    var components = URLComponents()
    components.scheme = "mailto"
    components.path = supportEmail
    components.queryItems = [
      URLQueryItem(name: "subject", value: "Event - Birthday reminder")
    ]

    return components.url
  }

  var appStoreURL: URL? {
    URL(string: "itms-apps://itunes.apple.com/app/id\(appConfiguration.appstoreId)?action=write-review")
  }

  var privacyPolicyURL: URL? {
    appConfiguration.privacyPolicyURL
  }

  var termsOfUseURL: URL? {
    let termsOfUseURL: URL?
    let languageEnum = languageOptionViewStore.selectedLanguage.languageEnum
    switch languageEnum {
    case .eng:
      termsOfUseURL = appConfiguration.termsOfUseURL_en
    case .ukr:
      termsOfUseURL = appConfiguration.termsOfUseURL_uk
    }
    
    return termsOfUseURL
  }
}
