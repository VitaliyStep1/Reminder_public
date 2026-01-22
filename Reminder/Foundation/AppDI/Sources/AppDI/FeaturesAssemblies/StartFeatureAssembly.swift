//
//  StartFeatureAssembly.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 03.12.2025.
//

import SwiftUI
import Swinject
import Start
import MainTabView
import Configurations
import DomainContracts
import Language

@MainActor
struct StartFeatureAssembly: Assembly {
  func assemble(container: Container) {
    container.register(StartScreenViewModel.self) { r in
      let appConfiguration = r.resolve(AppConfigurationProtocol.self)!
      let setupInitialDataUseCase = r.resolve(SetupInitialDataUseCaseProtocol.self)!
      let updateNotificationsUseCase = r.resolve(UpdateNotificationsUseCaseProtocol.self)!

      return StartScreenViewModel(
        appConfiguration: appConfiguration,
        setupInitialDataUseCase: setupInitialDataUseCase,
        updateNotificationsUseCase: updateNotificationsUseCase
      )
    }
    
    container.register(SplashScreenViewFactoryProtocol.self) { _ in
      SplashScreenViewFactory()
    }
    
    container.register(StartCoordinator.self) { r in
      let languageService = r.resolve(LanguageService.self)!
      let startScreenBuilder = r.resolve(StartScreenBuilder.self)!

      return StartCoordinator(startScreenBuilder: startScreenBuilder, languageService: languageService)
    }
    .inObjectScope(.container)

    container.register(StartScreenBuilder.self) { r in
      { splashState, languageService in
        let startScreenViewModel = r.resolve(StartScreenViewModel.self)!
        let splashScreenViewFactory = r.resolve(SplashScreenViewFactoryProtocol.self)!
        let mainCoordinator = r.resolve(MainCoordinator.self)!

        let splashViewBuilder: StartScreenView.ViewBuilder = {
          let binding = Binding(
            get: { splashState.isVisible },
            set: { splashState.isVisible = $0 }
          )
          return splashScreenViewFactory.makeSplashScreen(isVisible: binding)
        }

        return StartScreenView(
          viewModel: startScreenViewModel,
          languageService: languageService,
          splashViewBuilder: splashViewBuilder,
          mainViewBuilder: { [mainCoordinator] in
            mainCoordinator.start()
          }
        )
      }
    }

    container.register(AnyView.self, name: "RootView") { resolver in
      let coordinator = resolver.resolve(StartCoordinator.self)!
      return coordinator.start()
    }
    .inObjectScope(.container)
  }
}
