//
//  FetchIsLocalNotificationsPermissionUseCase.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 16.12.2025.
//

import Foundation
import UserNotifications
import DomainContracts

public struct FetchIsLocalNotificationsPermissionUseCase: FetchIsLocalNotificationsPermissionUseCaseProtocol {

  public init() {}

  public func execute() async -> Bool {
    let settings = await UNUserNotificationCenter.current().notificationSettings()
    switch settings.authorizationStatus {
    case .authorized, .provisional, .ephemeral:
      return true
    case .denied, .notDetermined:
      return false
    @unknown default:
      return false
    }
  }
}
