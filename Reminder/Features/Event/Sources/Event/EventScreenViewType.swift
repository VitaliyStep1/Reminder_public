//
//  EventScreenViewType.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 25.09.2025.
//

import DomainContracts

public enum EventScreenViewSource: Equatable, Hashable {
  case direct
  case read
}

public enum EventScreenViewType: Equatable, Hashable {
  case create(categoryId: Identifier)
  case edit(eventId: Identifier, source: EventScreenViewSource)
  case notVisible
}
