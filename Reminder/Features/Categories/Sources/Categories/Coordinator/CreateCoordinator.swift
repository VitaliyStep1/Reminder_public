//
//  CreateCoordinator.swift
//  CategoriesTab
//
//  Created by OpenAI's ChatGPT.
//

import SwiftUI
import NavigationContracts
import DomainContracts
import Event

@MainActor
public final class CreateCoordinator: CreateCoordinatorProtocol {
  public let router: any CreateRouterProtocol
  
  private let categoriesScreenBuilder: CategoriesScreenBuilder
  private let categoryScreenBuilder: CategoryScreenBuilder
  private let eventCoordinator: EventCoordinatorProtocol

  public init(
    router: any CreateRouterProtocol,
    categoriesScreenBuilder: @escaping CategoriesScreenBuilder,
    categoryScreenBuilder: @escaping CategoryScreenBuilder,
    eventCoordinator: EventCoordinatorProtocol
  ) {
    self.router = router
    self.categoriesScreenBuilder = categoriesScreenBuilder
    self.categoryScreenBuilder = categoryScreenBuilder
    self.eventCoordinator = eventCoordinator
  }

  public func start() -> AnyView {
    let view = categoriesScreenBuilder()
    return AnyView(view)
  }

  public func destination(for route: CreateRoute) -> AnyView {
    switch route {
    case .category(let categoryId):
      let view = categoryScreenBuilder(categoryId)
      return AnyView(view)
    case .event(let eventScreenViewType):
      let view = eventCoordinator.start(
        eventScreenViewType: eventScreenViewType,
        eventCategoryEventWasUpdatedDelegate: router)
      return AnyView(view)
    default:
      return AnyView(EmptyView())
    }
  }
  
  public func categoriesScreenCategoryWasClicked(categoryId: Identifier) {
    router.pushScreen(.category(categoryId))
  }
}
