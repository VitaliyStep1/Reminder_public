//
//  UpdateNotificationsService.swift
//  AppServices
//
//  Created by Vitaliy Stepanenko on 01.01.2026.
//

import DomainContracts
import Foundation
import PersistenceContracts
import AppServicesContracts

public final class UpdateNotificationsService: UpdateNotificationsServiceProtocol {
  
  private enum EventTypeEnum {
    case onDay
    case before
  }
  
  private struct DateAndEvent {
    let date: Date
    let event: DomainContracts.Event
    let eventTypeEnum: EventTypeEnum
  }
  
  private let dbEventsService: DBEventsServiceProtocol
  private let dbCategoriesService: DBCategoriesServiceProtocol
  private let calculateRemindDatesForEventService: CalculateRemindDatesForEventServiceProtocol
  private let scheduleNotificationsService: ScheduleNotificationsServiceProtocol
  
  public init(
    dbEventsService: DBEventsServiceProtocol,
    dbCategoriesService: DBCategoriesServiceProtocol,
    scheduleNotificationsService: ScheduleNotificationsServiceProtocol,
    calculateRemindDatesForEventService: CalculateRemindDatesForEventServiceProtocol
  ) {
    self.dbEventsService = dbEventsService
    self.dbCategoriesService = dbCategoriesService
    self.calculateRemindDatesForEventService = calculateRemindDatesForEventService
    self.scheduleNotificationsService = scheduleNotificationsService
  }
  
  public func updateNotifications() async throws {
    let eventsToReschedule = try await takeEventsToReschedule()
    
    try await scheduleNotificationsService.scheduleAlerts(rescheduleEvents: eventsToReschedule)
  }
  
  private func takeEventsToReschedule() async throws -> [ScheduleNotificationsRescheduleEvent] {
    
    async let asyncEvents = takeAllEvents()
    async let asyncCategories = takeAllCategories()
    let (events, categories) = try await (asyncEvents, asyncCategories)
    
    let categoriesDict = Dictionary(categories.map { ($0.id, $0) }, uniquingKeysWith: { old, new in
      new
    })
    
    let eventsWithUpdatedOnDayDateAndBeforeDate = try takeEventsWithUpdatedOnDayDateAndBeforeDate(events: events)
    
    var datesAndEvents: [DateAndEvent] = []
    for event in eventsWithUpdatedOnDayDateAndBeforeDate {
      if let remindOnDayDate = event.remindOnDayDate {
        let dateAndEvent = DateAndEvent(date: remindOnDayDate, event: event, eventTypeEnum: .onDay)
        datesAndEvents.append(dateAndEvent)
      }
      if let remindBeforeDate = event.remindBeforeDate {
        let dateAndEvent = DateAndEvent(date: remindBeforeDate, event: event, eventTypeEnum: .before)
        datesAndEvents.append(dateAndEvent)
      }
    }
    
    let datesAndEventsSorted: [DateAndEvent] = datesAndEvents.sorted { $0.date < $1.date }
    let datesAndEventsSortedFirstN = datesAndEventsSorted.prefix(Constants.maxNotificationAmount)
    
    var rescheduleEventDict: [Identifier: ScheduleNotificationsRescheduleEvent] = [:]
    for dateAndEvent in datesAndEventsSortedFirstN {
      let isToScheduleOnDay: Bool
      let isToScheduleBefore: Bool
      
      let rescheduleEvent = rescheduleEventDict[dateAndEvent.event.id]
      if let rescheduleEvent {
        switch dateAndEvent.eventTypeEnum {
        case .onDay:
          isToScheduleOnDay = true
          isToScheduleBefore = rescheduleEvent.isToScheduleBefore
        case .before:
          isToScheduleOnDay = rescheduleEvent.isToScheduleOnDay
          isToScheduleBefore = true
        }
      } else {
        isToScheduleOnDay = dateAndEvent.eventTypeEnum == .onDay
        isToScheduleBefore = dateAndEvent.eventTypeEnum == .before
      }
      let categoryType = dateAndEvent.event.categoryId.flatMap { categoriesDict[$0]?.categoryTypeEnum } ?? .other_day
      let newRescheduleEvent = ScheduleNotificationsRescheduleEvent(
        originalEvent: dateAndEvent.event,
        isToScheduleOnDay: isToScheduleOnDay,
        isToScheduleBefore: isToScheduleBefore,
        categoryTypeEnum: categoryType
      )
      rescheduleEventDict[dateAndEvent.event.id] = newRescheduleEvent
    }
    
    let rescheduleEvents = Array(rescheduleEventDict.values)
    return rescheduleEvents
  }
  
