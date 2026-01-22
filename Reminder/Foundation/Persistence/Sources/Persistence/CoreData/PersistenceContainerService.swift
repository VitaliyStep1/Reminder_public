//
//  PersistenceContainerService.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 15.09.2025.
//

import CoreData

public final class PersistenceContainerService: PersistenceContainerServiceProtocol {
  
  public init() { }
  
  public func createPersistentContainer(inMemory: Bool = false) -> NSPersistentContainer {
    guard let url = Bundle.module.url(forResource: "Model", withExtension: "momd"),
          let model = NSManagedObjectModel(contentsOf: url) else {
      fatalError("Could not load Model.momd from Bundle.module")
    }
    
    func normalizeClassNames(in model: NSManagedObjectModel) {
      let classMap: [String: NSManagedObject.Type] = [
        "CategoryObject": CategoryObject.self,
        "EventObject": EventObject.self,
      ]
      for (name, cls) in classMap {
        if let e = model.entitiesByName[name] {
          e.managedObjectClassName = NSStringFromClass(cls)
        }
      }
    }
    normalizeClassNames(in: model)
    
    let container = NSPersistentContainer(name: "Model", managedObjectModel: model)
    
    if inMemory {
      let desc = NSPersistentStoreDescription()
      desc.type = NSInMemoryStoreType
      container.persistentStoreDescriptions = [desc]
    }
    
    container.loadPersistentStores { _, error in
      if let error = error { fatalError("loadPersistentStores: \(error)") }
    }
    
    container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    container.viewContext.automaticallyMergesChangesFromParent = true
    
#if DEBUG
    print("===== Entities in model (after normalize) =====")
    for e in model.entities {
      print("- \(e.name ?? "<no name>")  class=\(e.managedObjectClassName as Any)")
    }
    print("Swift runtime names:",
          NSStringFromClass(CategoryObject.self),
          NSStringFromClass(EventObject.self))
#endif
    
    return container
  }
}
