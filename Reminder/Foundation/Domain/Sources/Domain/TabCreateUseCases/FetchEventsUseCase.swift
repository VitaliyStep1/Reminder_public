//
//  FetchEventsUseCase.swift
//  Domain
//
//  Created as part of Clean Architecture refactor.
//

import Foundation
import DomainContracts
import PersistenceContracts

public struct FetchEventsUseCase: FetchEventsUseCaseProtocol {
  private let dbEventsService: DBEventsServiceProtocol

  public init(dbEventsService: DBEventsServiceProtocol) {
    self.dbEventsService = dbEventsService
  }

  public func execute(categoryId: Identifier) async throws -> [DomainContracts.Event] {
    let events = try await dbEventsService.fetchEvents(categoryId: categoryId)
    return events.map { event in
      DomainContracts.Event(
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
}
