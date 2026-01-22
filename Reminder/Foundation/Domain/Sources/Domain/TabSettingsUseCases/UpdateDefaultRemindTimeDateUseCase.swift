//
//  UpdateDefaultRemindTimeDateUseCase.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 24.10.2025.
//

import Foundation
import DomainContracts
import UserDefaultsStorage

public class UpdateDefaultRemindTimeDateUseCase: UpdateDefaultRemindTimeDateUseCaseProtocol {
  private var userDefaultsService: UserDefaultsServiceProtocol

  public init(userDefaultsService: UserDefaultsServiceProtocol) {
    self.userDefaultsService = userDefaultsService
  }

  public func execute(date: Date) -> Void {
    userDefaultsService.defaultRemindTimeDate = date
  }
}
