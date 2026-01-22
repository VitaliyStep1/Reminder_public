//
//  ClosestEntity.swift
//  ClosestTab
//
//  Created by Vitaliy Stepanenko on 30.10.2025.
//

import Foundation
import DomainContracts

enum ClosestEntity {
  
  enum ScreenStateEnum {
    case empty(title: LocalizedStringResource)
    case withData(rowTypes: [ClosestEntity.RowTypeEnum])
  }
  
  struct Event: Identifiable, Equatable {
    let id: Identifier
    let title: String
    let date: Date
    let categoryId: Identifier?
  }
  
  struct FutureEvent: Identifiable, Equatable {
    var id: Identifier {
      originalEvent.id
    }
    let originalEvent: Event
    let future1Date: Date
    let future2Date: Date
    let remindIconStateEnum: ClosestEntity.RemindIconStateEnum
  }
  
  enum FilterItemEnum {
    case all
    case category(Category)
  }
  
  struct Category: Identifiable {
    let id: Identifier
    let title: String
  }
  
  struct FilterItem {
    let id: UUID
    let title: String
    let filterItemEnum: FilterItemEnum
  }
  
  enum RowTypeEnum {
    case month(month: Month)
    case event(event: FutureEvent)
  }
  
  struct Month {
    let monthIndex: Int
    let year: Int
    let eventsCount: Int
  }
  
  enum RemindIconStateEnum {
    case scheduledReminds
    case notScheduledReminds
    case someRemindsAreScheduledAndSomeAreNot
    case noReminds
  }
}

extension ClosestEntity.RowTypeEnum: Identifiable {
  var id: String {
    switch self {
    case .month(let month):
      return "month-\(month.year)-\(month.monthIndex)"
    case .event(let event):
      return event.originalEvent.id.uuidString
    }
  }
}
