//
//  LocalNotificationService.swift
//  Platform
//
//  Created by Vitaliy Stepanenko on 16.12.2025.
//

import Foundation
import UserNotifications

public class LocalNotificationService: LocalNotificationServiceProtocol {
  public init() {}
  
  public func schedule(lnEvents: [LNEvent]) async throws {
    var scheduleIdentifiers: [String] = []
    for lnEvent in lnEvents {
      do {
        let scheduleId = lnEvent.id
        try await schedule(lnEvent: lnEvent)
        scheduleIdentifiers.append(scheduleId.uuidString)
      } catch {
        cancelNotifications(ids: scheduleIdentifiers)
        throw LNError.failedToScheduleNotification
      }
    }
  }
  
  public func schedule(lnEvent: LNEvent) async throws {
    let lnEventId: UUID = lnEvent.id
    let date: Date = lnEvent.date
    let title: String = lnEvent.title
    let text: String = lnEvent.text
    let repeatIntevalEnum: LNRepeatIntevalEnum = lnEvent.repeatIntevalEnum
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = text
    content.sound = .default
    
    let isRepeating: Bool = repeatIntevalEnum != .notRepeat
    var dateComponents = DateComponents()
    switch repeatIntevalEnum {
    case .year:
      let components = Calendar.current.dateComponents([
        .month,
        .day,
        .hour,
        .minute
      ], from: date)
      dateComponents = components
    case .month:
      let components = Calendar.current.dateComponents([
        .day,
        .hour,
        .minute
      ], from: date)
      dateComponents = components
    case .day:
      let components = Calendar.current.dateComponents([
        .hour,
        .minute
      ], from: date)
      dateComponents = components
    case .notRepeat:
      let components = Calendar.current.dateComponents([
        .year,
        .month,
        .day,
        .hour,
        .minute,
        .second
      ], from: date)
      dateComponents = components
    }
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isRepeating)
    let identifierString = lnEventId.uuidString
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    let request = UNNotificationRequest(identifier: identifierString, content: content, trigger: trigger)
    do {
      try await notificationCenter.add(request)
    } catch {
      throw LNError.failedToScheduleNotification
    }
  }
  
  public func cancelNotification(id: String) {
    cancelNotifications(ids: [id])
  }
  
  public func cancelNotifications(ids: [String]) {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ids)
    center.removeDeliveredNotifications(withIdentifiers: ids)
  }

  public func getPendingNotificationsIds() async -> [String] {
    let center = UNUserNotificationCenter.current()
    let requests = await center.pendingRequests()
    let notificationsIds: [String] = requests.map(\.identifier)
    return notificationsIds
  }
}
