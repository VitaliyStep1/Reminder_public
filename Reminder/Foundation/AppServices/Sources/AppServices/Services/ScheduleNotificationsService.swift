//
//  ScheduleNotificationsService.swift
//  AppServices
//
//  Created by Vitaliy Stepanenko on 01.01.2026.
//

import Foundation
import Language
import Platform
import Configurations
import AppServicesContracts
import DomainContracts

public final class ScheduleNotificationsService: ScheduleNotificationsServiceProtocol {
  private let localNotificationService: LocalNotificationServiceProtocol
  private let appConfiguration: AppConfigurationProtocol
  private let takeSettingsLanguageUseCase: TakeSettingsLanguageUseCaseProtocol
  
  public init(
    localNotificationService: LocalNotificationServiceProtocol,
    appConfiguration: AppConfigurationProtocol,
    takeSettingsLanguageUseCase: TakeSettingsLanguageUseCaseProtocol
  ) {
    self.localNotificationService = localNotificationService
    self.appConfiguration = appConfiguration
    self.takeSettingsLanguageUseCase = takeSettingsLanguageUseCase
  }
  
  public func scheduleAlerts(eventTitle: String, eventPeriod: EventPeriodEnum, remindOnDayDate: Date?, remindBeforeDate: Date?, onDayLNEventId: UUID, beforeLNEventId: UUID, remindBeforeDays: Int, categoryTypeEnum: CategoryTypeEnum) async throws {
    
    let repeatIntevalEnum: LNRepeatIntevalEnum
    switch eventPeriod {
    case .everyYear:
      repeatIntevalEnum = .year
    case .everyMonth:
      repeatIntevalEnum = .month
    case .everyDay:
      repeatIntevalEnum = .day
    }
    
    let localizedCategoryNotificationTitle = localizedCategoryNotificationTitle(for: categoryTypeEnum)
    let onDayLNEvent = takeOnDayLNEvent(remindOnDayDate: remindOnDayDate, onDayLNEventId: onDayLNEventId, eventTitle: eventTitle, repeatIntevalEnum: repeatIntevalEnum, localizedCategoryNotificationTitle: localizedCategoryNotificationTitle)
    let beforeLNEvent = takeBeforeLNEvent(remindBeforeDate: remindBeforeDate, beforeLNEventId: beforeLNEventId, eventTitle: eventTitle, repeatIntevalEnum: repeatIntevalEnum, remindBeforeDays: remindBeforeDays, localizedCategoryNotificationTitle: localizedCategoryNotificationTitle)
    
    let cancelLNEventsIds: [String] = [onDayLNEventId.uuidString, beforeLNEventId.uuidString].compactMap { $0 }
    
    localNotificationService.cancelNotifications(ids: cancelLNEventsIds)
    
    var lnEvents: [LNEvent] = []
    
    if let onDayLNEvent {
      lnEvents.append(onDayLNEvent)
    }
    if let beforeLNEvent {
      lnEvents.append(beforeLNEvent)
    }
    
    do {
      try await localNotificationService.schedule(lnEvents: lnEvents)
    } catch {
      throw SaveEventUseCaseError.failedToScheduleNotification
    }
  }
  
  private func takeOnDayLNEvent(remindOnDayDate: Date?, onDayLNEventId: Identifier, eventTitle: String, repeatIntevalEnum: LNRepeatIntevalEnum, localizedCategoryNotificationTitle: String?) -> LNEvent? {
    guard let remindOnDayDate else {
      return nil
    }
    let lnEventTitle = takeNotificationTitle()
    let todayText = takeTodayText()
    var text = ""
    if let localizedCategoryNotificationTitle {
      text = localizedCategoryNotificationTitle + ": "
    }
    text = text + "\(eventTitle) , \(todayText)"
    return LNEvent(id: onDayLNEventId, date: remindOnDayDate, title: lnEventTitle, text: text, repeatIntevalEnum: repeatIntevalEnum)
  }
  
  private func takeBeforeLNEvent(remindBeforeDate: Date?, beforeLNEventId: Identifier, eventTitle: String, repeatIntevalEnum: LNRepeatIntevalEnum, remindBeforeDays: Int, localizedCategoryNotificationTitle: String?) -> LNEvent? {
    guard let remindBeforeDate else {
      return nil
    }
    let lnEventTitle = takeNotificationTitle()
    var text = ""
    if let localizedCategoryNotificationTitle {
      text = localizedCategoryNotificationTitle + ": "
    }
    text = text + takeBeforeText(eventTitle: eventTitle, remindBeforeDays: remindBeforeDays)
    return LNEvent(id: beforeLNEventId, date: remindBeforeDate, title: lnEventTitle, text: text, repeatIntevalEnum: repeatIntevalEnum)
  }

