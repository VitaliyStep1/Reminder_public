//
//  ScheduleRepeatIntevalEnum.swift
//  Platform
//
//  Created by Vitaliy Stepanenko on 24.12.2025.
//

import Foundation

public enum LNRepeatIntevalEnum {
  case year
  case month
  case day
  case notRepeat
}

public enum LNError: Error {
  case failedToScheduleNotification
}

public struct LNEvent {
  public let id: UUID
  public let date: Date
  let title: String
  let text: String
  let repeatIntevalEnum: LNRepeatIntevalEnum
  public init(id: UUID, date: Date, title: String, text: String, repeatIntevalEnum: LNRepeatIntevalEnum) {
    self.id = id
    self.date = date
    self.title = title
    self.text = text
    self.repeatIntevalEnum = repeatIntevalEnum
  }
}
