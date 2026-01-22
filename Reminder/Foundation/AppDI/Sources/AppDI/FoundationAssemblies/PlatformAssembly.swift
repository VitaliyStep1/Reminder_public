//
//  PlatformAssembly.swift
//  AppDI
//
//  Created by Vitaliy Stepanenko on 24.12.2025.
//

import Swinject
import Platform

struct PlatformAssembly: Assembly {
  func assemble(container: Container) {
    
    container.register(LocalNotificationServiceProtocol.self) { _ in
      LocalNotificationService()
    }
  }
}
