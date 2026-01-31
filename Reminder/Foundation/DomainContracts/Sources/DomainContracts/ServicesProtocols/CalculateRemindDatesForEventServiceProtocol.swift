//
//  CalculateRemindDatesForEventServiceProtocol.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 28.01.2026.
//

import Foundation

public protocol CalculateRemindDatesForEventServiceProtocol {
  func calculateRemindDates(eventDate: Date,
                            eventPeriod: EventPeriodEnum,
                            isRemindRepeated: Bool,
                            remindOnDayTimeDate: Date,
                            isRemindOnDayActive: Bool,
                            remindBeforeDays: Int,
                            remindBeforeTimeDate: Date,
                            isRemindBeforeActive: Bool
  ) throws -> (remindOnDayDate: Date?, remindBeforeDate: Date?)
}
