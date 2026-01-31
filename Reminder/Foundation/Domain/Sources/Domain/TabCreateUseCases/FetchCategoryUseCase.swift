//
//  FetchCategoryUseCase.swift
//  Domain
//
//  Created as part of Clean Architecture refactor.
//

import Foundation
import DomainContracts
import PersistenceContracts

public struct FetchCategoryUseCase: FetchCategoryUseCaseProtocol {
  private let dbCategoriesService: DBCategoriesServiceProtocol

  public init(dbCategoriesService: DBCategoriesServiceProtocol) {
    self.dbCategoriesService = dbCategoriesService
  }

  public func execute(categoryId: Identifier) async throws -> DomainContracts.Category? {
    let category = try? await dbCategoriesService.fetchCategory(categoryId: categoryId)
    return category.flatMap { category in
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
  }
}
