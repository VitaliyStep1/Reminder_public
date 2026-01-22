//
//  ClosestCoordinatorProtocol.swift
//  Closest
//
//  Created by Vitaliy Stepanenko on 30.12.2025.
//

import SwiftUI
import NavigationContracts
import DomainContracts
import Event

public protocol ClosestCoordinatorProtocol: AnyObject, CoordinatorProtocol, EventCategoryEventWasUpdatedDelegate {
  var router: any ClosestRouterProtocol { get }
  func destination(for route: ClosestRoute) -> AnyView
  
  func pushScreen(_: ClosestRoute)
}
