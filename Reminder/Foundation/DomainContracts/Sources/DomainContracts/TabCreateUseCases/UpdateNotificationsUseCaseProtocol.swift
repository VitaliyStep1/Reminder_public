//
//  UpdateNotificationsUseCaseProtocol.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 31.12.2025.
//

import Foundation

public protocol UpdateNotificationsUseCaseProtocol: Sendable {
  func execute() async
}
