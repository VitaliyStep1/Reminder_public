//
//  DBEventsService.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 13.09.2025.
//

import CoreData
import PersistenceContracts

public final class DBEventsService: DBEventsServiceProtocol, Sendable {
  private let container: NSPersistentContainer
  private var context: NSManagedObjectContext {
    container.viewContext
  }
  
  public init(container: NSPersistentContainer) {
    self.container = container
  }
  
  public func createEvent(
    categoryId: ObjectId,
    eventId: UUID,
    title: String,
    date: Date,
    comment: String,
    eventPeriod: Int,
    isRemindRepeated: Bool,
    remindOnDayTimeDate: Date,
    remindOnDayDate: Date?,
    isRemindOnDayActive: Bool,
    remindBeforeDays: Int,
    remindBeforeDate: Date?,
    remindBeforeTimeDate: Date,
    isRemindBeforeActive: Bool,
    onDayLNEventId: UUID,
    beforeLNEventId: UUID
  ) async throws {
    try await withCheckedThrowingContinuation { continuation in
      container.performBackgroundTask { [self] context in
        do {
          guard let category = try self.fetchCategoryObject(with: categoryId, context: context) else {
            throw CreateEventError.categoryWasNotFetched
          }
          
          let event = EventObject(context: context)
          event.identifier = eventId
          event.title = title
          event.date = date
          event.comment = comment
          event.eventPeriod = takeInt16PeriodValue(eventPeriod)
          event.isRemindRepeated = isRemindRepeated
          event.remindOnDayTimeDate = remindOnDayTimeDate
          event.remindOnDayDate = remindOnDayDate
          event.isRemindOnDayActive = isRemindOnDayActive
          event.remindBeforeDays = Int16(remindBeforeDays)
          event.remindBeforeDate = remindBeforeDate
          event.remindBeforeTimeDate = remindBeforeTimeDate
          event.isRemindBeforeActive = isRemindBeforeActive
          event.onDayLNEventId = onDayLNEventId
          event.beforeLNEventId = beforeLNEventId
          event.category = category
          try context.save()

          continuation.resume(returning: ())
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  public func editEvent(
    eventId: ObjectId,
    title: String,
    date: Date,
    comment: String,
    eventPeriod: Int,
    isRemindRepeated: Bool,
    remindOnDayTimeDate: Date,
    remindOnDayDate: Date?,
    isRemindOnDayActive: Bool,
    remindBeforeDays: Int,
    remindBeforeDate: Date?,
    remindBeforeTimeDate: Date,
    isRemindBeforeActive: Bool,
    onDayLNEventId: UUID,
    beforeLNEventId: UUID,
    newCategoryId: ObjectId?
  ) async throws {
    try await withCheckedThrowingContinuation { continuation in
      container.performBackgroundTask { [self] context in
        do {
          var newCategory: CategoryObject?
          if let newCategoryId {
            guard let category = try self.fetchCategoryObject(with: newCategoryId, context: context) else {
              throw CreateEventError.categoryWasNotFetched
            }
            newCategory = category
          }
          
          guard let eventObject = try self.fetchEventObject(with: eventId, context: context) else {
            throw EditEventError.eventWasNotFetched
          }
          
          // Update properties
          eventObject.title = title
          eventObject.date = date
          eventObject.comment = comment
          eventObject.eventPeriod = takeInt16PeriodValue(eventPeriod)
          eventObject.isRemindRepeated = isRemindRepeated
          eventObject.remindOnDayTimeDate = remindOnDayTimeDate
          eventObject.remindOnDayDate = remindOnDayDate
          eventObject.isRemindOnDayActive = isRemindOnDayActive
          eventObject.remindBeforeDays = Int16(remindBeforeDays)
          eventObject.remindBeforeDate = remindBeforeDate
          eventObject.remindBeforeTimeDate = remindBeforeTimeDate
          eventObject.isRemindBeforeActive = isRemindBeforeActive
          eventObject.onDayLNEventId = onDayLNEventId
          eventObject.beforeLNEventId = beforeLNEventId
          if let newCategory {
            eventObject.category = newCategory
          }
          
          try context.save()

          continuation.resume(returning: ())
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  public func deleteEvent(eventId: ObjectId) async throws {
    try await withCheckedThrowingContinuation { continuation in
      container.performBackgroundTask { context in
        do {
          guard let eventObject = try self.fetchEventObject(with: eventId, context: context) else {
            throw DeleteEventError.eventWasNotFetched
          }
          
          context.delete(eventObject)
          try context.save()
          
          continuation.resume(returning: ())
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  public func fetchEvents(categoryId: ObjectId) async throws -> [Event] {
    try await withCheckedThrowingContinuation { continuation in
      container.performBackgroundTask { context in
        do {
          guard let category = try self.fetchCategoryObject(with: categoryId, context: context) else {
            continuation.resume(throwing: FetchCategoryError.categoryWasNotFetched)
            return
          }
          
          let request = EventObject.fetchRequest()
          request.predicate = NSPredicate(format: "category == %@", category)
          request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
          request.returnsObjectsAsFaults = false
          let eventObjects = try context.fetch(request)
          let events = eventObjects.map { eventObject in
            Event(
              id: eventObject.identifier,
              title: eventObject.title ?? "",
              date: eventObject.date ?? Date(),
              comment: eventObject.comment ?? "",
              categoryId: category.identifier,
              eventPeriod: Int(eventObject.eventPeriod),
              isRemindRepeated: eventObject.isRemindRepeated,
              remindOnDayTimeDate: eventObject.remindOnDayTimeDate,
              remindOnDayDate: eventObject.remindOnDayDate,
              isRemindOnDayActive: eventObject.isRemindOnDayActive,
              remindBeforeDays: Int(eventObject.remindBeforeDays),
              remindBeforeDate: eventObject.remindBeforeDate,
              remindBeforeTimeDate: eventObject.remindBeforeTimeDate,
              isRemindBeforeActive: eventObject.isRemindBeforeActive,
              onDayLNEventId: eventObject.onDayLNEventId,
              beforeLNEventId: eventObject.beforeLNEventId
            )
          }
          continuation.resume(returning: events)
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  public func fetchEvent(eventId: ObjectId) async throws -> Event {
    try await withCheckedThrowingContinuation { continuation in
      container.performBackgroundTask { context in
        do {
          guard let eventObject = try self.fetchEventObject(with: eventId, context: context) else {
            continuation.resume(throwing: FetchEventError.eventWasNotFetched)
            return
          }
          
          let event = Event(
            id: eventObject.identifier,
            title: eventObject.title ?? "",
            date: eventObject.date ?? Date(),
            comment: eventObject.comment ?? "",
            categoryId: eventObject.category?.identifier,
            eventPeriod: Int(eventObject.eventPeriod),
            isRemindRepeated: eventObject.isRemindRepeated,
            remindOnDayTimeDate: eventObject.remindOnDayTimeDate,
            remindOnDayDate: eventObject.remindOnDayDate,
            isRemindOnDayActive: eventObject.isRemindOnDayActive,
            remindBeforeDays: Int(eventObject.remindBeforeDays),
            remindBeforeDate: eventObject.remindBeforeDate,
            remindBeforeTimeDate: eventObject.remindBeforeTimeDate,
            isRemindBeforeActive: eventObject.isRemindBeforeActive,
            onDayLNEventId: eventObject.onDayLNEventId,
            beforeLNEventId: eventObject.beforeLNEventId
          )

          continuation.resume(returning: event)
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }

  public func fetchAllEvents() async throws -> [Event] {
    try await withCheckedThrowingContinuation { continuation in
      container.performBackgroundTask { context in
        do {
          let request = EventObject.fetchRequest()
          request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
          request.returnsObjectsAsFaults = false
          let eventObjects = try context.fetch(request)
          let events = eventObjects.map { eventObject in
            Event(
              id: eventObject.identifier,
              title: eventObject.title ?? "",
              date: eventObject.date ?? Date(),
              comment: eventObject.comment ?? "",
              categoryId: eventObject.category?.identifier,
              eventPeriod: Int(eventObject.eventPeriod),
              isRemindRepeated: eventObject.isRemindRepeated,
              remindOnDayTimeDate: eventObject.remindOnDayTimeDate,
              remindOnDayDate: eventObject.remindOnDayDate,
              isRemindOnDayActive: eventObject.isRemindOnDayActive,
              remindBeforeDays: Int(eventObject.remindBeforeDays),
              remindBeforeDate: eventObject.remindBeforeDate,
              remindBeforeTimeDate: eventObject.remindBeforeTimeDate,
              isRemindBeforeActive: eventObject.isRemindBeforeActive,
              onDayLNEventId: eventObject.onDayLNEventId,
              beforeLNEventId: eventObject.beforeLNEventId
            )
          }
          continuation.resume(returning: events)
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  private func fetchCategoryObject(with id: UUID, context: NSManagedObjectContext) throws -> CategoryObject? {
    let request: NSFetchRequest<CategoryObject> = CategoryObject.fetchRequest()
    request.predicate = NSPredicate(format: "identifier == %@", id as CVarArg)
    request.fetchLimit = 1
    return try context.fetch(request).first
  }
  
  private func fetchEventObject(with id: UUID, context: NSManagedObjectContext) throws -> EventObject? {
    let request: NSFetchRequest<EventObject> = EventObject.fetchRequest()
    request.predicate = NSPredicate(format: "identifier == %@", id as CVarArg)
    request.fetchLimit = 1
    return try context.fetch(request).first
  }

  private func takeInt16PeriodValue(_ eventPeriod: Int) -> Int16 {
      return Int16(eventPeriod)
  }
}
