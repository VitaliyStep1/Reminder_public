//
//  FetchDefaultRemindTimeDateUseCase.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 28.10.2025.
//

import Foundation
import AppServicesContracts
import DomainContracts

public struct FetchDefaultRemindTimeDateUseCase: FetchDefaultRemindTimeDateUseCaseProtocol {
  
  private let defaultRemindTimeService: DefaultRemindTimeServiceProtocol
  
  public init(defaultRemindTimeService: DefaultRemindTimeServiceProtocol) {
    self.defaultRemindTimeService = defaultRemindTimeService
  }
  
  public func execute() -> Date {
    let defaultRemindTimeDate = defaultRemindTimeService.takeDefaultRemindTimeDate()
    
    return defaultRemindTimeDate
  }
}
