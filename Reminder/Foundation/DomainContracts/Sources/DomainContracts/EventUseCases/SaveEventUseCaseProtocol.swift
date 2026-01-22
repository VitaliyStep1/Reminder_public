//
//  SaveEventUseCaseProtocol.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 01.01.2026.
//

public protocol SaveEventUseCaseProtocol {
  func execute(isWithoutNotifications: Bool, info: SaveEventUseCaseInfo) async throws -> Identifier?
}