  private func takeNotificationTitle() -> String {
    let language = takeSettingsLanguageUseCase.execute()
    switch language {
    case .ukr:
      return appConfiguration.notificationTitle_uk
    case .eng:
      return appConfiguration.notificationTitle_en
    }
  }

  private func takeTodayText() -> String {
    let language = takeSettingsLanguageUseCase.execute()
    switch language {
    case .ukr:
      return "сьогодні"
    case .eng:
      return "today"
    }
  }

  private func takeBeforeText(eventTitle: String, remindBeforeDays: Int) -> String {
    let language = takeSettingsLanguageUseCase.execute()
    switch language {
    case .ukr:
      let dayText = takeUkrainianDayText(remindBeforeDays: remindBeforeDays)
      return "\(eventTitle) , через \(remindBeforeDays) \(dayText)"
    case .eng:
      return "\(eventTitle) , in \(remindBeforeDays) days"
    }
  }

  private func takeUkrainianDayText(remindBeforeDays: Int) -> String {
    let normalizedDays = abs(remindBeforeDays)
    let lastTwoDigits = normalizedDays % 100
    let lastDigit = normalizedDays % 10

    if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
      return "днів"
    }

    switch lastDigit {
    case 1:
      return "день"
    case 2:
      return "дня"
    case 3, 4:
      return "дні"
    default:
      return "днів"
    }
  }

  private func localizedCategoryNotificationTitle(for categoryType: CategoryTypeEnum) -> String? {
    let resource: LocalizedStringResource?
    switch categoryType {
    case .birthdays:
      resource = Localize.birthdays
    case .aniversaries:
      resource = Localize.aniversaries
    case .other_year, .other_month, .other_day:
      return nil
    }

    guard let resource else {
      return nil
    }
    let locale = locale(language: takeSettingsLanguageUseCase.execute())
    return String(localized: resource.localed(locale))
  }

  private func locale(language: LanguageEnum) -> Locale {
    switch language {
    case .ukr:
      return Locale(identifier: "uk")
    case .eng:
      return Locale(identifier: "en")
    }
  }
  
  public func scheduleAlerts(rescheduleEvents: [ScheduleNotificationsRescheduleEvent]) async throws {
    var lnEvents: [LNEvent] = []
    for rescheduleEvent in rescheduleEvents {
      let event = rescheduleEvent.originalEvent
      let eventPeriod = event.eventPeriod
      
      let repeatIntevalEnum: LNRepeatIntevalEnum
      switch eventPeriod {
      case .everyYear:
        repeatIntevalEnum = .year
      case .everyMonth:
        repeatIntevalEnum = .month
      case .everyDay:
        repeatIntevalEnum = .day
      }
      
      let eventTitle = event.title
      let localizedCategoryNotificationTitle = localizedCategoryNotificationTitle(for: rescheduleEvent.categoryTypeEnum)
      
      if rescheduleEvent.isToScheduleOnDay {
        let remindOnDayDate = event.remindOnDayDate
        let onDayLNEventId = event.onDayLNEventId
        let onDayLNEvent = takeOnDayLNEvent(remindOnDayDate: remindOnDayDate, onDayLNEventId: onDayLNEventId, eventTitle: eventTitle, repeatIntevalEnum: repeatIntevalEnum, localizedCategoryNotificationTitle: localizedCategoryNotificationTitle)
        if let onDayLNEvent {
          lnEvents.append(onDayLNEvent)
        }
      }
      
      if rescheduleEvent.isToScheduleBefore {
        let remindBeforeDate = event.remindBeforeDate
        let beforeLNEventId = event.beforeLNEventId
        let remindBeforeDays = event.remindBeforeDays
        let beforeLNEvent = takeBeforeLNEvent(remindBeforeDate: remindBeforeDate, beforeLNEventId: beforeLNEventId, eventTitle: eventTitle, repeatIntevalEnum: repeatIntevalEnum, remindBeforeDays: remindBeforeDays, localizedCategoryNotificationTitle: localizedCategoryNotificationTitle)
        if let beforeLNEvent {
          lnEvents.append(beforeLNEvent)
        }
      }
    }
    
    do {
      try await localNotificationService.schedule(lnEvents: lnEvents)
    } catch {
      throw SaveEventUseCaseError.failedToScheduleNotification
    }
  }
}
