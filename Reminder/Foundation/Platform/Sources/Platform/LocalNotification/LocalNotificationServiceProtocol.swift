//
//  LocalNotificationServiceProtocol.swift
//  Platform
//
//  Created by Vitaliy Stepanenko on 24.12.2025.
//

import Foundation

public protocol LocalNotificationServiceProtocol {
  func schedule(lnEvents: [LNEvent]) async throws
  func schedule(lnEvent: LNEvent) async throws
  func cancelNotification(id: String)
  func cancelNotifications(ids: [String])
  func getPendingNotificationsIds() async -> [String]
}
