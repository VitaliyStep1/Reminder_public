//
//  CategoryRepeatEnum.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 18.10.2025.
//

public enum CategoryRepeatEnum: Int, CaseIterable, Sendable {
  case repeatEveryYear_notChoose = 1
  case repeatEveryMonth_notChoose = 2
  case repeatEveryDay_notChoose = 3
  case repeatEveryYear_chooseAll = 4
  case repeatEveryMonth_chooseAll = 5
  case repeatEveryDay_chooseAll = 6
  
  public init(fromRawValue: Int) {
    self = Self.init(rawValue: fromRawValue) ?? .repeatEveryYear_notChoose
  }

  public var defaultEventPeriod: EventPeriodEnum {
    switch self {
    case .repeatEveryYear_notChoose:
      return .everyYear
    case .repeatEveryMonth_notChoose:
      return .everyMonth
    case .repeatEveryDay_notChoose:
      return .everyDay
    case .repeatEveryYear_chooseAll:
      return .everyYear
    case .repeatEveryMonth_chooseAll:
      return .everyMonth
    case .repeatEveryDay_chooseAll:
      return .everyDay
    }
  }
  
  public var chooseOptions: [EventPeriodEnum] {
    switch self {
    case .repeatEveryYear_chooseAll,
        .repeatEveryMonth_chooseAll,
        .repeatEveryDay_chooseAll:
      return [.everyYear, .everyMonth, .everyDay]
    default:
      return []
    }
  }
}
