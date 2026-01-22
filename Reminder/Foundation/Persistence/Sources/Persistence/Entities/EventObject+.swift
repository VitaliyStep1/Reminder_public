//
//  EventObject+.swift
//  Persistence
//
//  Created by Vitaliy Stepanenko on 08.10.2025.
//

import CoreData

public class EventObject: NSManagedObject {}

extension EventObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<EventObject> {
    NSFetchRequest<EventObject>(entityName: "EventObject")
  }
  
  @NSManaged public var identifier: UUID
  @NSManaged public var title: String?
  @NSManaged public var date: Date?
  @NSManaged public var comment: String?
  @NSManaged public var eventPeriod: Int16
  @NSManaged public var isRemindRepeated: Bool
  @NSManaged public var remindOnDayTimeDate: Date
  @NSManaged public var remindOnDayDate: Date?
  @NSManaged public var isRemindOnDayActive: Bool
  @NSManaged public var remindBeforeDays: Int16
  @NSManaged public var remindBeforeDate: Date?
  @NSManaged public var remindBeforeTimeDate: Date
  @NSManaged public var isRemindBeforeActive: Bool
  @NSManaged public var onDayLNEventId: UUID
  @NSManaged public var beforeLNEventId: UUID
  @NSManaged public var category: CategoryObject?
}
