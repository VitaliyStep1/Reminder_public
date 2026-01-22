//
//  EventFeatureAssembly.swift
//  AppDI
//
//  Created by Vitaliy Stepanenko on 22.12.2025.
//

import SwiftUI
import Swinject
import Event
import DomainContracts
import UserDefaultsStorage
import Platform
import Configurations
import AnalyticsContracts

@MainActor
struct EventFeatureAssembly: Assembly {
  func assemble(container: Container) {
    container.register(EventViewStore.self) { resolver, eventScreenViewType, categoryEventWasUpdatedDelegate in
      //      let categoryEventWasUpdatedDelegate = resolver.resolve(CreateRouterProtocol.self)!
      return EventViewStore(eventScreenViewType: eventScreenViewType, categoryEventWasUpdatedDelegate: categoryEventWasUpdatedDelegate)
    }
    
    container.register(EventPresenter.self) { _, store in
      EventPresenter(store: store)
    }
    
    container.register(EventInteractor.self) { resolver, store, presenter, coordinator in
      let createEventUseCase = resolver.resolve(CreateEventUseCaseProtocol.self)!
      let editEventUseCase = resolver.resolve(EditEventUseCaseProtocol.self)!
      let deleteEventUseCase = resolver.resolve(DeleteEventUseCaseProtocol.self)!
      let fetchEventUseCase = resolver.resolve(FetchEventUseCaseProtocol.self)!
      let fetchCategoryUseCase = resolver.resolve(FetchCategoryUseCaseProtocol.self)!
      let fetchDefaultRemindTimeDateUseCase = resolver.resolve(FetchDefaultRemindTimeDateUseCaseProtocol.self)!
      let generateNewRemindsUseCase = resolver.resolve(GenerateNewRemindsUseCaseProtocol.self)!
      let fetchIsLocalNotificationsPermissionUseCase = resolver.resolve(FetchIsLocalNotificationsPermissionUseCaseProtocol.self)!
      let requestLocalNotificationsPermissionUseCase = resolver.resolve(RequestLocalNotificationsPermissionUseCaseProtocol.self)!
      let saveEventUseCase = resolver.resolve(SaveEventUseCaseProtocol.self)!
      let localNotificationService = resolver.resolve(LocalNotificationServiceProtocol.self)!
      let userDefaultsService = resolver.resolve(UserDefaultsServiceProtocol.self)!
      let appConfiguration = resolver.resolve(AppConfigurationProtocol.self)!
      let analyticsService = resolver.resolve(AnalyticsServiceProtocol.self)!

      return EventInteractor(
        createEventUseCase: createEventUseCase,
        editEventUseCase: editEventUseCase,
        deleteEventUseCase: deleteEventUseCase,
        fetchEventUseCase: fetchEventUseCase,
        fetchCategoryUseCase: fetchCategoryUseCase,
        fetchDefaultRemindTimeDateUseCase: fetchDefaultRemindTimeDateUseCase,
        generateNewRemindsUseCase: generateNewRemindsUseCase,
        fetchIsLocalNotificationsPermissionUseCase: fetchIsLocalNotificationsPermissionUseCase,
        requestLocalNotificationsPermissionUseCase: requestLocalNotificationsPermissionUseCase,
        saveEventUseCase: saveEventUseCase,
        localNotificationService: localNotificationService,
        userDefaultsService: userDefaultsService,
        appConfiguration: appConfiguration,
        analyticsService: analyticsService,
        presenter: presenter,
        store: store,
        coordinator: coordinator
      )
    }

    container.register(EventScreenBuilder.self) { r in
      { eventScreenViewType, categoryEventWasUpdatedDelegate, coordinator in
        let eventViewStore = r.resolve(EventViewStore.self, arguments: eventScreenViewType, categoryEventWasUpdatedDelegate)!
        let eventPresenter = r.resolve(EventPresenter.self, argument: eventViewStore)!
        let eventInteractor = r.resolve(EventInteractor.self, arguments: eventViewStore, eventPresenter, coordinator)!
        return EventScreenView(store: eventViewStore, interactor: eventInteractor)
      }
    }

    container.register(EventReadScreenBuilder.self) { r in
      { eventId, coordinator in
        let fetchEventUseCase = r.resolve(FetchEventUseCaseProtocol.self)!
        let fetchCategoryUseCase = r.resolve(FetchCategoryUseCaseProtocol.self)!
        let generateNewRemindsUseCase = r.resolve(GenerateNewRemindsUseCaseProtocol.self)!
        let fetchIsLocalNotificationsPermissionUseCase = r.resolve(FetchIsLocalNotificationsPermissionUseCaseProtocol.self)!
        let fetchScheduledNotificationsIdsUseCase = r.resolve(FetchScheduledNotificationsIdsUseCaseProtocol.self)!
        let viewModel = EventReadViewModel(
          eventId: eventId,
          fetchEventUseCase: fetchEventUseCase,
          fetchCategoryUseCase: fetchCategoryUseCase,
          generateNewRemindsUseCase: generateNewRemindsUseCase,
          fetchIsLocalNotificationsPermissionUseCase: fetchIsLocalNotificationsPermissionUseCase,
          fetchScheduledNotificationsIdsUseCase: fetchScheduledNotificationsIdsUseCase,
          coordinator: coordinator
        )
        return EventReadScreenView(
          viewModel: viewModel
        )
      }
    }
    
    container.register(EventRouterProtocol.self) { _ in
      EventRouter()
    }
    .inObjectScope(.container)

    container.register(EventCoordinatorProtocol.self) { r in
      let router = r.resolve(EventRouterProtocol.self)!
      let eventScreenBuilder = r.resolve(EventScreenBuilder.self)!
      let eventReadScreenBuilder = r.resolve(EventReadScreenBuilder.self)!
      return EventCoordinator(router: router, eventReadScreenBuilder: eventReadScreenBuilder, eventScreenBuilder: eventScreenBuilder)
    }
  }
}
