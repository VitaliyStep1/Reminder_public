//
//  FetchAllCategoriesUseCaseProtocol.swift
//  DomainContracts
//
//  Created as part of Clean Architecture refactor.
//

import Foundation

public protocol FetchAllCategoriesUseCaseProtocol: Sendable {
  func execute() async throws -> [Category]
}
