//
//  UNUserNotificationCenter+.swift
//  Platform
//
//  Created by Vitaliy Stepanenko on 25.12.2025.
//

import UserNotifications

extension UNUserNotificationCenter {
  func pendingRequests() async -> [UNNotificationRequest] {
    await withCheckedContinuation { continuation in
      getPendingNotificationRequests { continuation.resume(returning: $0) }
    }
  }
}
