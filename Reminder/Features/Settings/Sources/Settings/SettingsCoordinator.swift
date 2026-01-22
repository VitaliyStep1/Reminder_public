//
//  SettingsCoordinator.swift
//  SettingsTab
//
//  Created by OpenAI's ChatGPT.
//

import SwiftUI
import NavigationContracts

@MainActor
public final class SettingsCoordinator: CoordinatorProtocol {
  private let settingsScreenBuilder: SettingsScreenBuilder

  public init(settingsScreenBuilder: @escaping SettingsScreenBuilder) {
    self.settingsScreenBuilder = settingsScreenBuilder
  }

  public func start() -> AnyView {
    let view = settingsScreenBuilder()
    return AnyView(view)
  }
}
