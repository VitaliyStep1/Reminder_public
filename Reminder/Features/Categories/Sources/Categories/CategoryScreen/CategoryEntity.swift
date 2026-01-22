//
//  CategoryEntity.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 02.10.2025.
//

import Foundation
import DomainContracts

enum CategoryEntity {
  struct Event: Identifiable {
    let id: Identifier
    let title: String
    let date: String
  }
  
  enum ScreenStateEnum {
    case empty(title: LocalizedStringResource)
    case withEvents(events: [CategoryEntity.Event])
  }
}
