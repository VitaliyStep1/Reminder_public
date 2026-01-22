//
//  SaveEventUseCaseInfo.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 01.01.2026.
//

import Foundation

public struct SaveEventUseCaseInfo {
  public let isCreating: Bool
  public let categoryId: Identifier
  public let eventId: Identifier
  public let title: String
  public let date: Date
  public let comment: String
  public let eventPeriod: EventPeriodEnum
  public let categoryTypeEnum: CategoryTypeEnum
  public let isRemindRepeated: Bool
  public let remindOnDayTimeDate: Date
  public let remindOnDayDate: Date?
  public let isRemindOnDayActive: Bool
  public let remindBeforeDays: Int
  public let remindBeforeDate: Date?
  public let remindBeforeTimeDate: Date
  public let isRemindBeforeActive: Bool
  public let onDayLNEventId: UUID
  public let beforeLNEventId: UUID

  public init(
    isCreating: Bool,
    categoryId: Identifier,
    eventId: Identifier,
    title: String,
    date: Date,
    comment: String,
    eventPeriod: EventPeriodEnum,
    categoryTypeEnum: CategoryTypeEnum,
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
  ) {
    self.isCreating = isCreating
    self.categoryId = categoryId
    self.eventId = eventId
    self.title = title
    self.date = date
    self.comment = comment
    self.eventPeriod = eventPeriod
    self.categoryTypeEnum = categoryTypeEnum
    self.isRemindRepeated = isRemindRepeated
    self.remindOnDayTimeDate = remindOnDayTimeDate
    self.remindOnDayDate = remindOnDayDate
    self.isRemindOnDayActive = isRemindOnDayActive
    self.remindBeforeDays = remindBeforeDays
    self.remindBeforeDate = remindBeforeDate
    self.remindBeforeTimeDate = remindBeforeTimeDate
    self.isRemindBeforeActive = isRemindBeforeActive
    self.onDayLNEventId = onDayLNEventId
    self.beforeLNEventId = beforeLNEventId
  }
}
