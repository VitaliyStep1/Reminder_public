//
//  FetchCategoryUseCaseProtocol.swift
//  DomainContracts
//
//  Created as part of Clean Architecture refactor.
//

import Foundation

public protocol FetchCategoryUseCaseProtocol: Sendable {
  func execute(categoryId: Identifier) async throws -> Category?
}
