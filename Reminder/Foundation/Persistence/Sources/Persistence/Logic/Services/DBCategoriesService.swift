//
//  DBCategoriesService.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 24.08.2025.
//

import CoreData
import PersistenceContracts

public final class DBCategoriesService: DBCategoriesServiceProtocol, Sendable {
  private let container: NSPersistentContainer
  private var context: NSManagedObjectContext {
    container.viewContext
  }
  
  public init(container: NSPersistentContainer) {
    self.container = container
  }
  
  public func addOrUpdate(defaultCategories categories: [PersistenceContracts.DefaultCategory]) async throws {
    guard !categories.isEmpty else {
      return
    }
    
    try await container.performBackgroundTask { context in
      let categoryDefaultKeys = categories.map(\.defaultKey)
      let addedDefaultKeys = try self.fetchAddedCategoryDefaultKeys(defaultKeys: categoryDefaultKeys, context: context)
      
      for category in categories {
        if addedDefaultKeys.contains(category.defaultKey) {
          let fetchRequest = CategoryObject.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "defaultKey == %@", category.defaultKey)
          fetchRequest.fetchLimit = 1
          if let categoryObject = try context.fetch(fetchRequest).first {
//            categoryObject.title = category.title
//            categoryObject.order = Int32(category.order)
//            categoryObject.categoryRepeat = Int16(category.categoryRepeat)
//            categoryObject.categoryGroup = Int16(category.categoryGroup)
          }
        } else {
          let categoryObject = CategoryObject(context: context)
          categoryObject.identifier = UUID()
          categoryObject.defaultKey = category.defaultKey
          categoryObject.title = category.title
          categoryObject.order = Int32(category.order)
          categoryObject.isUserCreated = category.isUserCreated
          categoryObject.categoryRepeat = Int16(category.categoryRepeat)
          categoryObject.categoryGroup = Int16(category.categoryGroup)
        }
      }
      
      if context.hasChanges {
        try context.save()
      }
    }
  }
  
  public func fetchAllCategories() async throws -> [PersistenceContracts.Category] {
    try await container.performBackgroundTask { context in
      let request = NSFetchRequest<CategoryObject>(entityName: "CategoryObject")
      request.sortDescriptors = [
        NSSortDescriptor(key: "order", ascending: true),
        NSSortDescriptor(key: "title", ascending: true)
      ]
      request.fetchBatchSize = 64
      request.returnsObjectsAsFaults = false

      let rows = try context.fetch(request)

      return try rows.map { try self.mapCategoryObjectToCategory($0, context: context) }
    }
  }

  public func fetchAllCategoriesWithCategoryGroup(categoryGroup: Int) async throws -> [PersistenceContracts.CategoryWithoutEventsAmount] {
    try await container.performBackgroundTask { context in
      let request = NSFetchRequest<CategoryObject>(entityName: "CategoryObject")
      request.predicate = NSPredicate(format: "categoryGroup == %d", categoryGroup)
      request.returnsObjectsAsFaults = false

      let rows = try context.fetch(request)

      return try rows.map { categoryObject in
        CategoryWithoutEventsAmount(
          id: categoryObject.identifier,
          defaultKey: categoryObject.defaultKey ?? "",
          title: categoryObject.title ?? "",
          order: Int(categoryObject.order),
          isUserCreated: categoryObject.isUserCreated,
          categoryRepeat: Int(categoryObject.categoryRepeat),
          categoryGroup: Int(categoryObject.categoryGroup)
        )
      }
    }
  }
  
  private func fetchAddedCategoryDefaultKeys(defaultKeys: [String], context: NSManagedObjectContext) throws -> Set<String> {
    guard !defaultKeys.isEmpty else {
      return []
    }
    let request = NSFetchRequest<NSDictionary>(entityName: "CategoryObject")
    request.resultType = .dictionaryResultType
    request.propertiesToFetch = ["defaultKey"]
    request.predicate = NSPredicate(format: "defaultKey IN %@", defaultKeys)
    let rows = try context.fetch(request)
    return Set(rows.compactMap { $0["defaultKey"] as? String })
  }
  
  //For #Preview
  public func takeFirstCategoryIdentifier() async throws -> ObjectId? {
    try await container.performBackgroundTask { context in
      let request: NSFetchRequest<CategoryObject> = CategoryObject.fetchRequest()
      request.fetchLimit = 1
      request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
      return try context.fetch(request).first?.identifier
    }
  }
  
  public func fetchCategory(categoryId: ObjectId) async throws -> PersistenceContracts.Category? {
    try await container.performBackgroundTask { context in

      guard let categoryObject = try self.fetchCategoryObject(with: categoryId, context: context) else {
        return nil
      }

      return try self.mapCategoryObjectToCategory(categoryObject, context: context)
    }
  }

  private func fetchCategoryObject(with id: UUID, context: NSManagedObjectContext) throws -> CategoryObject? {
    let request: NSFetchRequest<CategoryObject> = CategoryObject.fetchRequest()
    request.predicate = NSPredicate(format: "identifier == %@", id as CVarArg)
    request.fetchLimit = 1
    return try context.fetch(request).first
  }

  private func mapCategoryObjectToCategory(_ categoryObject: CategoryObject, context: NSManagedObjectContext) throws -> PersistenceContracts.Category {
    let request: NSFetchRequest<EventObject> = EventObject.fetchRequest()
    request.predicate = NSPredicate(format: "category == %@", categoryObject)
    request.includesSubentities = false
    let eventCount = try context.count(for: request)

    return Category(
      id: categoryObject.identifier,
      defaultKey: categoryObject.defaultKey ?? "",
      title: categoryObject.title ?? "",
      order: Int(categoryObject.order),
      isUserCreated: categoryObject.isUserCreated,
      eventsAmount: eventCount,
      categoryRepeat: Int(categoryObject.categoryRepeat),
      categoryGroup: Int(categoryObject.categoryGroup)
    )
  }
}
