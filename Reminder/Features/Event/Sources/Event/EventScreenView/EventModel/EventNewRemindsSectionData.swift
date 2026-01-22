//
//  EventNewRemindsSectionData.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 12.11.2025.
//

import Foundation

@MainActor
class EventNewRemindsSectionData: ObservableObject {
  @Published var remindOnDayDate: Date?
  @Published var remindBeforeDate: Date?
  @Published var isNoNotificationPermissionViewVisible: Bool
  
  init(remindOnDayDate: Date?, remindBeforeDate: Date?, isNoNotificationPermissionViewVisible: Bool) {
    self.remindOnDayDate = remindOnDayDate
    self.remindBeforeDate = remindBeforeDate
    self.isNoNotificationPermissionViewVisible = isNoNotificationPermissionViewVisible
  }
  
  func takeStringFromDate(date: Date) -> String {
    let formatted = date.formatted(
      .dateTime.day(.twoDigits).month(.twoDigits).year(.defaultDigits).hour().minute()
    )
    return formatted
  }
}
