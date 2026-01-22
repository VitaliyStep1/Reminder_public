//
//  ScheduleNotificationsServiceProtocol.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 01.01.2026.
//

import Foundation
import DomainContracts

public protocol ScheduleNotificationsServiceProtocol: Sendable {
  func scheduleAlerts(
    eventTitle: String,
    eventPeriod: EventPeriodEnum,
    remindOnDayDate: Date?,
    remindBeforeDate: Date?,
    onDayLNEventId: UUID,
    beforeLNEventId: UUID,
    remindBeforeDays: Int,
    categoryTypeEnum: CategoryTypeEnum
  ) async throws

  func scheduleAlerts(rescheduleEvents: [ScheduleNotificationsRescheduleEvent]) async throws
}
