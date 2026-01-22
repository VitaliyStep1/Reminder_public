//
//  CalculateRemindDatesForEventService.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 29.12.2025.
//

import Foundation
import DomainContracts

public final class CalculateRemindDatesForEventService {
  
  public init() {}
  
  public func calculateRemindDates(eventDate: Date, // Date for remindOnDayDate
                      eventPeriod: EventPeriodEnum,
                      isRemindRepeated: Bool,
                      remindOnDayTimeDate: Date, // Time for remindOnDayDate
                      isRemindOnDayActive: Bool,
                      remindBeforeDays: Int,
                      remindBeforeTimeDate: Date, // Time for remindBeforeTimeDate
                      isRemindBeforeActive: Bool
  ) -> (remindOnDayDate: Date?, remindBeforeDate: Date?) {
    let calendar = Calendar.current
    let now = Date()

    let eventPeriodComponents = periodComponents(for: eventPeriod)

    let changedEventDate = calculateChangedDate(eventDate: eventDate, eventPeriod: eventPeriod, calendar: calendar)
    
    let eventDateTimeDate = combine(date: changedEventDate, withTimeFrom: remindOnDayTimeDate, calendar: calendar)
    
    var remindBeforeBaseDate: Date?
    if let eventDateTimeDate {
      remindBeforeBaseDate = calendar.date(byAdding: .day, value: -remindBeforeDays, to: eventDateTimeDate)
    }
    
    let remindBeforeDateTime = remindBeforeBaseDate.flatMap { baseDate in
      combine(date: baseDate, withTimeFrom: remindBeforeTimeDate, calendar: calendar)
    }
    
    let remindOnDayDate: Date?
    if isRemindOnDayActive {
      remindOnDayDate = adjustedDate(eventDateTimeDate, eventPeriodComponents, now: now, calendar: calendar)
    } else {
      remindOnDayDate = nil
    }
    
    let remindBeforeDate: Date?
    if isRemindBeforeActive {
      remindBeforeDate = adjustedDate(remindBeforeDateTime, eventPeriodComponents, now: now, calendar: calendar)
    } else {
      remindBeforeDate = nil
    }
    
    return (remindOnDayDate: remindOnDayDate, remindBeforeDate: remindBeforeDate)
  }
  
  private func combine(date: Date, withTimeFrom time: Date, calendar: Calendar) -> Date? {
    let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
    return calendar.date(bySettingHour: timeComponents.hour ?? 0,
                         minute: timeComponents.minute ?? 0,
                         second: timeComponents.second ?? 0,
                         of: date)
  }
  
  private func adjustedDate(_ date: Date?, _ period: DateComponents, now: Date, calendar: Calendar) -> Date? {
    guard var date else {
      return nil
    }
    
    while date <= now {
      guard let newDate = calendar.date(byAdding: period, to: date) else {
        break
      }
      date = newDate
    }
    
    return date
  }
  
  private func periodComponents(for eventPeriod: EventPeriodEnum) -> DateComponents {
    switch eventPeriod {
    case .everyYear:
      return DateComponents(year: 1)
    case .everyMonth:
      return DateComponents(month: 1)
    case .everyDay:
      return DateComponents(day: 1)
    }
  }
  
  private func calculateChangedDate(eventDate: Date, eventPeriod: EventPeriodEnum, calendar: Calendar) -> Date {
    // We need changedEventDate only for decreasing calculation complexity
    let now = Date()
    let changedEventDate: Date
    let currentComponents = calendar.dateComponents([.year, .month, .day], from: now)
    let eventComponents = calendar.dateComponents([.month, .day], from: eventDate)
    switch eventPeriod {
    case .everyYear:
      let baseDate = calendar.date(from: DateComponents(
        year: currentComponents.year,
        month: eventComponents.month,
        day: eventComponents.day)) ?? eventDate
      changedEventDate = calendar.date(byAdding: .year, value: -1, to: baseDate) ?? eventDate
    case .everyMonth:
      let baseDate = calendar.date(from: DateComponents(
        year: currentComponents.year,
        month: currentComponents.month,
        day: eventComponents.day)) ?? eventDate
      changedEventDate = calendar.date(byAdding: .month, value: -1, to: baseDate) ?? eventDate
    case .everyDay:
      let baseDate = calendar.date(from: currentComponents) ?? eventDate
      changedEventDate = calendar.date(byAdding: .day, value: -1, to: baseDate) ?? eventDate
    }
    return changedEventDate
  }
}
