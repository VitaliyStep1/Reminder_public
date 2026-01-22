//
//  UpdateNotificationsUseCase.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 31.12.2025.
//

import Foundation
import AppServicesContracts
import DomainContracts
import UserDefaultsStorage
//import PersistenceContracts

public struct UpdateNotificationsUseCase: UpdateNotificationsUseCaseProtocol {
  private let updateNotificationsService: UpdateNotificationsServiceProtocol
  private let userDefaultsService: UserDefaultsServiceProtocol

  public init(
    updateNotificationsService: UpdateNotificationsServiceProtocol,
    userDefaultsService: UserDefaultsServiceProtocol
  ) {
    self.updateNotificationsService = updateNotificationsService
    self.userDefaultsService = userDefaultsService
  }

  public func execute() async {
    let now = Date()

    if let lastUpdateDate = userDefaultsService.lastNotificationsUpdateDate,
       Calendar.current.isDate(lastUpdateDate, inSameDayAs: now) {
      return
    }

    try? await updateNotificationsService.updateNotifications()
    userDefaultsService.lastNotificationsUpdateDate = now
  }
}
