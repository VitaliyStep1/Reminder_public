//
//  SetupInitialDataUseCase.swift
//  Domain
//
//  Created as part of Clean Architecture refactor.
//

import Foundation
import AppServicesContracts
import DomainContracts
import PersistenceContracts

public struct SetupInitialDataUseCase: SetupInitialDataUseCaseProtocol {
  private let defaultCategoriesDataService: DefaultCategoriesDataServiceProtocol
  private let dBCategoriesService: DBCategoriesServiceProtocol

  public init(
    defaultCategoriesDataService: DefaultCategoriesDataServiceProtocol,
    dBCategoriesService: DBCategoriesServiceProtocol
  ) {
    self.defaultCategoriesDataService = defaultCategoriesDataService
    self.dBCategoriesService = dBCategoriesService
  }

  public func execute() async {
    let defaultCategories = defaultCategoriesDataService.takeDefaultCategories()
    let persistenceDefaultCategories = defaultCategories.map {
      PersistenceContracts.DefaultCategory(
        defaultKey: $0.defaultKey,
        title: $0.title,
        order: $0.order,
        isUserCreated: $0.isUserCreated,
        categoryRepeat: $0.categoryRepeat.rawValue,
        categoryGroup: $0.categoryGroup.rawValue
      )
    }

    try? await dBCategoriesService.addOrUpdate(defaultCategories: persistenceDefaultCategories)
  }
}
