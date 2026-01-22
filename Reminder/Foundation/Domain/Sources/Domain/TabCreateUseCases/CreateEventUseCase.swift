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
  private let dBEventsService: DBEventsServiceProtocol
  private let dBCategoriesService: DBCategoriesServiceProtocol

  public init(dBEventsService: DBEventsServiceProtocol, dBCategoriesService: DBCategoriesServiceProtocol) {
    self.dBEventsService = dBEventsService
    self.dBCategoriesService = dBCategoriesService
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
    let calculateCategoryIdForEventService = CalculateCategoryIdForEventService(dBEventsService: dBEventsService, dBCategoriesService: dBCategoriesService)
    let newCategoryId = try await calculateCategoryIdForEventService.calculateNewCategoryIdForCreatingEvent(categoryId: categoryId, eventPeriod: eventPeriod)
    let resultCategoryId: Identifier = newCategoryId ?? categoryId

    try await dBEventsService.createEvent(
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
