//
//  Router.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 05.10.2025.
//

import SwiftUI
import NavigationContracts
import DomainContracts
import Event

public final class CreateRouter: CreateRouterProtocol, ObservableObject {
  @Published public var path: NavigationPath = NavigationPath()

  public init() { }

  public func pushScreen(_ route: CreateRoute) {
    push(route)
  }

  public func popScreen() {
    pop()
  }

  @MainActor
  public func categoryEventWasUpdated(newCategoryId: Identifier?) {
//    guard let newCategoryId else {
//      return
//    }
//
//    guard let categoryIndex = path.lastIndex(where: { route in
//      if case .category = route {
//        return true
//      }
//      return false
//    }) else {
//      return
//    }
//
//    var updatedPath = path
//    updatedPath[categoryIndex] = .category(newCategoryId)
//    path = updatedPath
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

extension CreateRouter: EventRouterProtocol {
  public func pushScreen(_ route: EventRoute) {
    push(route)
  }
}
