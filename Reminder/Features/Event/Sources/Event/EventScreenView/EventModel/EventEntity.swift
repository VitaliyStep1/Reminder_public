//
//  EventEntity.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 02.10.2025.
//

import Foundation
import DomainContracts

enum EventEntity {
  enum SaveEventError: Error {
    case titleShouldBeNotEmpty
    case localNotificationIsNotAllowed
    case failedToScheduleNotification
  }
  
  enum RepeatRepresentationEnum {
    case picker(values: [EventPeriodEnum], titles: [EventPeriodEnum: String])
    case text(text: String)
  }
}
