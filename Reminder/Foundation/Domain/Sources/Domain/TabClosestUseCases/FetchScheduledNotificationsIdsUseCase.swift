//
//  FetchScheduledNotificationsIdsUseCase.swift
//  Domain
//
//  Created by OpenAI on 2025.
//

import Foundation
import UserNotifications
import DomainContracts

public struct FetchScheduledNotificationsIdsUseCase: FetchScheduledNotificationsIdsUseCaseProtocol {

  public init() {}

  public func execute() async -> [UUID] {
    let center = UNUserNotificationCenter.current()
    let requests = await center.pendingNotificationRequests()
    let identifiers = requests.compactMap { UUID(uuidString: $0.identifier) }
    return identifiers
  }
}
