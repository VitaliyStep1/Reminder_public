//
//  ScheduleNotificationsRescheduleEvent.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 01.01.2026.
//

import Foundation
import DomainContracts

public struct ScheduleNotificationsRescheduleEvent: Sendable, Hashable {
  public let originalEvent: Event
  public var isToScheduleOnDay: Bool
  public var isToScheduleBefore: Bool
  public let categoryTypeEnum: CategoryTypeEnum

  public init(
    originalEvent: Event,
    isToScheduleOnDay: Bool,
    isToScheduleBefore: Bool,
    categoryTypeEnum: CategoryTypeEnum
  ) {
    self.originalEvent = originalEvent
    self.isToScheduleOnDay = isToScheduleOnDay
    self.isToScheduleBefore = isToScheduleBefore
    self.categoryTypeEnum = categoryTypeEnum
  }
}
