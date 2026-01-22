//
//  LanguageAssembly.swift
//  AppDI
//
//  Created by Vitaliy Stepanenko on 07.12.2025.
//

import Swinject
import Language
import UserDefaultsStorage

struct LanguageAssembly: Assembly {
  func assemble(container: Container) {
    container.register(LanguageService.self) { resolver in
      let takeSettingsLanguageUseCase = resolver.resolve(TakeSettingsLanguageUseCaseProtocol.self)!
      
      return LanguageService(takeSettingsLanguageUseCase: takeSettingsLanguageUseCase)
    }
    .inObjectScope(.container)
    
    container.register(TakeSettingsLanguageUseCaseProtocol.self) { resolver in
      let userDefaultsService = resolver.resolve(UserDefaultsServiceProtocol.self)!
      return TakeSettingsLanguageUseCase(userDefaultsService: userDefaultsService)
    }
    .inObjectScope(.transient)
    
    container.register(UpdateSettingsLanguageUseCaseProtocol.self) { resolver in
      let userDefaultsService = resolver.resolve(UserDefaultsServiceProtocol.self)!
      let languageService = resolver.resolve(LanguageService.self)!
      return UpdateSettingsLanguageUseCase(userDefaultsService: userDefaultsService, languageService: languageService)
    }
    .inObjectScope(.transient)
  }
}
