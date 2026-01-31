//
//  AppServicesAssembly.swift
//  AppDI
//
//  Created by Vitaliy Stepanenko on 28.01.2026.
//

import Swinject
import AppServicesContracts
import AppServices
import PersistenceContracts
import DomainContracts
import Platform
import Configurations
import Language
import UserDefaultsStorage

struct AppServicesAssembly: Assembly {
  func assemble(container: Container) {
    container.register(DefaultCategoriesDataServiceProtocol.self) { _ in
      DefaultCategoriesDataService()
    }
    .inObjectScope(.container)
    
    container.register(UpdateNotificationsServiceProtocol.self) { resolver in
      let dbEventsService = resolver.resolve(DBEventsServiceProtocol.self)!
      let dBCategoriesService = resolver.resolve(DBCategoriesServiceProtocol.self)!
      let scheduleNotificationsService = resolver.resolve(ScheduleNotificationsServiceProtocol.self)!
      let calculateRemindDatesForEventService = resolver.resolve(CalculateRemindDatesForEventServiceProtocol.self)!
      return UpdateNotificationsService(
        dbEventsService: dbEventsService,
        dbCategoriesService: dBCategoriesService,
        scheduleNotificationsService: scheduleNotificationsService,
        calculateRemindDatesForEventService: calculateRemindDatesForEventService
      )
    }
    .inObjectScope(.container)
    
    container.register(ScheduleNotificationsServiceProtocol.self) { resolver in
      let localNotificationService = resolver.resolve(LocalNotificationServiceProtocol.self)!
      let appConfiguration = resolver.resolve(AppConfigurationProtocol.self)!
      let takeSettingsLanguageUseCase = resolver.resolve(TakeSettingsLanguageUseCaseProtocol.self)!
      
      return ScheduleNotificationsService(
        localNotificationService: localNotificationService,
        appConfiguration: appConfiguration,
        takeSettingsLanguageUseCase: takeSettingsLanguageUseCase
      )
    }
    .inObjectScope(.transient)
    
    container.register(DefaultRemindTimeServiceProtocol.self) { resolver in
      let appConfiguration = resolver.resolve(AppConfigurationProtocol.self)!
      let userDefaultsService = resolver.resolve(UserDefaultsServiceProtocol.self)!
      
      return DefaultRemindTimeService(appConfiguration: appConfiguration, userDefaultsService: userDefaultsService)
    }
    .inObjectScope(.container)
  }
}
