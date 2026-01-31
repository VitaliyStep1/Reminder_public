//
//  ChangeCategoryIdForEventService.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 21.10.2025.
//

import Foundation
import DomainContracts
import PersistenceContracts

class CalculateCategoryIdForEventService {
  private let dbEventsService: DBEventsServiceProtocol
  private let dbCategoriesService: DBCategoriesServiceProtocol
  
  public init(dbEventsService: DBEventsServiceProtocol, dbCategoriesService: DBCategoriesServiceProtocol) {
    self.dbEventsService = dbEventsService
    self.dbCategoriesService = dbCategoriesService
  }
  
  func calculateNewCategoryIdForEditingEvent(eventId: Identifier, eventPeriod: EventPeriodEnum) async throws -> ObjectId? {
    let event = try await dbEventsService.fetchEvent(eventId: eventId)
    var newCategoryId: ObjectId? = nil
    if let categoryId = event.categoryId {
      if let category = try? await dbCategoriesService.fetchCategory(categoryId: categoryId) {
        let categoryGroup = category.categoryGroup
        if let sameGroupAllCategories = try? await dbCategoriesService.fetchAllCategoriesWithCategoryGroup(categoryGroup: categoryGroup) {
          newCategoryId = takeNewCategoryId(eventPeriod: eventPeriod, category: category, groupCategories: sameGroupAllCategories)
        }
      }
    }
    return newCategoryId
  }
  
  func calculateNewCategoryIdForCreatingEvent(categoryId: Identifier, eventPeriod: EventPeriodEnum) async throws -> ObjectId? {
    var newCategoryId: ObjectId? = nil
    if let category = try? await dbCategoriesService.fetchCategory(categoryId: categoryId) {
      let categoryGroup = category.categoryGroup
      if let sameGroupAllCategories = try? await dbCategoriesService.fetchAllCategoriesWithCategoryGroup(categoryGroup: categoryGroup) {
        newCategoryId = takeNewCategoryId(eventPeriod: eventPeriod, category: category, groupCategories: sameGroupAllCategories)
      }
    }
    return newCategoryId
  }
  
  private func takeNewCategoryId(eventPeriod: EventPeriodEnum, category: PersistenceContracts.Category, groupCategories: [PersistenceContracts.CategoryWithoutEventsAmount]) -> ObjectId? {
    let categoryRepeatEnum = CategoryRepeatEnum(fromRawValue: category.categoryRepeat)
    if categoryRepeatEnum.defaultEventPeriod == eventPeriod {
      return nil
    }
    let groupCategoryWithNecessaryEventPeriod = groupCategories.first { groupCategory in
      let groupCategoryRepeatEnum = CategoryRepeatEnum(fromRawValue: groupCategory.categoryRepeat)
      if groupCategoryRepeatEnum.defaultEventPeriod == eventPeriod {
        return true
      }
      return false
    }
    return groupCategoryWithNecessaryEventPeriod?.id
  }
}
