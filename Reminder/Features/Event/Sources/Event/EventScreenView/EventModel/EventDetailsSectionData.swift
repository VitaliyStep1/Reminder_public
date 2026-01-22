//
//  EventDetailsSectionData.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 12.11.2025.
//

import Foundation
import DomainContracts

@MainActor
class EventDetailsSectionData: ObservableObject {
  @Published var eventTitle: String
  @Published var eventComment: String
  @Published var eventDate: Date
  @Published var isYearIncluded: Bool
  @Published var categoryType: CategoryTypeEnum?

  init(eventTitle: String, eventComment: String, eventDate: Date, isYearIncluded: Bool, categoryType: CategoryTypeEnum? = nil) {
    self.eventTitle = eventTitle
    self.eventComment = eventComment
    self.eventDate = eventDate
    self.isYearIncluded = isYearIncluded
    self.categoryType = categoryType
  }
}
