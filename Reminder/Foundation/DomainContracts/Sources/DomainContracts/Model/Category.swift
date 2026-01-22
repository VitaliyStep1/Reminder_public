//
//  Category.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 23.08.2025.
//

import Foundation

public struct Category: Sendable, Identifiable {
  public let id: Identifier
  public let categoryTypeEnum: CategoryTypeEnum
  public var title: String
  public let order: Int
  public let isUserCreated: Bool
  public var eventsAmount: Int
  public var categoryRepeat: CategoryRepeatEnum
  public let categoryGroup: CategoryGroupEnum

  public init(
    id: Identifier,
    defaultKey: String,
    title: String,
    order: Int,
    isUserCreated: Bool,
    eventsAmount: Int,
    categoryRepeat: CategoryRepeatEnum,
    categoryGroup: CategoryGroupEnum
  ) {
    self.id = id
    self.categoryTypeEnum = CategoryTypeEnum(rawValue: defaultKey)!
    self.title = title
    self.order = order
    self.isUserCreated = isUserCreated
    self.eventsAmount = eventsAmount
    self.categoryRepeat = categoryRepeat
    self.categoryGroup = categoryGroup
  }
}
