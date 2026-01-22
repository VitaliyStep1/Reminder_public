//
//  DefaultRemindTimeServiceProtocol.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 26.10.2025.
//

import Foundation
import Configurations
import UserDefaultsStorage

public protocol DefaultRemindTimeServiceProtocol: Sendable {
  init(appConfiguration: AppConfigurationProtocol, userDefaultsService: UserDefaultsServiceProtocol)
  
  func takeDefaultRemindTimeDate() -> Date
}
