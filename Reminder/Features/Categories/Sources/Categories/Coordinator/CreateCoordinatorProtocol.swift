//
//  CreateCoordinatorProtocol.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 16.11.2025.
//

import SwiftUI
import NavigationContracts
import DomainContracts

public protocol CreateCoordinatorProtocol: AnyObject, CoordinatorProtocol {
  var router: any CreateRouterProtocol { get }
  func destination(for route: CreateRoute) -> AnyView
  func categoriesScreenCategoryWasClicked(categoryId: Identifier)
}
