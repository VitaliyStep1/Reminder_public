//
//  FetchDefaultRemindTimeDateUseCaseProtocol.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 28.10.2025.
//

import Foundation

public protocol FetchDefaultRemindTimeDateUseCaseProtocol: Sendable {
  func execute() -> Date
}
