//
//  Event.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 24.08.2025.
//

import Foundation

public struct Event: Sendable {
  public let id: ObjectId
  public let title: String
  public let date: Date
  public let comment: String
  public let categoryId: ObjectId?
  public let eventPeriod: Int
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
    id: ObjectId,
    title: String,
    date: Date,
    comment: String,
    categoryId: ObjectId?,
    eventPeriod: Int,
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
    self.id = id
    self.title = title
    self.date = date
    self.comment = comment
    self.categoryId = categoryId
    self.eventPeriod = eventPeriod
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
