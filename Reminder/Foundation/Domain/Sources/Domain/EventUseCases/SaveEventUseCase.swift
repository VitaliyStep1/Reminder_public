//
//  SaveEventUseCase.swift
//  Domain
//
//  Created by Vitaliy Stepanenko on 01.01.2026.
//

import Foundation
import AppServicesContracts
import DomainContracts

public final class SaveEventUseCase: SaveEventUseCaseProtocol {
  private let createEventUseCase: CreateEventUseCaseProtocol
  private let editEventUseCase: EditEventUseCaseProtocol
  private let fetchIsLocalNotificationsPermissionUseCase: FetchIsLocalNotificationsPermissionUseCaseProtocol
  private let requestLocalNotificationsPermissionUseCase: RequestLocalNotificationsPermissionUseCaseProtocol
  private let scheduleNotificationsService: ScheduleNotificationsServiceProtocol

  public init(
    createEventUseCase: CreateEventUseCaseProtocol,
    editEventUseCase: EditEventUseCaseProtocol,
    fetchIsLocalNotificationsPermissionUseCase: FetchIsLocalNotificationsPermissionUseCaseProtocol,
    requestLocalNotificationsPermissionUseCase: RequestLocalNotificationsPermissionUseCaseProtocol,
    scheduleNotificationsService: ScheduleNotificationsServiceProtocol
  ) {
    self.createEventUseCase = createEventUseCase
    self.editEventUseCase = editEventUseCase
    self.fetchIsLocalNotificationsPermissionUseCase = fetchIsLocalNotificationsPermissionUseCase
    self.requestLocalNotificationsPermissionUseCase = requestLocalNotificationsPermissionUseCase
    self.scheduleNotificationsService = scheduleNotificationsService
  }

  public func execute(isWithoutNotifications: Bool, info: SaveEventUseCaseInfo) async throws -> Identifier? {
    try await startSavingAsync(isWithoutNotifications: isWithoutNotifications, info: info)
  }

  private func startSavingAsync(isWithoutNotifications: Bool, isSecondAttempt: Bool = false, info: SaveEventUseCaseInfo) async throws -> Identifier? {
    do {
      return try await saveEvent(isWithoutNotifications: isWithoutNotifications, info: info)
    } catch SaveEventUseCaseError.titleShouldBeNotEmpty {
      throw SaveEventUseCaseError.titleShouldBeNotEmpty
    } catch SaveEventUseCaseError.localNotificationIsNotAllowed {
      let result = await requestLocalNotificationsPermissionUseCase.execute()
      if result && !isSecondAttempt {
        return try await startSavingAsync(isWithoutNotifications: false, isSecondAttempt: true, info: info)
      } else {
        throw SaveEventUseCaseError.localNotificationIsNotAllowedSecondAttempt
      }
    } catch SaveEventUseCaseError.failedToScheduleNotification {
      throw SaveEventUseCaseError.failedToScheduleNotification
    } catch {
      throw SaveEventUseCaseError.eventWasNotSaved
    }
  }

  private func saveEvent(isWithoutNotifications: Bool, info: SaveEventUseCaseInfo) async throws -> Identifier? {
    try validateEventBeforeSaving(info: info)

    if !isWithoutNotifications {
      try await validateLocalNotificationsPermission()
      
      try await scheduleNotificationsService.scheduleAlerts(
        eventTitle: info.title,
        eventPeriod: info.eventPeriod,
        remindOnDayDate: info.remindOnDayDate,
        remindBeforeDate: info.remindBeforeDate,
        onDayLNEventId: info.onDayLNEventId,
        beforeLNEventId: info.beforeLNEventId,
        remindBeforeDays: info.remindBeforeDays,
        categoryTypeEnum: info.categoryTypeEnum
      )
    }

    let newCategoryId: Identifier?
    if info.isCreating {
      let eventId = UUID()
      newCategoryId = try await createEvent(eventId: eventId, info: info, onDayLNEventId: info.onDayLNEventId, beforeLNEventId: info.beforeLNEventId)
    } else {
      newCategoryId = try await editEvent(info: info, onDayLNEventId: info.onDayLNEventId, beforeLNEventId: info.beforeLNEventId)
    }
    return newCategoryId
  }

  private func validateEventBeforeSaving(info: SaveEventUseCaseInfo) throws {
    guard !info.title.isEmpty else {
      throw SaveEventUseCaseError.titleShouldBeNotEmpty
    }
  }

  private func validateLocalNotificationsPermission() async throws {
    let isLocalNotificationAllowed = await fetchIsLocalNotificationsPermissionUseCase.execute()
    guard isLocalNotificationAllowed else {
      throw SaveEventUseCaseError.localNotificationIsNotAllowed
    }
  }

  private func createEvent(eventId: UUID, info: SaveEventUseCaseInfo, onDayLNEventId: UUID, beforeLNEventId: UUID) async throws -> Identifier? {
    try await createEventUseCase.execute(
      categoryId: info.categoryId,
      eventId: eventId,
      title: info.title,
      date: info.date,
      comment: info.comment,
      eventPeriod: info.eventPeriod,
      isRemindRepeated: info.isRemindRepeated,
      remindOnDayTimeDate: info.remindOnDayTimeDate,
      remindOnDayDate: info.remindOnDayDate,
      isRemindOnDayActive: info.isRemindOnDayActive,
      remindBeforeDays: info.remindBeforeDays,
      remindBeforeDate: info.remindBeforeDate,
      remindBeforeTimeDate: info.remindBeforeTimeDate,
      isRemindBeforeActive: info.isRemindBeforeActive,
      onDayLNEventId: onDayLNEventId,
      beforeLNEventId: beforeLNEventId
    )
  }

  private func editEvent(info: SaveEventUseCaseInfo, onDayLNEventId: UUID, beforeLNEventId: UUID) async throws -> Identifier? {
    try await editEventUseCase.execute(
      eventId: info.eventId,
      title: info.title,
      date: info.date,
      comment: info.comment,
      eventPeriod: info.eventPeriod,
      isRemindRepeated: info.isRemindRepeated,
      remindOnDayTimeDate: info.remindOnDayTimeDate,
      remindOnDayDate: info.remindOnDayDate,
      isRemindOnDayActive: info.isRemindOnDayActive,
      remindBeforeDays: info.remindBeforeDays,
      remindBeforeDate: info.remindBeforeDate,
      remindBeforeTimeDate: info.remindBeforeTimeDate,
      isRemindBeforeActive: info.isRemindBeforeActive,
      onDayLNEventId: onDayLNEventId,
      beforeLNEventId: beforeLNEventId
    )
  }
}
