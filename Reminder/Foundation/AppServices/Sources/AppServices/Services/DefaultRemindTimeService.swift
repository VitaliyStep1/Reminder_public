//
//  DefaultRemindTimeService.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 25.10.2025.
//

import Foundation
import AppServicesContracts
import Configurations
import UserDefaultsStorage


public final class DefaultRemindTimeService: DefaultRemindTimeServiceProtocol {
  private let appConfiguration: AppConfigurationProtocol
  private let userDefaultsService: UserDefaultsServiceProtocol
  
  required public init(appConfiguration: AppConfigurationProtocol, userDefaultsService: UserDefaultsServiceProtocol) {
    self.appConfiguration = appConfiguration
    self.userDefaultsService = userDefaultsService
  }
  
  public func takeDefaultRemindTimeDate() -> Date {
    if let savedDate = userDefaultsService.defaultRemindTimeDate {
      return savedDate
    }
    
    let defaultTime = appConfiguration.defaultDefaultRemindTime
    var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    components.hour = defaultTime.hour
    components.minute = defaultTime.minute
    components.second = defaultTime.second
    components.nanosecond = 0
    
    return Calendar.current.date(from: components) ?? Date()
  }
}
