//
//  ClosestFeatureAssembly.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 03.12.2025.
//

import SwiftUI
import Swinject
import Closest
import MainTabViewContracts
import DomainContracts
import Event
import Configurations

@MainActor
struct ClosestFeatureAssembly: Assembly {
  func assemble(container: Container) {
    container.register(ClosestViewModel.self) { r in
      let fetchAllEventsUseCase = r.resolve(FetchAllFutureEventsUseCaseProtocol.self)!
      let fetchAllCategoriesUseCase = r.resolve(FetchAllCategoriesUseCaseProtocol.self)!
      let fetchScheduledNotificationsIdsUseCase = r.resolve(FetchScheduledNotificationsIdsUseCaseProtocol.self)!
      let mainTabViewSelectionState = r.resolve(MainTabViewSelectionState.self)!
      let closestCoordinator = r.resolve(ClosestCoordinator.self)!
      let appConfiguration = r.resolve(AppConfigurationProtocol.self)!
      return ClosestViewModel(
        fetchAllEventsUseCase: fetchAllEventsUseCase,
        fetchAllCategoriesUseCase: fetchAllCategoriesUseCase,
        fetchScheduledNotificationsIdsUseCase: fetchScheduledNotificationsIdsUseCase,
        mainTabViewSelectionState: mainTabViewSelectionState,
        coordinator: closestCoordinator,
        isWithBanner: appConfiguration.isWithBanner
      )
    }
    
    container.register(ClosestRouterProtocol.self) { _ in
      ClosestRouter()
    }
    .inObjectScope(.container)
    
    container.register(ClosestCoordinator.self) { r in
      let closestScreenBuilder = r.resolve(ClosestScreenBuilder.self)!
      let router = r.resolve(ClosestRouterProtocol.self)!
      let eventCoordinator = r.resolve(EventCoordinatorProtocol.self, name: "closest")!
      return ClosestCoordinator(router: router, closestScreenBuilder: closestScreenBuilder, eventCoordinator: eventCoordinator)
    }
    .inObjectScope(.container)
    
    container.register(ClosestScreenBuilder.self) { r in
      {
        let closestViewModel = r.resolve(ClosestViewModel.self)!
        let eventCoordinator = r.resolve(EventCoordinatorProtocol.self, name: "closest")!
        return ClosestScreenView(
          viewModel: closestViewModel,
          eventCoordinator: eventCoordinator
        )
      }
    }

    container.register(EventCoordinatorProtocol.self, name: "closest") { r in
      let router = r.resolve(ClosestRouterProtocol.self)!
      let eventScreenBuilder = r.resolve(EventScreenBuilder.self)!
      let eventReadScreenBuilder = r.resolve(EventReadScreenBuilder.self)!
      return EventCoordinator(router: router as! EventRouterProtocol, eventReadScreenBuilder: eventReadScreenBuilder, eventScreenBuilder: eventScreenBuilder)
    }
    .inObjectScope(.container)
  }
}
