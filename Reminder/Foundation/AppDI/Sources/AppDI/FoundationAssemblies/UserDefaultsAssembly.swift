//
//  UserDefaultsAssembly.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 03.12.2025.
//

import Swinject
import AppServices
import AppServicesContracts
import DomainContracts
import Domain
import Configurations
import UserDefaultsStorage

struct UserDefaultsAssembly: Assembly {
  func assemble(container: Container) {
    container.register(UserDefaultsServiceProtocol.self) { _ in
      UserDefaultsService()
    }
    .inObjectScope(.container)

    container.register(DefaultRemindTimeServiceProtocol.self) { resolver in
      let appConfiguration = resolver.resolve(AppConfigurationProtocol.self)!
      let userDefaultsService = resolver.resolve(UserDefaultsServiceProtocol.self)!

      return DefaultRemindTimeService(appConfiguration: appConfiguration, userDefaultsService: userDefaultsService)
    }
    .inObjectScope(.container)

    container.register(TakeDefaultRemindTimeDateUseCaseProtocol.self) { resolver in
      let defaultRemindTimeService = resolver.resolve(DefaultRemindTimeServiceProtocol.self)!
      return TakeDefaultRemindTimeDateUseCase(defaultRemindTimeService: defaultRemindTimeService)
    }
    .inObjectScope(.transient)

    container.register(UpdateDefaultRemindTimeDateUseCaseProtocol.self) { resolver in
      let userDefaultsService = resolver.resolve(UserDefaultsServiceProtocol.self)!
      return UpdateDefaultRemindTimeDateUseCase(userDefaultsService: userDefaultsService)
    }
    .inObjectScope(.transient)

    container.register(FetchDefaultRemindTimeDateUseCaseProtocol.self) { resolver in
      let defaultRemindTimeService = resolver.resolve(DefaultRemindTimeServiceProtocol.self)!
      return FetchDefaultRemindTimeDateUseCase(defaultRemindTimeService: defaultRemindTimeService)
    }
    .inObjectScope(.transient)
  }
}
