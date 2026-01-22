//
//  ClosestRouterProtocol.swift
//  Closest
//
//  Created by Vitaliy Stepanenko on 30.12.2025.
//

import SwiftUI
import Combine
import DomainContracts
import Event

public protocol ClosestRouterProtocol: ObservableObject, EventCategoryEventWasUpdatedDelegate where ObjectWillChangePublisher == ObservableObjectPublisher {
  var path: NavigationPath { get set }
  
  func pushScreen(_: ClosestRoute)
  func popScreen()
  @MainActor
  func categoryEventWasUpdated(newCategoryId: Identifier?)
}
