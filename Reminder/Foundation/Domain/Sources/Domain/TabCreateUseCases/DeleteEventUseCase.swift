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
  private let dBEventsService: DBEventsServiceProtocol

  public init(dBEventsService: DBEventsServiceProtocol) {
    self.dBEventsService = dBEventsService
  }

  public func execute(eventId: Identifier) async throws {
    try await dBEventsService.deleteEvent(eventId: eventId)
  }
}
