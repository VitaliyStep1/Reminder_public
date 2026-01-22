//
//  NewRemind.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 16.12.2025.
//

import Foundation

public struct NewRemind {
  public init(date: Date) {
    self.date = date
  }
  
  public let date: Date
}
