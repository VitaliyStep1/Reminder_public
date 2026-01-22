//
//  RequestLocalNotificationsPermissionUseCase.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 16.12.2025.
//

import Foundation
import UserNotifications
import DomainContracts

public struct RequestLocalNotificationsPermissionUseCase
: RequestLocalNotificationsPermissionUseCaseProtocol {

  public init() {}

  public func execute() async -> Bool {
    await requestLocalNotificationPermission()
  }
  
  @MainActor
  func requestLocalNotificationPermission() async -> Bool {
    do {
      let granted = try await UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge])
      return granted
    } catch {
      // e.g. restrictions / system error
      return false
    }
  }
}
