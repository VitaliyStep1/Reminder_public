//
//  DefaultCategoriesDataServiceProtocol.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 10.09.2025.
//

import DomainContracts

public protocol DefaultCategoriesDataServiceProtocol: Sendable {
  func takeDefaultCategories() -> [DefaultCategory]
}