  private func takeAllEvents() async throws -> [DomainContracts.Event] {
    let dbEvents = try await dbEventsService.fetchAllEvents()
    return dbEvents.map { event in
      Event(
        id: event.id,
        title: event.title,
        date: event.date,
        comment: event.comment,
        categoryId: event.categoryId,
        eventPeriod: EventPeriodEnum(fromRawValue: event.eventPeriod),
        isRemindRepeated: event.isRemindRepeated,
        remindOnDayTimeDate: event.remindOnDayTimeDate,
        remindOnDayDate: event.remindOnDayDate,
        isRemindOnDayActive: event.isRemindOnDayActive,
        remindBeforeDays: event.remindBeforeDays,
        remindBeforeDate: event.remindBeforeDate,
        remindBeforeTimeDate: event.remindBeforeTimeDate,
        isRemindBeforeActive: event.isRemindBeforeActive,
        onDayLNEventId: event.onDayLNEventId,
        beforeLNEventId: event.beforeLNEventId
      )
    }
  }
  
  private func takeAllCategories() async throws -> [DomainContracts.Category] {
    let categories = try await dbCategoriesService.fetchAllCategories()
    return categories.map { category in
      let categoryRepeat = CategoryRepeatEnum(fromRawValue: category.categoryRepeat)
      let categoryGroup = CategoryGroupEnum(fromRawValue: category.categoryGroup)
      return DomainContracts.Category(
        id: category.id,
        defaultKey: category.defaultKey,
        title: category.title,
        order: category.order,
        isUserCreated: category.isUserCreated,
        eventsAmount: category.eventsAmount,
        categoryRepeat: categoryRepeat,
        categoryGroup: categoryGroup
      )
    }
  }
  
  private func takeEventsWithUpdatedOnDayDateAndBeforeDate(events: [DomainContracts.Event]) throws -> [DomainContracts.Event] {
    return try events.map { event in
      let (remindOnDayDate, remindBeforeDate) = try calculateRemindDatesForEventService.calculateRemindDates(
        eventDate: event.date,
        eventPeriod: event.eventPeriod,
        isRemindRepeated: event.isRemindRepeated,
        remindOnDayTimeDate: event.remindOnDayTimeDate,
        isRemindOnDayActive: event.isRemindOnDayActive,
        remindBeforeDays: event.remindBeforeDays,
        remindBeforeTimeDate: event.remindBeforeTimeDate,
        isRemindBeforeActive: event.isRemindBeforeActive
      )
      
      return Event(
        id: event.id,
        title: event.title,
        date: event.date,
        comment: event.comment,
        categoryId: event.categoryId,
        eventPeriod: event.eventPeriod,
        isRemindRepeated: event.isRemindRepeated,
        remindOnDayTimeDate: event.remindOnDayTimeDate,
        remindOnDayDate: remindOnDayDate,
        isRemindOnDayActive: event.isRemindOnDayActive,
        remindBeforeDays: event.remindBeforeDays,
        remindBeforeDate: remindBeforeDate,
        remindBeforeTimeDate: event.remindBeforeTimeDate,
        isRemindBeforeActive: event.isRemindBeforeActive,
        onDayLNEventId: event.onDayLNEventId,
        beforeLNEventId: event.beforeLNEventId
      )
    }
  }
}

