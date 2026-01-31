//
//  DeleteEventUseCase.swift
//  Domain
//
//  Created as part of Clean Architecture refactor.
//

import Foundation
import DomainContracts
import PersistenceContracts

public struct DeleteEventUseCase: DeleteEventUseCaseProtocol {
  private let dbEventsService: DBEventsServiceProtocol

  public init(dbEventsService: DBEventsServiceProtocol) {
    self.dbEventsService = dbEventsService
  }

  public func execute(eventId: Identifier) async throws {
    try await dbEventsService.deleteEvent(eventId: eventId)
  }
}
