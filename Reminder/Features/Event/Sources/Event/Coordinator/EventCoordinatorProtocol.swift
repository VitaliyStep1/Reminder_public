//
//  EventCoordinatorProtocol.swift
//  Event
//
//  Created by Vitaliy Stepanenko on 22.12.2025.
//

import SwiftUI
import DomainContracts

public protocol EventCoordinatorProtocol: AnyObject {
  var router: any EventRouterProtocol { get }
  func destination(for route: EventRoute) -> AnyView
  func editEventButtonWasClicked(eventId: Identifier, source: EventScreenViewSource)
  
  func start(eventScreenViewType: EventScreenViewType,
             eventCategoryEventWasUpdatedDelegate: EventCategoryEventWasUpdatedDelegate?) -> AnyView
  func startRead(eventId: Identifier,
                 eventCategoryEventWasUpdatedDelegate: EventCategoryEventWasUpdatedDelegate?) -> AnyView
}
