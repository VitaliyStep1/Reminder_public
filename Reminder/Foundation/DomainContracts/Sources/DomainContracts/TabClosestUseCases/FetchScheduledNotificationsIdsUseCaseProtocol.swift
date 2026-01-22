//
//  FetchScheduledNotificationsIdsUseCaseProtocol.swift
//  DomainContracts
//
//  Created by OpenAI on 2025.
//

import Foundation

public protocol FetchScheduledNotificationsIdsUseCaseProtocol: Sendable {
  func execute() async -> [UUID]
}
