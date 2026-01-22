//
//  PersistenceContainerServiceProtocol.swift
//  PersistenceContracts
//
//  Created by Vitaliy Stepanenko on 15.10.2025.
//

import CoreData

public protocol PersistenceContainerServiceProtocol {
  func createPersistentContainer(inMemory: Bool) -> NSPersistentContainer
}
