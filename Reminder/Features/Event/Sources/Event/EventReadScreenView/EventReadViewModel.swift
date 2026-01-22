//
//  EventReadViewModel.swift
//  Event
//
//  Created by OpenAI Assistant on 2024-06-11.
//

import Foundation
import DomainContracts

@MainActor
public final class EventReadViewModel: ObservableObject {
  public struct EventDetails {
    let title: String
    let date: Date
    let comment: String
    let categoryTitle: String?
    let categoryType: CategoryTypeEnum?
    let remindOnDayDate: Date?
    let remindBeforeDate: Date?
    let isRemindOnDayScheduled: Bool
    let isRemindBeforeScheduled: Bool
    let isNotificationsPermissionGranted: Bool
  }

  public enum ScreenState {
    case loading
    case content(EventDetails)
    case error(String)
  }

  @Published public var screenState: ScreenState

  private let eventId: Identifier
  private let fetchEventUseCase: FetchEventUseCaseProtocol
  private let fetchCategoryUseCase: FetchCategoryUseCaseProtocol
  private let generateNewRemindsUseCase: GenerateNewRemindsUseCaseProtocol
  private let fetchIsLocalNotificationsPermissionUseCase: FetchIsLocalNotificationsPermissionUseCaseProtocol
  private let fetchScheduledNotificationsIdsUseCase: FetchScheduledNotificationsIdsUseCaseProtocol
  private var isLoading: Bool
  
  public weak var coordinator: (any EventCoordinatorProtocol)?

  public init(eventId: Identifier,
              fetchEventUseCase: FetchEventUseCaseProtocol,
              fetchCategoryUseCase: FetchCategoryUseCaseProtocol,
              generateNewRemindsUseCase: GenerateNewRemindsUseCaseProtocol,
              fetchIsLocalNotificationsPermissionUseCase: FetchIsLocalNotificationsPermissionUseCaseProtocol,
              fetchScheduledNotificationsIdsUseCase: FetchScheduledNotificationsIdsUseCaseProtocol,
              coordinator: (any EventCoordinatorProtocol)) {
    self.eventId = eventId
    self.fetchEventUseCase = fetchEventUseCase
    self.fetchCategoryUseCase = fetchCategoryUseCase
    self.generateNewRemindsUseCase = generateNewRemindsUseCase
    self.fetchIsLocalNotificationsPermissionUseCase = fetchIsLocalNotificationsPermissionUseCase
    self.fetchScheduledNotificationsIdsUseCase = fetchScheduledNotificationsIdsUseCase
    self.coordinator = coordinator

    screenState = .loading
    isLoading = false
  }

  public func taskWasCalled() async {
    await loadScreenData()
  }

  public func editButtonTapped() {
    coordinator?.editEventButtonWasClicked(eventId: eventId, source: .read)
  }

  private func loadScreenData() async {
    guard !isLoading else { return }
    isLoading = true
    defer { isLoading = false }
    screenState = .loading

    do {
      let event = try await fetchEventUseCase.execute(eventId: eventId)
      let category = await fetchCategory(for: event)
      let categoryTitle = category?.title
      let categoryType = category?.categoryTypeEnum
      let scheduledNotificationsIds = Set(await fetchScheduledNotificationsIdsUseCase.execute())
      let reminders = generateNewRemindsUseCase.execute(
        date: event.date,
        eventPeriod: event.eventPeriod,
        isRemindRepeated: event.isRemindRepeated,
        remindOnDayTimeDate: event.remindOnDayTimeDate,
        isRemindOnDayActive: event.isRemindOnDayActive,
        remindBeforeDays: event.remindBeforeDays,
        remindBeforeTimeDate: event.remindBeforeTimeDate,
        isRemindBeforeActive: event.isRemindBeforeActive
      )
      let isNotificationsPermissionGranted = await fetchIsLocalNotificationsPermissionUseCase.execute()
      let isRemindOnDayScheduled = scheduledNotificationsIds.contains(event.onDayLNEventId)
      let isRemindBeforeScheduled = scheduledNotificationsIds.contains(event.beforeLNEventId)
      screenState = .content(
        EventDetails(
          title: event.title,
          date: event.date,
          comment: event.comment,
          categoryTitle: categoryTitle,
          categoryType: categoryType,
          remindOnDayDate: reminders.remindOnDayDate,
          remindBeforeDate: reminders.remindBeforeDate,
          isRemindOnDayScheduled: isRemindOnDayScheduled,
          isRemindBeforeScheduled: isRemindBeforeScheduled,
          isNotificationsPermissionGranted: isNotificationsPermissionGranted
        )
      )
    } catch {
      screenState = .error(error.localizedDescription)
    }
  }

  private func fetchCategory(for event: Event) async -> DomainContracts.Category? {
    guard let categoryId = event.categoryId else { return nil }

    do {
      return try await fetchCategoryUseCase.execute(categoryId: categoryId)
    } catch {
      return nil
    }
  }
}
