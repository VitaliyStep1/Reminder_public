//
//  FetchAllFutureEventsUseCaseProtocol.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 18.12.2025.
//

import Foundation

public protocol FetchAllFutureEventsUseCaseProtocol: Sendable {
  func execute() async throws -> [FutureEvent]
}
