//
//  EventAlertsSectionData.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 12.11.2025.
//

import Foundation
import DomainContracts

@MainActor
class EventAlertsSectionData: ObservableObject {
  
  @Published var repeatRepresentationEnum: EventEntity.RepeatRepresentationEnum

  @Published public var defaultRemindTimeDate: Date

  @Published var eventPeriod: EventPeriodEnum
  @Published var isRemindRepeated: Bool
  @Published var remindOnDayTimeDate: Date
  @Published var isRemindOnDayActive: Bool
  @Published var remindBeforeDays: Int
  @Published var remindBeforeTimeDate: Date
  @Published var isRemindBeforeActive: Bool

  public init(
    repeatRepresentationEnum: EventEntity.RepeatRepresentationEnum,
    eventPeriod: EventPeriodEnum,
    isRemindTime2ViewVisible: Bool,
    isAddRemindTimeButtonVisible: Bool,
    defaultRemindTimeDate: Date,
    isRemindRepeated: Bool,
    remindOnDayTimeDate: Date,
    remindOnDayDate: Date?,
    isRemindOnDayActive: Bool,
    remindBeforeDays: Int,
    remindBeforeDate: Date?,
    remindBeforeTimeDate: Date,
    isRemindBeforeActive: Bool
  ) {
    self.repeatRepresentationEnum = repeatRepresentationEnum
    self.eventPeriod = eventPeriod
    self.defaultRemindTimeDate = defaultRemindTimeDate
    self.isRemindRepeated = isRemindRepeated
    self.remindOnDayTimeDate = remindOnDayTimeDate
    self.isRemindOnDayActive = isRemindOnDayActive
    self.remindBeforeDays = remindBeforeDays
    self.remindBeforeTimeDate = remindBeforeTimeDate
    self.isRemindBeforeActive = isRemindBeforeActive
  }
}
