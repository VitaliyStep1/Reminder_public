//
//  Category.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 23.08.2025.
//

import Foundation

public struct Category: Identifiable, Sendable {
  public let id: ObjectId
  public let defaultKey: String
  public var title: String
  public let order: Int
  public let isUserCreated: Bool
  public var eventsAmount: Int
  public var categoryRepeat: Int
  public var categoryGroup: Int

  public init(
    id: ObjectId,
    defaultKey: String,
    title: String,
    order: Int,
    isUserCreated: Bool,
    eventsAmount: Int,
    categoryRepeat: Int,
    categoryGroup: Int
  ) {
    self.id = id
    self.defaultKey = defaultKey
    self.title = title
    self.order = order
    self.isUserCreated = isUserCreated
    self.eventsAmount = eventsAmount
    self.categoryRepeat = categoryRepeat
    self.categoryGroup = categoryGroup
  }
}
