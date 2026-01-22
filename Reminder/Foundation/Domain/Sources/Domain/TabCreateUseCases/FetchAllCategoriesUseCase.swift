//
//  FetchAllCategoriesUseCase.swift
//  Domain
//
//  Created as part of Clean Architecture refactor.
//

import Foundation
import DomainContracts
import PersistenceContracts

public struct FetchAllCategoriesUseCase: FetchAllCategoriesUseCaseProtocol {
  private let dBCategoriesService: DBCategoriesServiceProtocol

  public init(dBCategoriesService: DBCategoriesServiceProtocol) {
    self.dBCategoriesService = dBCategoriesService
  }

  public func execute() async throws -> [DomainContracts.Category] {
    let categories = try await dBCategoriesService.fetchAllCategories()
    return categories.map { category in
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
