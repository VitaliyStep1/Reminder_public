//
//  CalculateRemindDatesForEventService.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 29.12.2025.
//

import Foundation
import DomainContracts

public enum CalculateRemindDatesForEventServiceError: Error {
  case onDayDateCreationFailed
  case beforeDateCreationFailed
}

public final class CalculateRemindDatesForEventService: CalculateRemindDatesForEventServiceProtocol {
  
  public init() {}
  
  public func calculateRemindDates(eventDate: Date, // Date for remindOnDayDate
                                   eventPeriod: EventPeriodEnum,
                                   isRemindRepeated: Bool,
                                   remindOnDayTimeDate: Date, // Time for remindOnDayDate
                                   isRemindOnDayActive: Bool,
                                   remindBeforeDays: Int,
                                   remindBeforeTimeDate: Date, // Time for remindBeforeTimeDate
                                   isRemindBeforeActive: Bool
  ) throws -> (remindOnDayDate: Date?, remindBeforeDate: Date?) {
    let calendar = Calendar.current
    let nowDate = Date()
    let minimumDate = calendar.date(byAdding: .minute, value: 2, to: nowDate)
    guard let minimumDate else {
      throw CalculateRemindDatesForEventServiceError.onDayDateCreationFailed
    }
    
    let remindOnDayDate: Date?
    if isRemindOnDayActive {
      remindOnDayDate = try calculateRemindOnDayDate(eventDate: eventDate, minimumDate: minimumDate, remindOnDayTimeDate: remindOnDayTimeDate, calendar: calendar, eventPeriod: eventPeriod)
    } else {
      remindOnDayDate = nil
    }
    
    var remindBeforeDate: Date?
    if isRemindBeforeActive {
      remindBeforeDate = try calculateRemindBeforeDate(eventDate: eventDate, minimumDate: minimumDate, remindBeforeDays: remindBeforeDays, remindBeforeTimeDate: remindBeforeTimeDate, remindOnDayTimeDate: remindOnDayTimeDate, calendar: calendar, eventPeriod: eventPeriod)
      
      if !isRemindRepeated, let copyRemindBeforeDate = remindBeforeDate, let remindOnDayDate {
        if copyRemindBeforeDate >= remindOnDayDate {
          remindBeforeDate = nil
        }
      }
      
    } else {
      remindBeforeDate = nil
    }
    
    return (remindOnDayDate: remindOnDayDate, remindBeforeDate: remindBeforeDate)
  }
  
  private func calculateRemindOnDayDate(eventDate: Date, minimumDate: Date, remindOnDayTimeDate: Date, calendar: Calendar, eventPeriod: EventPeriodEnum) throws -> Date {
    let remindOnDayDate = try calculateNextRemindOnDayDateRelativelyToDate(eventDate: eventDate, timeDate: remindOnDayTimeDate, relativeDate: minimumDate, calendar: calendar, eventPeriod: eventPeriod)
    return remindOnDayDate
  }
  
  private func calculateNextRemindOnDayDateRelativelyToDate(eventDate: Date, timeDate: Date, relativeDate: Date, calendar: Calendar, eventPeriod: EventPeriodEnum) throws -> Date {
    
    switch eventPeriod {
    case .everyDay:
      let timeComponents = calendar.dateComponents([.hour, .minute], from: timeDate)
      var matchComponents = DateComponents(hour: timeComponents.hour, minute: timeComponents.minute)
      let remindDate = calendar.nextDate(after: relativeDate, matching: matchComponents, matchingPolicy: .nextTime)
      guard let remindDate else {
        throw CalculateRemindDatesForEventServiceError.onDayDateCreationFailed
      }
      return remindDate
      
    case .everyMonth:
      let thisMonthRemindDate = try calculateThisMonthRemindForMonthPeriod(eventDate: eventDate, calendar: calendar, minimumDate: relativeDate, timeDate: timeDate)
      if thisMonthRemindDate > relativeDate {
        return thisMonthRemindDate
      }
      let nextMonthRemindDate = try calculateNextMonthRemindForMonthPeriod(eventDate: eventDate, calendar: calendar, minimumDate: relativeDate, timeDate: timeDate)
      return nextMonthRemindDate
    case .everyYear:
      let thisYearRemindDate = try calculateThisYearRemindForYearPeriod(eventDate: eventDate, calendar: calendar, minimumDate: relativeDate, timeDate: timeDate)
      if thisYearRemindDate > relativeDate {
        return thisYearRemindDate
      }
      let nextYearRemindDate = try calculateNextYearRemindForYearPeriod(eventDate: eventDate, calendar: calendar, minimumDate: relativeDate, timeDate: timeDate)
      return nextYearRemindDate
    }
  }
  
  private func calculateThisYearRemindForYearPeriod(eventDate: Date, calendar: Calendar, minimumDate: Date, timeDate: Date) throws -> Date {
    let year = calendar.component(.year, from: minimumDate)
    let remindDate = try calculateRemindForYearPeriod(eventDate: eventDate, calendar: calendar, year: year, timeDate: timeDate)
    return remindDate
  }
  
  private func calculateNextYearRemindForYearPeriod (eventDate: Date, calendar: Calendar, minimumDate: Date, timeDate: Date) throws -> Date {
    let year = calendar.component(.year, from: minimumDate) + 1
    let remindDate = try calculateRemindForYearPeriod(eventDate: eventDate, calendar: calendar, year: year, timeDate: timeDate)
    return remindDate
  }
  
