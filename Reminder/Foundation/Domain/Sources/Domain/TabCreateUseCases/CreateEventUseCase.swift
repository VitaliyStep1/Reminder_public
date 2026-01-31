//
//  CreateEventUseCase.swift
//  Domain
//
//  Created as part of Clean Architecture refactor.
//

import Foundation
import DomainContracts
import PersistenceContracts

public struct CreateEventUseCase: CreateEventUseCaseProtocol {
  private let dbEventsService: DBEventsServiceProtocol
  private let dbCategoriesService: DBCategoriesServiceProtocol

  public init(dbEventsService: DBEventsServiceProtocol, dbCategoriesService: DBCategoriesServiceProtocol) {
    self.dbEventsService = dbEventsService
    self.dbCategoriesService = dbCategoriesService
  }

  public func execute(
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
  ) async throws -> Identifier? {
    let calculateCategoryIdForEventService = CalculateCategoryIdForEventService(dbEventsService: dbEventsService, dbCategoriesService: dbCategoriesService)
    let newCategoryId = try await calculateCategoryIdForEventService.calculateNewCategoryIdForCreatingEvent(categoryId: categoryId, eventPeriod: eventPeriod)
    let resultCategoryId: Identifier = newCategoryId ?? categoryId

    try await dbEventsService.createEvent(
      categoryId: resultCategoryId,
      eventId: eventId,
      title: title,
      date: date,
      comment: comment,
      eventPeriod: eventPeriod.rawValue,
      isRemindRepeated: isRemindRepeated,
      remindOnDayTimeDate: remindOnDayTimeDate,
      remindOnDayDate: remindOnDayDate,
      isRemindOnDayActive: isRemindOnDayActive,
      remindBeforeDays: remindBeforeDays,
      remindBeforeDate: remindBeforeDate,
      remindBeforeTimeDate: remindBeforeTimeDate,
      isRemindBeforeActive: isRemindBeforeActive,
      onDayLNEventId: onDayLNEventId,
      beforeLNEventId: beforeLNEventId
    )
    return newCategoryId
  }
}
