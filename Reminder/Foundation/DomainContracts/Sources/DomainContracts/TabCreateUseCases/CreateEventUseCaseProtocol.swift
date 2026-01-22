//
//  CreateEventUseCaseProtocol.swift
//  DomainContracts
//
//  Created as part of Clean Architecture refactor.
//

import Foundation

public protocol CreateEventUseCaseProtocol: Sendable {
  func execute(
    categoryId: Identifier,
    eventId: Identifier,
    title: String,
    date: Date,
    comment: String,
    eventPeriod: EventPeriodEnum,
    isRemindRepeated: Bool,
    remindOnDayTimeDate: Date,
    remindOnDayDate: Date?,
    isRemindOnDayActive: Bool,
    remindBeforeDays: Int,
    remindBeforeDate: Date?,
    remindBeforeTimeDate: Date,
    isRemindBeforeActive: Bool,
    onDayLNEventId: UUID,
    beforeLNEventId: UUID
  ) async throws -> Identifier?
}
