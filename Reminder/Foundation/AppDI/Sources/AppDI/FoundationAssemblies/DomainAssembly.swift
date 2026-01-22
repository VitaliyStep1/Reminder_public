//
//  DomainAssembly.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 03.12.2025.
//

import Swinject
import AppServices
import AppServicesContracts
import DomainContracts
import Domain
import PersistenceContracts
import Configurations
import UserDefaultsStorage
import Platform
import Language

struct DomainAssembly: Assembly {
  func assemble(container: Container) {

    container.register(DefaultCategoriesDataServiceProtocol.self) { _ in
      DefaultCategoriesDataService()
    }
    .inObjectScope(.container)

    container.register(SetupInitialDataUseCaseProtocol.self) { resolver in
      let defaultCategoriesDataService = resolver.resolve(DefaultCategoriesDataServiceProtocol.self)!
      let dBCategoriesService = resolver.resolve(DBCategoriesServiceProtocol.self)!
      return SetupInitialDataUseCase(
        defaultCategoriesDataService: defaultCategoriesDataService,
        dBCategoriesService: dBCategoriesService
      )
    }
    .inObjectScope(.transient)

    container.register(FetchAllCategoriesUseCaseProtocol.self) { resolver in
      let dBCategoriesService = resolver.resolve(DBCategoriesServiceProtocol.self)!
      return FetchAllCategoriesUseCase(dBCategoriesService: dBCategoriesService)
    }
    .inObjectScope(.transient)

    container.register(FetchCategoryUseCaseProtocol.self) { resolver in
      let dBCategoriesService = resolver.resolve(DBCategoriesServiceProtocol.self)!
      return FetchCategoryUseCase(dBCategoriesService: dBCategoriesService)
    }
    .inObjectScope(.transient)

    container.register(FetchEventsUseCaseProtocol.self) { resolver in
      let dBEventsService = resolver.resolve(DBEventsServiceProtocol.self)!
      return FetchEventsUseCase(dBEventsService: dBEventsService)
    }
    .inObjectScope(.transient)

    container.register(FetchEventUseCaseProtocol.self) { resolver in
      let dBEventsService = resolver.resolve(DBEventsServiceProtocol.self)!
      return FetchEventUseCase(dBEventsService: dBEventsService)
    }
    .inObjectScope(.transient)

    container.register(CreateEventUseCaseProtocol.self) { resolver in
      let dBEventsService = resolver.resolve(DBEventsServiceProtocol.self)!
      let dBCategoriesService = resolver.resolve(DBCategoriesServiceProtocol.self)!
      return CreateEventUseCase(dBEventsService: dBEventsService, dBCategoriesService: dBCategoriesService)
    }
    .inObjectScope(.transient)

    container.register(EditEventUseCaseProtocol.self) { resolver in
      let dBEventsService = resolver.resolve(DBEventsServiceProtocol.self)!
      let dBCategoriesService = resolver.resolve(DBCategoriesServiceProtocol.self)!
      return EditEventUseCase(dBEventsService: dBEventsService, dBCategoriesService: dBCategoriesService)
    }
    .inObjectScope(.transient)

    container.register(DeleteEventUseCaseProtocol.self) { resolver in
      let dBEventsService = resolver.resolve(DBEventsServiceProtocol.self)!
      return DeleteEventUseCase(dBEventsService: dBEventsService)
    }
    .inObjectScope(.transient)
    
    container.register(GenerateNewRemindsUseCaseProtocol.self) { resolver in
      return GenerateNewRemindsUseCase()
    }
    .inObjectScope(.transient)

    container.register(FetchIsLocalNotificationsPermissionUseCaseProtocol.self) { resolver in
      return FetchIsLocalNotificationsPermissionUseCase()
    }
    .inObjectScope(.transient)

    container.register(RequestLocalNotificationsPermissionUseCaseProtocol.self) { resolver in
      return RequestLocalNotificationsPermissionUseCase()
    }
    .inObjectScope(.transient)

    container.register(UpdateNotificationsServiceProtocol.self) { resolver in
      let dbEventsService = resolver.resolve(DBEventsServiceProtocol.self)!
      let dBCategoriesService = resolver.resolve(DBCategoriesServiceProtocol.self)!
      let scheduleNotificationsService = resolver.resolve(ScheduleNotificationsServiceProtocol.self)!
      return UpdateNotificationsService(
        dbEventsService: dbEventsService,
        dBCategoriesService: dBCategoriesService,
        scheduleNotificationsService: scheduleNotificationsService
      )
    }
    .inObjectScope(.container)

    container.register(UpdateNotificationsUseCaseProtocol.self) { resolver in
      let updateNotificationsService = resolver.resolve(UpdateNotificationsServiceProtocol.self)!
      let userDefaultsService = resolver.resolve(UserDefaultsServiceProtocol.self)!

      return UpdateNotificationsUseCase(
        updateNotificationsService: updateNotificationsService,
        userDefaultsService: userDefaultsService
      )
    }
    .inObjectScope(.transient)

    container.register(FetchAllFutureEventsUseCaseProtocol.self) { resolver in
      let dbEventsService = resolver.resolve(DBEventsServiceProtocol.self)!
      return FetchAllFutureEventsUseCase(dbEventsService: dbEventsService)
    }
    .inObjectScope(.transient)

    container.register(FetchScheduledNotificationsIdsUseCaseProtocol.self) { _ in
      FetchScheduledNotificationsIdsUseCase()
    }
    .inObjectScope(.transient)

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

    container.register(SaveEventUseCaseProtocol.self) { resolver in
      let createEventUseCase = resolver.resolve(CreateEventUseCaseProtocol.self)!
      let editEventUseCase = resolver.resolve(EditEventUseCaseProtocol.self)!
      let fetchIsLocalNotificationsPermissionUseCase = resolver.resolve(FetchIsLocalNotificationsPermissionUseCaseProtocol.self)!
      let requestLocalNotificationsPermissionUseCase = resolver.resolve(RequestLocalNotificationsPermissionUseCaseProtocol.self)!
      let scheduleNotificationsService = resolver.resolve(ScheduleNotificationsServiceProtocol.self)!

      return SaveEventUseCase(
        createEventUseCase: createEventUseCase,
        editEventUseCase: editEventUseCase,
        fetchIsLocalNotificationsPermissionUseCase: fetchIsLocalNotificationsPermissionUseCase,
        requestLocalNotificationsPermissionUseCase: requestLocalNotificationsPermissionUseCase,
        scheduleNotificationsService: scheduleNotificationsService
      )
    }
    .inObjectScope(.transient)
  }
}
