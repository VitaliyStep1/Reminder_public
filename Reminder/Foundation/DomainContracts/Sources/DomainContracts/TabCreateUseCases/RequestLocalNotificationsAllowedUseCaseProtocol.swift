//
//  RequestLocalNotificationsPermissionUseCaseProtocol.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 16.12.2025.
//

import Foundation

public protocol RequestLocalNotificationsPermissionUseCaseProtocol: Sendable {
  func execute() async -> Bool
}
