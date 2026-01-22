//
//  RouterProtocol.swift
//  NavigationContracts
//
//  Created by Vitaliy Stepanenko on 28.10.2025.
//

import SwiftUI
import Combine
import DomainContracts
import Event

public protocol CreateRouterProtocol: ObservableObject, EventCategoryEventWasUpdatedDelegate where ObjectWillChangePublisher == ObservableObjectPublisher {
  var path: NavigationPath { get set }

  func pushScreen(_: CreateRoute)
  func popScreen()
  @MainActor
  func categoryEventWasUpdated(newCategoryId: Identifier?)
}
