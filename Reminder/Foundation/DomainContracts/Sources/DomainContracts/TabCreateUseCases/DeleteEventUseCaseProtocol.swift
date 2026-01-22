//
//  DeleteEventUseCaseProtocol.swift
//  DomainContracts
//
//  Created as part of Clean Architecture refactor.
//

import Foundation

public protocol DeleteEventUseCaseProtocol: Sendable {
  func execute(eventId: Identifier) async throws
}
