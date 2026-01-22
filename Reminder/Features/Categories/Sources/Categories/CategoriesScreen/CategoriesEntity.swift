//
//  CategoriesEntity.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 23.08.2025.
//

import Foundation
import DomainContracts

enum CategoriesEntity {
  struct Category: Identifiable, Hashable {
    let id: Identifier
    let title: String
    let eventsAmount: Int
    
    init(id: Identifier, title: String, eventsAmount: Int) {
      self.id = id
      self.title = title
      self.eventsAmount = eventsAmount
    }
  }
  
  enum ScreenStateEnum {
    case empty(title: LocalizedStringResource)
    case withCategories(categories: [CategoriesEntity.Category])
  }
}
