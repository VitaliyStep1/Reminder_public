//
//  ClosestCoordinator.swift
//  ClosestTab
//
//  Created by OpenAI's ChatGPT.
//

import SwiftUI
import NavigationContracts
import MainTabViewContracts
import DomainContracts
import Event

@MainActor
public final class ClosestCoordinator: ClosestCoordinatorProtocol {
  public var router: any ClosestRouterProtocol
  private let closestScreenBuilder: ClosestScreenBuilder
  private let eventCoordinator: EventCoordinatorProtocol

  public init(
    router: any ClosestRouterProtocol,
    closestScreenBuilder: @escaping ClosestScreenBuilder,
    eventCoordinator: EventCoordinatorProtocol) {
      self.router = router
    self.closestScreenBuilder = closestScreenBuilder
    self.eventCoordinator = eventCoordinator
  }

  public func start() -> AnyView {
    let view = closestScreenBuilder()
    return AnyView(view)
  }
  
  public func destination(for route: ClosestRoute) -> AnyView {
    switch route {
    case .event(let eventId):
      let view = eventCoordinator.startRead(
        eventId: eventId,
        eventCategoryEventWasUpdatedDelegate: router)
      return AnyView(view)
    default:
      return AnyView(EmptyView())
    }
  }
  
  public func popScreen() {
    router.popScreen()
  }
  
  public func pushScreen(_ route: ClosestRoute) {
    router.pushScreen(route)
  }
  
  @MainActor
  public func categoryEventWasUpdated(newCategoryId: Identifier?) {
    
  }
}
