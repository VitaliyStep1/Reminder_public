//
//  GenerateNewRemindsUseCaseProtocol.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 16.12.2025.
//

import Foundation

public protocol GenerateNewRemindsUseCaseProtocol: Sendable {
  func execute(date: Date,
               eventPeriod: EventPeriodEnum,
               isRemindRepeated: Bool,
               remindOnDayTimeDate: Date,
               isRemindOnDayActive: Bool,
               remindBeforeDays: Int,
               remindBeforeTimeDate: Date,
               isRemindBeforeActive: Bool
  ) -> (remindOnDayDate: Date?, remindBeforeDate: Date?)
}
