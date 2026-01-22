//
//  SaveEventUseCaseError.swift
//  DomainContracts
//
//  Created by Vitaliy Stepanenko on 01.01.2026.
//

public enum SaveEventUseCaseError: Error {
  case titleShouldBeNotEmpty
  case localNotificationIsNotAllowed
  case localNotificationIsNotAllowedSecondAttempt
  case failedToScheduleNotification
  case eventWasNotSaved
}
