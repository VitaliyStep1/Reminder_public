//
//  FetchAllFutureEventsUseCase.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 18.12.2025.
//

import Foundation
import DomainContracts
import PersistenceContracts

public struct FetchAllFutureEventsUseCase: FetchAllFutureEventsUseCaseProtocol {
  private let dbEventsService: DBEventsServiceProtocol
  
  public init(dbEventsService: DBEventsServiceProtocol) {
    self.dbEventsService = dbEventsService
  }
  
  public func execute() async throws -> [DomainContracts.FutureEvent] {
    let dbEvents = try await dbEventsService.fetchAllEvents()
    let domainEvents: [DomainContracts.Event] = dbEvents.map { event in
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
    
    let futureEvents: [DomainContracts.FutureEvent] = domainEvents.map { event in
      let (future1Date, future2Date) = Self.takeFutureDates(originalDate: event.date, eventPeriod: event.eventPeriod)
      return DomainContracts.FutureEvent(originalEvent: event, future1Date: future1Date, future2Date: future2Date)
    }
    
    return futureEvents
  }

  private static func takeFutureDates(originalDate: Date, eventPeriod: EventPeriodEnum) -> (futute1Date: Date, futute2Date: Date) {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())

    let periodComponents: DateComponents
    switch eventPeriod {
    case .everyYear:
      periodComponents = DateComponents(year: 1)
    case .everyMonth:
      periodComponents = DateComponents(month: 1)
    case .everyDay:
      periodComponents = DateComponents(day: 1)
    }

    var future1Date = originalDate
    while calendar.startOfDay(for: future1Date) < today,
          let nextDate = calendar.date(byAdding: periodComponents, to: future1Date) {
      future1Date = nextDate
    }

    let future2Date = calendar.date(byAdding: periodComponents, to: future1Date) ?? future1Date

    return (futute1Date: future1Date, futute2Date: future2Date)
  }

}
