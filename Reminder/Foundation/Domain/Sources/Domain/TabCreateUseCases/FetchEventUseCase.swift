//
//  FetchEventUseCase.swift
//  Domain
//
//  Created as part of Clean Architecture refactor.
//

import Foundation
import DomainContracts
import PersistenceContracts

public struct FetchEventUseCase: FetchEventUseCaseProtocol {
  private let dBEventsService: DBEventsServiceProtocol

  public init(dBEventsService: DBEventsServiceProtocol) {
    self.dBEventsService = dBEventsService
  }

  public func execute(eventId: Identifier) async throws -> DomainContracts.Event {
    let event = try await dBEventsService.fetchEvent(eventId: eventId)
    return DomainContracts.Event(
      id: event.id,
      title: event.title,
      date: event.date,
      comment: event.comment,
      categoryId: event.categoryId,
      eventPeriod: EventPeriodEnum(fromRawValue: event.eventPeriod),
      isRemindRepeated: event.isRemindRepeated,
      remindOnDayTimeDate: event.remindOnDayTimeDate,
      remindOnDayDate: event.remindOnDayDate,
      isRemindOnDayActive: event.isRemindOnDayActive,
      remindBeforeDays: event.remindBeforeDays,
      remindBeforeDate: event.remindBeforeDate,
      remindBeforeTimeDate: event.remindBeforeTimeDate,
      isRemindBeforeActive: event.isRemindBeforeActive,
      onDayLNEventId: event.onDayLNEventId,
      beforeLNEventId: event.beforeLNEventId
    )
  }
}
