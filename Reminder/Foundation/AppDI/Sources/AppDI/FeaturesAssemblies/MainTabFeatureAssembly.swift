//
//  MainTabFeatureAssembly.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 03.12.2025.
//

import Swinject
import MainTabView
import MainTabViewContracts
import Closest
import Categories
import Settings

@MainActor
struct MainTabFeatureAssembly: Assembly {
  func assemble(container: Container) {
    container.register(MainTabViewSelectionState.self) { _ in
      MainTabViewSelectionState(selection: .closest)
    }
    .inObjectScope(.container)

    container.register(MainCoordinator.self) { resolver in
      let selectionState = resolver.resolve(MainTabViewSelectionState.self)!
      let closestCoordinator = resolver.resolve(ClosestCoordinator.self)!
      let createCoordinator = resolver.resolve(CreateCoordinator.self)!
      let settingsCoordinator = resolver.resolve(SettingsCoordinator.self)!

      return MainCoordinator(
        mainTabViewSelectionState: selectionState,
        closestCoordinator: closestCoordinator,
        createCoordinator: createCoordinator,
        settingsCoordinator: settingsCoordinator
      )
    }
    .inObjectScope(.container)
  }
}
