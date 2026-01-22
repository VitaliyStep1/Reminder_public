//
//  EventCoordinator.swift
//  Event
//
//  Created by Vitaliy Stepanenko on 22.12.2025.
//

import SwiftUI
import NavigationContracts
import DomainContracts

@MainActor
public final class EventCoordinator: EventCoordinatorProtocol {
  public let router: any EventRouterProtocol
  
  private let eventReadScreenBuilder: EventReadScreenBuilder
  private let eventScreenBuilder: EventScreenBuilder

  public init(
    router: EventRouterProtocol,
    eventReadScreenBuilder: @escaping EventReadScreenBuilder,
    eventScreenBuilder: @escaping EventScreenBuilder
  ) {
    self.router = router
    self.eventScreenBuilder = eventScreenBuilder
    self.eventReadScreenBuilder = eventReadScreenBuilder
  }
  
  public func start(eventScreenViewType: EventScreenViewType,
                    eventCategoryEventWasUpdatedDelegate: EventCategoryEventWasUpdatedDelegate?) -> AnyView {
    let view = eventScreenBuilder(eventScreenViewType, eventCategoryEventWasUpdatedDelegate, self)
    return AnyView(view)
  }

  public func startRead(eventId: Identifier,
                        eventCategoryEventWasUpdatedDelegate: EventCategoryEventWasUpdatedDelegate?) -> AnyView {
    let view = eventReadScreenBuilder(eventId, self)
    return AnyView(view)
  }
  
  public func destination(for route: EventRoute) -> AnyView {
    switch route {
    case .event(let eventScreenViewType):
      let view = self.start(
        eventScreenViewType: eventScreenViewType,
        eventCategoryEventWasUpdatedDelegate: nil)
      return AnyView(view)
    default:
      return AnyView(EmptyView())
    }
  }
  
  public func editEventButtonWasClicked(eventId: Identifier, source: EventScreenViewSource) {
    router.pushScreen(.event(.edit(eventId: eventId, source: source)))
  }
}
