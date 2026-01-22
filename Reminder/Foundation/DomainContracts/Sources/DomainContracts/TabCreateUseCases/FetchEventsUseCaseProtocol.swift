//
//  FetchEventsUseCaseProtocol.swift
//  DomainContracts
//
//  Created as part of Clean Architecture refactor.
//

import Foundation

public protocol FetchEventsUseCaseProtocol: Sendable {
  func execute(categoryId: Identifier) async throws -> [Event]
}
