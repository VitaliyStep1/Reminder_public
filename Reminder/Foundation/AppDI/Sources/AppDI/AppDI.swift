//
//  AppDI.swift
//  AppDI
//
//  Created by Vitaliy Stepanenko on 03.12.2025.
//

import Swinject
import SwiftUI
import Domain
import Persistence
import Start

@MainActor
public final class AppDI {
  public static let shared = AppDI()
  
  public let container: Container
  public let assembler: Assembler
  
  private init() {
    container = Container()
    assembler = Assembler(
      [
        ConfigurationsAssembly(),
        PersistenceAssembly(),
        DomainAssembly(),
        AppServicesAssembly(),
        AnalyticsAssembly(),
        PlatformAssembly(),
        UserDefaultsAssembly(),
        StartFeatureAssembly(),
        ClosestFeatureAssembly(),
        CreateFeatureAssembly(),
        EventFeatureAssembly(),
        SettingsFeatureAssembly(),
        MainTabFeatureAssembly(),
        LanguageAssembly(),
      ],
      container: container
    )
  }
  
  public func makeRootView() -> some View {
    guard let rootView = container.resolve(AnyView.self, name: "RootView") else {
      fatalError("RootView is not registered in DI")
    }
    return rootView
  }
}
