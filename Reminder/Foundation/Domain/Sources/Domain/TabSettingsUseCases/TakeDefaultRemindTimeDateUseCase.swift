//
//  TakeDefaultRemindTimeDateUseCase.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 24.10.2025.
//

import Foundation
import AppServicesContracts
import DomainContracts
import Configurations
import UserDefaultsStorage

public class TakeDefaultRemindTimeDateUseCase: TakeDefaultRemindTimeDateUseCaseProtocol {
  private let defaultRemindTimeService: DefaultRemindTimeServiceProtocol
  
  public init(defaultRemindTimeService: DefaultRemindTimeServiceProtocol) {
    self.defaultRemindTimeService = defaultRemindTimeService
  }

  public func execute() -> Date {
    let defaultRemindTimeDate = defaultRemindTimeService.takeDefaultRemindTimeDate()
    return defaultRemindTimeDate
  }
}
