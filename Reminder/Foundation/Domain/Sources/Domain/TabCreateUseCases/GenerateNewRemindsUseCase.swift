//
//  GenerateNewRemindsUseCase.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 16.12.2025.
//

import Foundation
import DomainContracts

public struct GenerateNewRemindsUseCase: GenerateNewRemindsUseCaseProtocol {
  private let calculateRemindDatesForEventService: CalculateRemindDatesForEventService
  public init() {
    calculateRemindDatesForEventService = CalculateRemindDatesForEventService()
  }

  public func execute(date: Date, // Date for remindOnDayDate
                      eventPeriod: EventPeriodEnum,
                      isRemindRepeated: Bool,
                      remindOnDayTimeDate: Date, // Time for remindOnDayDate
                      isRemindOnDayActive: Bool,
                      remindBeforeDays: Int,
                      remindBeforeTimeDate: Date, // Time for remindBeforeTimeDate
                      isRemindBeforeActive: Bool
  ) throws -> (remindOnDayDate: Date?, remindBeforeDate: Date?) {
    
    let (remindOnDayDate, remindBeforeDate) = try calculateRemindDatesForEventService.calculateRemindDates(
      eventDate: date,
      eventPeriod: eventPeriod,
      isRemindRepeated: isRemindRepeated,
      remindOnDayTimeDate: remindOnDayTimeDate,
      isRemindOnDayActive: isRemindOnDayActive,
      remindBeforeDays: remindBeforeDays,
      remindBeforeTimeDate: remindBeforeTimeDate,
      isRemindBeforeActive: isRemindBeforeActive
    )
    
    return (remindOnDayDate: remindOnDayDate, remindBeforeDate: remindBeforeDate)
  }
}
