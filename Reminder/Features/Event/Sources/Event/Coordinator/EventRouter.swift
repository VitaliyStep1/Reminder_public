//
//  EventRouter.swift
//  Event
//
//  Created by Vitaliy Stepanenko on 04.01.2026.
//

import SwiftUI
import NavigationContracts
import DomainContracts

public final class EventRouter: EventRouterProtocol, ObservableObject {
  @Published public var path: NavigationPath = NavigationPath()
  
  public init() { }
  
  public func pushScreen(_ route: EventRoute) {
    var updatedPath = path
    updatedPath.append(route)
    path = updatedPath
  }
  
  public func popScreen() {
    guard !path.isEmpty else {
      return
    }
    var updatedPath = path
    updatedPath.removeLast()
    path = updatedPath
  }
}
