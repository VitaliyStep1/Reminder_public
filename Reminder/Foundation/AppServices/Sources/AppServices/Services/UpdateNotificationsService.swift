//
//  UpdateNotificationsService.swift
//  AppServices
//
//  Created by Vitaliy Stepanenko on 01.01.2026.
//

import Domain
import DomainContracts
import Foundation
import PersistenceContracts
import AppServicesContracts

public final class UpdateNotificationsService: UpdateNotificationsServiceProtocol {
  
  struct DateAndEvent {
    let date: Date
    let event: DomainContracts.Event
    let isOnDay: Bool
  }

  private let dbEventsService: DBEventsServiceProtocol
  private let dBCategoriesService: DBCategoriesServiceProtocol
  private let calculateRemindDatesForEventService: CalculateRemindDatesForEventService
  private let scheduleNotificationsService: ScheduleNotificationsServiceProtocol
  
  public init(
    dbEventsService: DBEventsServiceProtocol,
    dBCategoriesService: DBCategoriesServiceProtocol,
    scheduleNotificationsService: ScheduleNotificationsServiceProtocol
  ) {
    self.dbEventsService = dbEventsService
    self.dBCategoriesService = dBCategoriesService
    self.calculateRemindDatesForEventService = CalculateRemindDatesForEventService()
    self.scheduleNotificationsService = scheduleNotificationsService
  }

  public func updateNotifications() async throws {
    let eventsToReschedule = await takeEventsToReschedule()
    
    try await scheduleNotificationsService.scheduleAlerts(rescheduleEvents: eventsToReschedule)
  }
  
  private func takeEventsToReschedule() async -> [ScheduleNotificationsRescheduleEvent] {

    let events = await takeAllEvents()
    let categories = await takeAllCategories()
    let categoriesById = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })

    let eventsWithUpdatedOnDayDateAndBeforeDate = takeEventsWithUpdatedOnDayDateAndBeforeDate(events: events)

    var datesAndEvents: [DateAndEvent] = []
    for event in eventsWithUpdatedOnDayDateAndBeforeDate {
      if let remindOnDayDate = event.remindOnDayDate {
        let dateAndEvent = DateAndEvent(date: remindOnDayDate, event: event, isOnDay: true)
        datesAndEvents.append(dateAndEvent)
      }
      if let remindBeforeDate = event.remindBeforeDate {
        let dateAndEvent = DateAndEvent(date: remindBeforeDate, event: event, isOnDay: false)
        datesAndEvents.append(dateAndEvent)
      }
    }
    
    let datesAndEventsSorted: [DateAndEvent] = datesAndEvents.sorted { $0.date < $1.date }
    let datesAndEventsSortedFirstN = datesAndEventsSorted.dropFirst(Constants.maxNotificationAmount)
    
    var rescheduleEventDict: [DomainContracts.Event: ScheduleNotificationsRescheduleEvent] = [:]
    for dateAndEvent in datesAndEventsSortedFirstN {
      let isToScheduleOnDay: Bool
      let isToScheduleBefore: Bool
      
      let rescheduleEvent = rescheduleEventDict[dateAndEvent.event]
      if let rescheduleEvent {
        if dateAndEvent.isOnDay {
          isToScheduleOnDay = true
          isToScheduleBefore = rescheduleEvent.isToScheduleBefore
        } else {
          isToScheduleOnDay = rescheduleEvent.isToScheduleOnDay
          isToScheduleBefore = true
        }
      } else {
        isToScheduleOnDay = dateAndEvent.isOnDay
        isToScheduleBefore = !dateAndEvent.isOnDay
      }
      let categoryType = dateAndEvent.event.categoryId.flatMap { categoriesById[$0]?.categoryTypeEnum } ?? .other_day
      let newRescheduleEvent = ScheduleNotificationsRescheduleEvent(
        originalEvent: dateAndEvent.event,
        isToScheduleOnDay: isToScheduleOnDay,
        isToScheduleBefore: isToScheduleBefore,
        categoryTypeEnum: categoryType
      )
      rescheduleEventDict[dateAndEvent.event] = newRescheduleEvent
    }
    
    let rescheduleEvents = Array(rescheduleEventDict.values)
    return rescheduleEvents
  }

  private func takeAllEvents() async -> [DomainContracts.Event] {
    do {
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
    } catch {
      return []
    }
  }

  private func takeAllCategories() async -> [DomainContracts.Category] {
    do {
      let categories = try await dBCategoriesService.fetchAllCategories()
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
    } catch {
      return []
    }
  }

  private func takeEventsWithUpdatedOnDayDateAndBeforeDate(events: [DomainContracts.Event]) -> [DomainContracts.Event] {
    return events.map { event in
      let (remindOnDayDate, remindBeforeDate) = calculateRemindDatesForEventService.calculateRemindDates(
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
