//
//  FutureEvent.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 22.12.2025.
//

import Foundation

public struct FutureEvent {
  public let originalEvent: Event
  public let future1Date: Date
  public let future2Date: Date
  
  public init(originalEvent: Event, future1Date: Date, future2Date: Date) {
    self.originalEvent = originalEvent
    self.future1Date = future1Date
    self.future2Date = future2Date
  }
}
