//
//  EventPeriodEnum.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 17.10.2025.
//

public enum EventPeriodEnum: Int, CaseIterable, Sendable {
  case everyYear = 1
  case everyMonth = 2
  case everyDay = 3

  public init(fromRawValue: Int) {
    self = Self.init(rawValue: fromRawValue) ?? .everyYear
  }
}
