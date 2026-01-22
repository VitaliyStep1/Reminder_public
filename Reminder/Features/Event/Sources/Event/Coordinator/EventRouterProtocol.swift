//
//  EventRouterProtocol.swift
//  Event
//
//  Created by Vitaliy Stepanenko on 04.01.2026.
//

import SwiftUI
import Combine
import DomainContracts
import Event

public protocol EventRouterProtocol: ObservableObject {
  var path: NavigationPath { get set }
  
  func pushScreen(_: EventRoute)
  func popScreen()
}
