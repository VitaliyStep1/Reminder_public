//
//  FetchIsLocalNotificationsPermissionUseCaseProtocol.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 16.12.2025.
//

import Foundation

public protocol FetchIsLocalNotificationsPermissionUseCaseProtocol: Sendable {
  func execute() async -> Bool
}
