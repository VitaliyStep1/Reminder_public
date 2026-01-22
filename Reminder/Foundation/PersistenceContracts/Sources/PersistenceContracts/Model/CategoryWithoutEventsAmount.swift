//
//  CategoryWithoutEventsAmount.swift
//  PersistenceContracts
//
//  Created by Vitaliy Stepanenko on 21.10.2025.
//

import Foundation

public struct CategoryWithoutEventsAmount: Identifiable, Sendable {
  public let id: ObjectId
  public let defaultKey: String
  public var title: String
  public let order: Int
  public let isUserCreated: Bool
  public var categoryRepeat: Int
  public var categoryGroup: Int
  
  public init(
    id: ObjectId,
    defaultKey: String,
    title: String,
    order: Int,
    isUserCreated: Bool,
    categoryRepeat: Int,
    categoryGroup: Int
  ) {
    self.id = id
    self.defaultKey = defaultKey
    self.title = title
    self.order = order
    self.isUserCreated = isUserCreated
    self.categoryRepeat = categoryRepeat
    self.categoryGroup = categoryGroup
  }
}
