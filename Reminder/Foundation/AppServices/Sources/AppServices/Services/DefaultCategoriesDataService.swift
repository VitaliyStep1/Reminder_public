//
//  DefaultCategoriesDataService.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 10.09.2025.
//

import AppServicesContracts
import DomainContracts

public final class DefaultCategoriesDataService: DefaultCategoriesDataServiceProtocol, Sendable {
  
  public init() { }
  
  public enum CategoryKeyEnum: CaseIterable {
    case birthdays
    case aniversaries
    case other_repeatEveryYear
    case other_repeatEveryMonth
    case other_repeatEveryDay
    
    public var key: String {
      switch self {
      case .birthdays:
        CategoryTypeEnum.birthdays.rawValue
      case .aniversaries:
        CategoryTypeEnum.aniversaries.rawValue
      case .other_repeatEveryYear:
        CategoryTypeEnum.other_year.rawValue
      case .other_repeatEveryMonth:
        CategoryTypeEnum.other_month.rawValue
      case .other_repeatEveryDay:
        CategoryTypeEnum.other_day.rawValue
      }
    }
  }
  
  func category(_ keyEnum: CategoryKeyEnum, order: Int, categoryRepeat: CategoryRepeatEnum, categoryGroup: CategoryGroupEnum) -> DomainContracts.DefaultCategory {
    let defaultKey = keyEnum.key
    let title = defaultKey
    return DomainContracts.DefaultCategory(defaultKey: defaultKey, title: title, order: order, categoryRepeat: categoryRepeat, categoryGroup: categoryGroup)
  }
  
  public func takeDefaultCategories() -> [DomainContracts.DefaultCategory] {
    let categories: [DomainContracts.DefaultCategory] = [
      category(.birthdays, order: 1, categoryRepeat: .repeatEveryYear_notChoose, categoryGroup: .birthdays),
      category(.aniversaries, order: 2, categoryRepeat: .repeatEveryYear_notChoose, categoryGroup: .aniversaries),
      category(.other_repeatEveryYear, order: 3, categoryRepeat: .repeatEveryYear_chooseAll, categoryGroup: .other),
      category(.other_repeatEveryMonth, order: 4, categoryRepeat: .repeatEveryMonth_chooseAll, categoryGroup: .other),
      category(.other_repeatEveryDay, order: 5, categoryRepeat: .repeatEveryDay_chooseAll, categoryGroup: .other),
    ]
    return categories
  }
}
