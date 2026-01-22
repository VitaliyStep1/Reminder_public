//
//  DBEventsServiceProtocol.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 13.09.2025.
//

import Foundation

public protocol DBEventsServiceProtocol: Sendable {
  func createEvent(categoryId: ObjectId, eventId: UUID, title: String, date: Date, comment: String, eventPeriod: Int, isRemindRepeated: Bool, remindOnDayTimeDate: Date, remindOnDayDate: Date?, isRemindOnDayActive: Bool, remindBeforeDays: Int, remindBeforeDate: Date?, remindBeforeTimeDate: Date, isRemindBeforeActive: Bool, onDayLNEventId: UUID, beforeLNEventId: UUID) async throws
  func editEvent(eventId: ObjectId, title: String, date: Date, comment: String, eventPeriod: Int, isRemindRepeated: Bool, remindOnDayTimeDate: Date, remindOnDayDate: Date?, isRemindOnDayActive: Bool, remindBeforeDays: Int, remindBeforeDate: Date?, remindBeforeTimeDate: Date, isRemindBeforeActive: Bool, onDayLNEventId: UUID, beforeLNEventId: UUID, newCategoryId: ObjectId?) async throws
  func deleteEvent(eventId: ObjectId) async throws
  func fetchEvents(categoryId: ObjectId) async throws -> [Event]
  func fetchEvent(eventId: ObjectId) async throws -> Event
  func fetchAllEvents() async throws -> [Event]
}
