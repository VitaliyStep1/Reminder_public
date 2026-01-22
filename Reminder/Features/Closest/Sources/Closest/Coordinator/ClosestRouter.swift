//
//  ClosestRouter.swift
//  Closest
//
//  Created by Vitaliy Stepanenko on 22.12.2025.
//

import SwiftUI
import NavigationContracts
import DomainContracts
import Event

public final class ClosestRouter: ClosestRouterProtocol, ObservableObject {
  @Published public var path: NavigationPath = NavigationPath()

  public init() { }

  public func pushScreen(_ route: ClosestRoute) {
    push(route)
  }

  public func popScreen() {
    pop()
  }

  @MainActor
  public func categoryEventWasUpdated(newCategoryId: Identifier?) {

  }
}

extension ClosestRouter: EventRouterProtocol {
  public func pushScreen(_ route: EventRoute) {
    push(route)
  }

  fileprivate func push(_ route: any Hashable) {
    var updatedPath = path
    updatedPath.append(route)
    path = updatedPath
  }

  fileprivate func pop() {
    guard !path.isEmpty else {
      return
    }
    var updatedPath = path
    updatedPath.removeLast()
    path = updatedPath
  }
}
