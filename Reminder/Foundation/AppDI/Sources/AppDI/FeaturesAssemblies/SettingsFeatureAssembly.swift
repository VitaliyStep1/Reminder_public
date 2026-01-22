//
//  SettingsFeatureAssembly.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 03.12.2025.
//

import Swinject
import DomainContracts
import Language
import Settings
import Configurations

@MainActor
struct SettingsFeatureAssembly: Assembly {
  func assemble(container: Container) {
    container.register(SettingsViewModel.self) { resolver in
      let appConfiguration = resolver.resolve(AppConfigurationProtocol.self)!
      let takeDefaultRemindTimeDateUseCase = resolver.resolve(TakeDefaultRemindTimeDateUseCaseProtocol.self)!
      let updateDefaultRemindTimeDateUseCase = resolver.resolve(UpdateDefaultRemindTimeDateUseCaseProtocol.self)!

      let takeSettingsLanguageUseCase = resolver.resolve(TakeSettingsLanguageUseCaseProtocol.self)!
      let updateSettingsLanguageUseCase = resolver.resolve(UpdateSettingsLanguageUseCaseProtocol.self)!

      return SettingsViewModel(
        appConfiguration: appConfiguration,
        takeDefaultRemindTimeDateUseCase: takeDefaultRemindTimeDateUseCase,
        updateDefaultRemindTimeDateUseCase: updateDefaultRemindTimeDateUseCase,
        takeSettingsLanguageUseCase: takeSettingsLanguageUseCase,
        updateSettingsLanguageUseCase: updateSettingsLanguageUseCase
      )
    }

    container.register(SettingsCoordinator.self) { resolver in
      let settingsScreenBuilder = resolver.resolve(SettingsScreenBuilder.self)!
      return SettingsCoordinator(settingsScreenBuilder: settingsScreenBuilder)
    }
    .inObjectScope(.container)

    container.register(SettingsScreenBuilder.self) { resolver in
      {
        let settingsViewModel = resolver.resolve(SettingsViewModel.self)!
        return SettingsScreenView(viewModel: settingsViewModel)
      }
    }
  }
}
