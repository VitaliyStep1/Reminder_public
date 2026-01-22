//
//  AnalyticsAssembly.swift
//  AppDI
//
//  Created by Vitaliy Stepanenko on 27.02.2026.
//

import Swinject
import Analytics
import AnalyticsContracts

struct AnalyticsAssembly: Assembly {
  func assemble(container: Container) {
    container.register(AnalyticsServiceProtocol.self) { _ in
      AnalyticsService()
    }
    .inObjectScope(.container)
  }
}
