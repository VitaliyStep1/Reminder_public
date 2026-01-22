//
//  MainTabView.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 23.08.2025.
//

import SwiftUI
import NavigationContracts
import MainTabViewContracts

public struct MainTabView: View {
  private let closestCoordinator: any CoordinatorProtocol
  private let createCoordinator: any CoordinatorProtocol
  private let settingsCoordinator: any CoordinatorProtocol
  @EnvironmentObject var mainTabViewSelectionState: MainTabViewSelectionState

  public init(
    closestCoordinator: any CoordinatorProtocol,
    createCoordinator: any CoordinatorProtocol,
    settingsCoordinator: any CoordinatorProtocol
  ) {
    self.closestCoordinator = closestCoordinator
    self.createCoordinator = createCoordinator
    self.settingsCoordinator = settingsCoordinator
  }

  public var body: some View {
    TabView(selection: $mainTabViewSelectionState.selection) {
      closestCoordinator.start()
        .tabItem {
          Image(systemName: "calendar.badge.clock")
          Text(Localize.closestTabTitle)
        }
        .tag(MainTabViewSelectionEnum.closest)
      createCoordinator.start()
        .tabItem {
          Image(systemName: "plus.circle")
          Text(Localize.createTabTitle)
        }
        .tag(MainTabViewSelectionEnum.create)
      settingsCoordinator.start()
        .tabItem {
          Image(systemName: "gearshape")
          Text(Localize.settingsTabTitle)
        }
        .tag(MainTabViewSelectionEnum.settings)
    }
  }
}
