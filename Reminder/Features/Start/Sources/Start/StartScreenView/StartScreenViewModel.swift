//
//  StartScreenViewModel.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 10.09.2025.
//

import Combine
import Configurations
import DomainContracts

@MainActor
public class StartScreenViewModel: ObservableObject {
  let appConfiguration: AppConfigurationProtocol
  let setupInitialDataUseCase: SetupInitialDataUseCaseProtocol
  let updateNotificationsUseCase: UpdateNotificationsUseCaseProtocol

  public init(
    appConfiguration: AppConfigurationProtocol,
    setupInitialDataUseCase: SetupInitialDataUseCaseProtocol,
    updateNotificationsUseCase: UpdateNotificationsUseCaseProtocol
  ) {
    self.appConfiguration = appConfiguration
    self.setupInitialDataUseCase = setupInitialDataUseCase
    self.updateNotificationsUseCase = updateNotificationsUseCase
  }

  func viewTaskCalled() async {
    await setupInitialDataUseCase.execute()
    await updateNotificationsUseCase.execute()
  }
}
