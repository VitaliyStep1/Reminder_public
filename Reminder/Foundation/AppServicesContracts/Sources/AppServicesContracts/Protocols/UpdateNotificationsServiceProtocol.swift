//
//  UpdateNotificationsServiceProtocol.swift
//  DomainContracts
//
//  Created by AI on 2026.
//

import Foundation

public protocol UpdateNotificationsServiceProtocol: Sendable {
  func updateNotifications() async throws
}
