//
//  CreateFeatureAssembly.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 03.12.2025.
//

import SwiftUI
import Swinject
import Categories
import Event
import Domain
import DomainContracts
import NavigationContracts
import Configurations
import UserDefaultsStorage

@MainActor
struct CreateFeatureAssembly: Assembly {
  func assemble(container: Container) {
    container.register(CategoriesViewModel.self) { r in
      let fetchAllCategoriesUseCase = r.resolve(FetchAllCategoriesUseCaseProtocol.self)!
      let appConfiguration = r.resolve(AppConfigurationProtocol.self)!
      let coordinator = r.resolve(CreateCoordinator.self)!
      return CategoriesViewModel(
        fetchAllCategoriesUseCase: fetchAllCategoriesUseCase,
        coordinator: coordinator,
        isWithBanner: appConfiguration.isWithBanner
      )
    }

    container.register(CreateRouterProtocol.self) { _ in
      CreateRouter()
    }
    .inObjectScope(.container)
    
    container.register(CategoryViewModel.self) { (r: Resolver, categoryId: Identifier) in
      let fetchEventsUseCase = r.resolve(FetchEventsUseCaseProtocol.self)!
      let fetchCategoryUseCase = r.resolve(FetchCategoryUseCaseProtocol.self)!
      let appConfiguration = r.resolve(AppConfigurationProtocol.self)!
      let router = r.resolve(CreateRouterProtocol.self)!
      let userDefaultsService = r.resolve(UserDefaultsServiceProtocol.self)!
      return CategoryViewModel(
        categoryId: categoryId,
        fetchEventsUseCase: fetchEventsUseCase,
        fetchCategoryUseCase: fetchCategoryUseCase,
        userDefaultsService: userDefaultsService,
        router: router,
        isWithBanner: appConfiguration.isWithBanner
      )
    }
    .inObjectScope(.transient)

    container.register(EventCoordinatorProtocol.self, name: "create") { r in
      let router = r.resolve(CreateRouterProtocol.self)!
      let eventScreenBuilder = r.resolve(EventScreenBuilder.self)!
      let eventReadScreenBuilder = r.resolve(EventReadScreenBuilder.self)!
      return EventCoordinator(
        router: router as! EventRouterProtocol,
        eventReadScreenBuilder: eventReadScreenBuilder,
        eventScreenBuilder: eventScreenBuilder
      )
    }
    .inObjectScope(.container)

    container.register(CreateCoordinator.self) { r in
      let categoriesScreenBuilder = r.resolve(CategoriesScreenBuilder.self)!
      let categoryScreenBuilder = r.resolve(CategoryScreenBuilder.self)!
      let eventCoordinator = r.resolve(EventCoordinatorProtocol.self, name: "create")!

      let router = r.resolve(CreateRouterProtocol.self)!
      let coordinator = CreateCoordinator(router: router, categoriesScreenBuilder: categoriesScreenBuilder, categoryScreenBuilder: categoryScreenBuilder, eventCoordinator: eventCoordinator)
      return coordinator
    }
    .inObjectScope(.container)
    
    container.register(CategoryScreenBuilder.self) { r in
      { categoryId in
        let viewModel = r.resolve(CategoryViewModel.self, argument: categoryId)!
        return CategoryScreenView(viewModel: viewModel)
      }
    }
    
    container.register(CategoriesScreenBuilder.self) { r in
      {
        let viewModel = r.resolve(CategoriesViewModel.self)!
        return CategoriesScreenView(viewModel: viewModel)
      }
    }
  }
}