  private func calculateRemindForYearPeriod(eventDate: Date, calendar: Calendar, year: Int, timeDate: Date) throws -> Date {
    let month = calendar.component(.month, from: eventDate)
    let day = calendar.component(.day, from: eventDate)
    let hour = calendar.component(.hour, from: timeDate)
    let minute = calendar.component(.minute, from: timeDate)
    
    let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
    let date = calendar.date(from: components)
    if let date {
      return date
    } else {
      if month == 2 && day == 29 {
        let correctedDay = 28
        let correctedComponents = DateComponents(year: year, month: month, day: correctedDay, hour: hour, minute: minute)
        let correctedDate = calendar.date(from: correctedComponents)
        guard let correctedDate else {
          throw CalculateRemindDatesForEventServiceError.onDayDateCreationFailed
        }
        return correctedDate
      }
      else {
        throw CalculateRemindDatesForEventServiceError.onDayDateCreationFailed
      }
    }
  }
  
  private func calculateThisMonthRemindForMonthPeriod(eventDate: Date, calendar: Calendar, minimumDate: Date, timeDate: Date) throws -> Date {
    let year = calendar.component(.year, from: minimumDate)
    let month = calendar.component(.month, from: minimumDate)
    let remindDate = try calculateRemindForMonthPeriod(eventDate: eventDate, calendar: calendar, year: year, month: month, timeDate: timeDate)
    return remindDate
  }
  
  private func calculateNextMonthRemindForMonthPeriod(eventDate: Date, calendar: Calendar, minimumDate: Date, timeDate: Date) throws -> Date {
    let nextMonth = calendar.component(.month, from: minimumDate) + 1
    let year: Int
    let month: Int
    if nextMonth <= 12 {
      year = calendar.component(.year, from: minimumDate)
      month = nextMonth
    } else {
      year = calendar.component(.year, from: minimumDate) + 1
      month = 1
    }
    let remindDate = try calculateRemindForMonthPeriod(eventDate: eventDate, calendar: calendar, year: year, month: month, timeDate: timeDate)
    return remindDate
  }
  
  private func calculateRemindForMonthPeriod(eventDate: Date, calendar: Calendar, year: Int, month: Int, timeDate: Date) throws -> Date {
    let day = calendar.component(.day, from: eventDate)
    let hour = calendar.component(.hour, from: timeDate)
    let minute = calendar.component(.minute, from: timeDate)
    
    let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
    var remindDate = calendar.date(from: components)
    if remindDate == nil {
      let minimumPossibleDays = 28
      if day > minimumPossibleDays {
        var correctedDay = day
        while remindDate == nil {
          if correctedDay >= minimumPossibleDays {
            correctedDay -= 1
            let components = DateComponents(year: year, month: month, day: correctedDay, hour: hour, minute: minute)
            remindDate = calendar.date(from: components)
          } else {
            throw CalculateRemindDatesForEventServiceError.onDayDateCreationFailed
          }
        }
      }
    }
    guard let remindDate else {
      throw CalculateRemindDatesForEventServiceError.onDayDateCreationFailed
    }
    return remindDate
  }
  
  
  private func calculateRemindBeforeDate(eventDate: Date, minimumDate: Date, remindBeforeDays: Int, remindBeforeTimeDate: Date, remindOnDayTimeDate: Date, calendar: Calendar, eventPeriod: EventPeriodEnum) throws -> Date? {
    let closestRemindOnDayDate = try calculateRemindOnDayDate(eventDate: eventDate, minimumDate: minimumDate, remindOnDayTimeDate: remindOnDayTimeDate, calendar: calendar, eventPeriod: eventPeriod)
    let remindBeforeDate = try calculateRemindBeforeDateRelatevelyToRemindOnDayDate(remindOnDayDate: closestRemindOnDayDate, remindBeforeDays: remindBeforeDays, remindBeforeTimeDate: remindBeforeTimeDate, calendar: calendar)
    if remindBeforeDate > minimumDate {
      return remindBeforeDate
    } else {
      let nextRemindOnDayDate = try calculateNextRemindOnDayDateRelativelyToDate(eventDate: eventDate, timeDate: remindOnDayTimeDate, relativeDate: closestRemindOnDayDate, calendar: calendar, eventPeriod: eventPeriod)
      let remindBeforeDate = try calculateRemindBeforeDateRelatevelyToRemindOnDayDate(remindOnDayDate: nextRemindOnDayDate, remindBeforeDays: remindBeforeDays, remindBeforeTimeDate: remindBeforeTimeDate, calendar: calendar)
      if remindBeforeDate > minimumDate {
        return remindBeforeDate
      } else {
        return nil
      }
    }
  }
  
  private func calculateRemindBeforeDateRelatevelyToRemindOnDayDate(remindOnDayDate: Date, remindBeforeDays: Int, remindBeforeTimeDate: Date, calendar: Calendar) throws -> Date {
    let agoDate = calendar.date(byAdding: .day, value: -remindBeforeDays, to: remindOnDayDate)
    guard let agoDate else {
      throw CalculateRemindDatesForEventServiceError.beforeDateCreationFailed
    }
    let year = calendar.component(.year, from: agoDate)
    let month = calendar.component(.month, from: agoDate)
    let day = calendar.component(.day, from: agoDate)
    let hour = calendar.component(.hour, from: remindBeforeTimeDate)
    let minute = calendar.component(.minute, from: remindBeforeTimeDate)
    let correctedDate = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute))
    guard let correctedDate else {
      throw CalculateRemindDatesForEventServiceError.beforeDateCreationFailed
    }
    return correctedDate
  }
}
