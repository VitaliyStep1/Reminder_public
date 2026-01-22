//
//  PersistenceAssembly.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 03.12.2025.
//

import CoreData
import Swinject
import Persistence
import PersistenceContracts

struct PersistenceAssembly: Assembly {
  func assemble(container: Container) {
    container.register(PersistenceContainerServiceProtocol.self) { _ in
      PersistenceContainerService()
    }
    .inObjectScope(.container)

    container.register(NSPersistentContainer.self) { r in
      let service = r.resolve(PersistenceContainerServiceProtocol.self)!
      return service.createPersistentContainer(inMemory: false)
    }
    .inObjectScope(.container)

    container.register(DBCategoriesServiceProtocol.self) { r in
      let persistentContainer = r.resolve(NSPersistentContainer.self)!
      return DBCategoriesService(container: persistentContainer)
    }
    .inObjectScope(.container)

    container.register(DBEventsServiceProtocol.self) { r in
      let persistentContainer = r.resolve(NSPersistentContainer.self)!
      return DBEventsService(container: persistentContainer)
    }
    .inObjectScope(.container)
  }
}
