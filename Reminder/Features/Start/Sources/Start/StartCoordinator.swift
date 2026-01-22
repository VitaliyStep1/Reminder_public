//
//  StartCoordinator.swift
//  StartUI
//
//  Created by OpenAI's ChatGPT.
//

import SwiftUI
import NavigationContracts
import DomainContracts
import Language

@MainActor
public final class StartCoordinator: CoordinatorProtocol {
  let splashState = SplashScreenState()

  private let startScreenBuilder: StartScreenBuilder
  let languageService: LanguageService

  public init(startScreenBuilder: @escaping StartScreenBuilder, languageService: LanguageService) {
    self.startScreenBuilder = startScreenBuilder
    self.languageService = languageService
  }

  public func start() -> AnyView {
    AnyView(
      startScreenBuilder(splashState, languageService)
        .environmentObject(splashState)
    )
  }
}
