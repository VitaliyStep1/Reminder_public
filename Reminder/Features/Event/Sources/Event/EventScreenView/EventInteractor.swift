//
//  EventInteractor.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 20.10.2025.
//

import Foundation
import Combine
import UIKit
import StoreKit
import NavigationContracts
import DomainContracts
import UserDefaultsStorage
import Configurations
import Platform
import AnalyticsContracts

@MainActor
public final class EventInteractor {
  private let createEventUseCase: CreateEventUseCaseProtocol
  private let editEventUseCase: EditEventUseCaseProtocol
  private let deleteEventUseCase: DeleteEventUseCaseProtocol
  private let fetchEventUseCase: FetchEventUseCaseProtocol
  private let fetchCategoryUseCase: FetchCategoryUseCaseProtocol
  private let fetchDefaultRemindTimeDateUseCase: FetchDefaultRemindTimeDateUseCaseProtocol
  private let generateNewRemindsUseCase: GenerateNewRemindsUseCaseProtocol
  private let fetchIsLocalNotificationsPermissionUseCase: FetchIsLocalNotificationsPermissionUseCaseProtocol
  private let requestLocalNotificationsPermissionUseCase: RequestLocalNotificationsPermissionUseCaseProtocol
  private let saveEventUseCase: SaveEventUseCaseProtocol

  private let localNotificationService: LocalNotificationServiceProtocol
  private let userDefaultsService: UserDefaultsServiceProtocol
  private let appConfiguration: AppConfigurationProtocol
  private let analyticsService: AnalyticsServiceProtocol

  private let presenter: EventPresenter
  private let store: EventViewStore
  
  private var cancellables = Set<AnyCancellable>()
  
  private var saveTask: Task<Void, Never>?
  private var deleteTask: Task<Void, Never>?
  private var updateNotificationPermissionTask: Task<Void, any Error>?
  private var requestForNotificationsPermissionTask: Task<Void, any Error>?
  private var hasFetchedNecessaryData = false
  
  public weak var coordinator: (any EventCoordinatorProtocol)?
  
  public init(
    createEventUseCase: CreateEventUseCaseProtocol,
    editEventUseCase: EditEventUseCaseProtocol,
    deleteEventUseCase: DeleteEventUseCaseProtocol,
    fetchEventUseCase: FetchEventUseCaseProtocol,
    fetchCategoryUseCase: FetchCategoryUseCaseProtocol,
    fetchDefaultRemindTimeDateUseCase: FetchDefaultRemindTimeDateUseCaseProtocol,
    generateNewRemindsUseCase: GenerateNewRemindsUseCaseProtocol,
    fetchIsLocalNotificationsPermissionUseCase: FetchIsLocalNotificationsPermissionUseCaseProtocol,
    requestLocalNotificationsPermissionUseCase: RequestLocalNotificationsPermissionUseCaseProtocol,
    saveEventUseCase: SaveEventUseCaseProtocol,
    localNotificationService: LocalNotificationServiceProtocol,
    userDefaultsService: UserDefaultsServiceProtocol,
    appConfiguration: AppConfigurationProtocol,
    analyticsService: AnalyticsServiceProtocol,
    presenter: EventPresenter,
    store: EventViewStore,
    coordinator: (any EventCoordinatorProtocol)
  ) {
    self.createEventUseCase = createEventUseCase
    self.editEventUseCase = editEventUseCase
    self.deleteEventUseCase = deleteEventUseCase
    self.fetchEventUseCase = fetchEventUseCase
    self.fetchCategoryUseCase = fetchCategoryUseCase
    self.fetchDefaultRemindTimeDateUseCase = fetchDefaultRemindTimeDateUseCase
    self.generateNewRemindsUseCase = generateNewRemindsUseCase
    self.fetchIsLocalNotificationsPermissionUseCase = fetchIsLocalNotificationsPermissionUseCase
    self.requestLocalNotificationsPermissionUseCase = requestLocalNotificationsPermissionUseCase
    self.saveEventUseCase = saveEventUseCase
    self.localNotificationService = localNotificationService
    self.userDefaultsService = userDefaultsService
    self.appConfiguration = appConfiguration
    self.analyticsService = analyticsService
    self.presenter = presenter
    self.store = store
    self.coordinator = coordinator

    subscribe()
  }
  
  deinit {
    updateNotificationPermissionTask?.cancel()
  }
  
  func taskWasCalled() async {
    fetchDefaultRemindTimeDateAndUpdate()
    updateNewReminds()
    await fetchNecessaryData()
  }
  
  public func saveButtonTapped() {
    startSaving(isWithoutNotifications: false)
  }
  
  private func startSaving(isWithoutNotifications: Bool) {
    guard saveTask == nil else {
      return
    }
    presenter.presentSaving(true)
    
    saveTask = Task { @MainActor [weak self] in
      guard let self else {
        return
      }
      defer {
        self.presenter.presentSaving(false)
        self.saveTask = nil
      }
      await self.saveEvent(isWithoutNotifications: isWithoutNotifications)
    }
  }
  
  private func saveEvent(isWithoutNotifications: Bool) async {
    do {
      guard let saveEventInfo = makeSaveEventUseCaseInfo() else {
        presenter.presentEventWasNotSavedAlert()
        return
      }

      let newCategoryId = try await saveEventUseCase.execute(
        isWithoutNotifications: isWithoutNotifications,
        info: saveEventInfo
      )
      handleRateRequestOnEventCreated(isCreating: saveEventInfo.isCreating)
      trackEventCreatedIfNeeded(info: saveEventInfo)
      notifyCategoryEventWasUpdated(newCategoryId: newCategoryId)
      closeView()
      
    } catch SaveEventUseCaseError.titleShouldBeNotEmpty {
      presenter.presentEventTitleShouldBeNotEmptyAlert()
    } catch SaveEventUseCaseError.localNotificationIsNotAllowedSecondAttempt {
      presenter.presentNoLocalNotificationPermissionAlert(cancelHandler: {}) {
        self.openSettings()
      } saveWithoutNotificationsHandler: {
        self.startSaving(isWithoutNotifications: true)
      }
    } catch SaveEventUseCaseError.failedToScheduleNotification {
      presenter.presentNotificationsWereNotScheduledAlert(completion: { [weak self] in
        self?.closeView()
      })
    } catch SaveEventUseCaseError.eventWasNotSaved {
      presenter.presentEventWasNotSavedAlert()
    } catch {
      presenter.presentEventWasNotSavedAlert()
    }
    
  }

  private func handleRateRequestOnEventCreated(isCreating: Bool) {
    guard isCreating else { return }

    let createdEventsCount = userDefaultsService.eventCreatedCount + 1
    userDefaultsService.eventCreatedCount = createdEventsCount

    let rateRequestEventCounts = [
      appConfiguration.rateUsAfterEventsCreated1,
      appConfiguration.rateUsAfterEventsCreated2,
      appConfiguration.rateUsAfterEventsCreated3
    ]
    guard rateRequestEventCounts.contains(createdEventsCount),
          userDefaultsService.lastRateRequestEventCount < createdEventsCount else {
      return
    }

    userDefaultsService.lastRateRequestEventCount = createdEventsCount
    requestRateApp()
  }

  private func trackEventCreatedIfNeeded(info: SaveEventUseCaseInfo) {
    guard info.isCreating else { return }

    let eventName: String
    switch info.categoryTypeEnum {
    case .birthdays:
      eventName = "event_created_birthdays"
    case .aniversaries:
      eventName = "event_created_aniversaries"
    case .other_year:
      eventName = "event_created_other_year"
    case .other_month:
      eventName = "event_created_other_month"
    case .other_day:
      eventName = "event_created_other_day"
    }

    var values: [String: Any] = [
      "remind_before_enabled": info.isRemindBeforeActive
    ]
    if info.isRemindBeforeActive {
      values["days_before"] = info.remindBeforeDays
    }

    analyticsService.track(event: eventName, values: values)
  }

  private func trackEventDeleted() {
    let categoryType = store.category?.categoryTypeEnum
      ?? store.detailsSectionData.categoryType
      ?? .other_day

    let eventName: String
    switch categoryType {
    case .birthdays:
      eventName = "event_deleted_birthdays"
    case .aniversaries:
      eventName = "event_deleted_aniversaries"
    case .other_year:
      eventName = "event_deleted_other_year"
    case .other_month:
      eventName = "event_deleted_other_month"
    case .other_day:
      eventName = "event_deleted_other_day"
    }

    analyticsService.track(event: eventName)
  }

  private func requestRateApp() {
    guard let windowScene = UIApplication.shared.connectedScenes
      .compactMap({ $0 as? UIWindowScene })
      .first(where: { $0.activationState == .foregroundActive && $0.windows.contains(where: { $0.isKeyWindow }) }) else {
      openAppStoreReviewPage()
      return
    }

    SKStoreReviewController.requestReview(in: windowScene)
  }

  private func openAppStoreReviewPage() {
    guard let url = URL(string: "https://apps.apple.com/app/id\(appConfiguration.appstoreId)?action=write-review") else {
      return
    }

    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
  
  
  public func cancelButtonTapped() {
    closeView()
  }
  
  public func deleteButtonTapped() {
    presenter.presentDeleteConfirmation { [weak self] in
      self?.deletingEventConfirmed()
    }
  }
  
  public func updateLocale(_ locale: Locale) {
    presenter.updateLocale(locale)
  }
  
  public func allowNotificationsButtonTapped() {
    requestForNotificationsPermission()
  }
  
  private func deletingEventConfirmed() {
    guard deleteTask == nil else {
      return
    }
    
    presenter.presentDeleting(true)
    
    deleteTask = Task {@MainActor [weak self] in
      guard let self else { return }
      
      defer {
        presenter.presentDeleting(false)
        deleteTask = nil
      }
      
      do {
        try await self.performDeleteEvent()
        self.trackEventDeleted()
        self.notifyCategoryEventWasUpdated(newCategoryId: nil)
        
        closeViewAfterDelete()
      } catch {
        presenter.presentDeleteErrorAlert()
      }
    }
  }
  
  private func performDeleteEvent() async throws {
    switch store.eventScreenViewType {
    case .edit(let eventId, _):
      cancelNotifications()
      try await deleteEventUseCase.execute(eventId: eventId)
    case .create, .notVisible:
      break
    }
  }
  
  private func cancelNotifications() {
    var onDayLNEventId = store.onDayLNEventId
    var beforeLNEventId = store.beforeLNEventId
    
    let cancelLNEventsIds: [String] = [onDayLNEventId?.uuidString, beforeLNEventId?.uuidString].compactMap { $0 }
    
    localNotificationService.cancelNotifications(ids: cancelLNEventsIds)
  }
  
  private func fetchNecessaryData() async {
    guard !hasFetchedNecessaryData else { return }
    hasFetchedNecessaryData = true

    var eventId: Identifier?
    var categoryId: Identifier?
    
    switch store.eventScreenViewType {
    case .create(let categoryId_):
      categoryId = categoryId_
    case .edit(let eventId_, _):
      eventId = eventId_
    case .notVisible:
      break
    }
    
    if let eventId {
      let event = await fetchEventAndUpdateOrClose(eventId: eventId)
      if let event, let categoryId_ = event.categoryId {
        categoryId = categoryId_
      }
    }
    
    if let categoryId {
      await fetchCategoryAndUpdateOrClose(categoryId: categoryId)
    }
    updateNewReminds()
  }
  
  private func fetchEventAndUpdateOrClose(eventId: Identifier) async -> Event? {
    do {
      let event = try await fetchEventUseCase.execute(eventId: eventId)
      presenter.presentEvent(event)
      presenter.presentViewBlocked(false)
      return event
    } catch {
      presenter.presentEventWasNotFoundAlert { [weak self] in
        self?.closeView()
      }
      return nil
    }
  }
  
  private func fetchCategoryAndUpdateOrClose(categoryId: Identifier) async -> Void {
    do {
      let category = try await fetchCategoryUseCase.execute(categoryId: categoryId)
      presenter.presentViewBlocked(false)
      if let category {
        presenter.presentCategory(category)
      }
    } catch {
      presenter.presentCategoryWasNotFoundAlert { [weak self] in
        self?.closeView()
      }
      return
    }
  }
  
  private func subscribe() {
    let updates: [AnyPublisher<Void, Never>] = [
      store.detailsSectionData.$eventDate
        .removeDuplicates()
        .map { _ in () }
        .eraseToAnyPublisher(),
      
      store.alertsSectionData.$eventPeriod
        .removeDuplicates()
        .map { _ in () }
        .eraseToAnyPublisher(),
      
      store.alertsSectionData.$isRemindOnDayActive
        .removeDuplicates()
        .map { _ in () }
        .eraseToAnyPublisher(),
      
      store.alertsSectionData.$isRemindBeforeActive
        .removeDuplicates()
        .map { _ in () }
        .eraseToAnyPublisher(),
      
      store.alertsSectionData.$remindOnDayTimeDate
        .removeDuplicates()
        .map { _ in () }
        .eraseToAnyPublisher(),
      
      store.alertsSectionData.$remindBeforeTimeDate
        .removeDuplicates()
        .map { _ in () }
        .eraseToAnyPublisher(),
      
      store.alertsSectionData.$remindBeforeDays
        .removeDuplicates()
        .map { _ in () }
        .eraseToAnyPublisher(),
      
      store.alertsSectionData.$isRemindRepeated
        .removeDuplicates()
        .map { _ in () }
        .eraseToAnyPublisher()
    ]
    
    Publishers.MergeMany(updates)
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
      .sink { [weak self] in
        self?.updateNewReminds()
      }
      .store(in: &cancellables)
  }
  
  private func fetchDefaultRemindTimeDateAndUpdate() {
    let defaultRemindTimeDate = fetchDefaultRemindTimeDateUseCase.execute()
    presenter.presentDefaultRemindTimeDate(defaultRemindTimeDate: defaultRemindTimeDate)
  }
  
  private func notifyCategoryEventWasUpdated(newCategoryId: Identifier?) {
    store.categoryEventWasUpdatedDelegate?.categoryEventWasUpdated(newCategoryId: newCategoryId)
  }
  
  private func closeView() {
//    store.categoryEventWasUpdatedDelegate?.popScreen()
    coordinator?.router.popScreen()
  }

  private func closeViewAfterDelete() {
    switch store.eventScreenViewType {
    case .edit(_, source: .read):
      coordinator?.router.popScreen()
      coordinator?.router.popScreen()
    default:
      closeView()
    }
  }
  
  private func updateNewReminds() {
    let detailsSectionData: EventDetailsSectionData = store.detailsSectionData
    let alertsSectionData: EventAlertsSectionData = store.alertsSectionData
    
    let date = detailsSectionData.eventDate
    let eventPeriod = alertsSectionData.eventPeriod
    let isRemindRepeated = alertsSectionData.isRemindRepeated
    let remindOnDayTimeDate = alertsSectionData.remindOnDayTimeDate
    let isRemindOnDayActive = alertsSectionData.isRemindOnDayActive
    let remindBeforeDays = alertsSectionData.remindBeforeDays
    let remindBeforeTimeDate = alertsSectionData.remindBeforeTimeDate
    let isRemindBeforeActive = alertsSectionData.isRemindBeforeActive
      
    do {
      let (remindOnDayDate, remindBeforeDate) = try generateNewRemindsUseCase.execute(
        date: date,
        eventPeriod: eventPeriod,
        isRemindRepeated: isRemindRepeated,
        remindOnDayTimeDate: remindOnDayTimeDate,
        isRemindOnDayActive: isRemindOnDayActive,
        remindBeforeDays: remindBeforeDays,
        remindBeforeTimeDate: remindBeforeTimeDate,
        isRemindBeforeActive: isRemindBeforeActive
      )
      store.newRemindsSectionData.remindOnDayDate = remindOnDayDate
      store.newRemindsSectionData.remindBeforeDate = remindBeforeDate
    } catch {
      //TODO: Show error that generating reminds failed
    }

    updateNotificationPermissionTask?.cancel()
    updateNotificationPermissionTask = Task { @MainActor in
      do {
        let isLocalNotificationAllowed = await fetchIsLocalNotificationsPermissionUseCase.execute()
        try Task.checkCancellation()
        store.newRemindsSectionData.isNoNotificationPermissionViewVisible = !isLocalNotificationAllowed
      }
      catch is CancellationError {
        
      }
    }
  }
  
  private func requestForNotificationsPermission() {
    if requestForNotificationsPermissionTask != nil {
      return
    }

    requestForNotificationsPermissionTask = Task { [weak self] in
      guard let self else { return }
      defer {
        requestForNotificationsPermissionTask = nil
      }
      
      let result = await self.requestLocalNotificationsPermissionUseCase.execute()
      if result {
        self.updateNewReminds()
      } else {
        self.openSettings()
      }
    }
  }
  
  private func openSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }

  private func makeSaveEventUseCaseInfo() -> SaveEventUseCaseInfo? {
    let detailsSectionData = store.detailsSectionData
    let alertsSectionData = store.alertsSectionData
    let newRemindsSectionData = store.newRemindsSectionData

    let isCreating: Bool
    let categoryId: Identifier
    let eventId: Identifier

    switch store.eventScreenViewType {
    case .create(let id):
      isCreating = true
      categoryId = id
      eventId = UUID()
    case .edit(let id, _):
      guard let category = store.category else {
        return nil
      }
      isCreating = false
      categoryId = category.id
      eventId = id
    case .notVisible:
      return nil
    }
    
    let onDayLNEventId = store.onDayLNEventId ?? UUID()
    let beforeLNEventId = store.beforeLNEventId ?? UUID()
    let categoryType = store.category?.categoryTypeEnum ?? detailsSectionData.categoryType ?? .other_day

    return SaveEventUseCaseInfo(
      isCreating: isCreating,
      categoryId: categoryId,
      eventId: eventId,
      title: detailsSectionData.eventTitle,
      date: detailsSectionData.eventDate,
      comment: detailsSectionData.eventComment,
      eventPeriod: alertsSectionData.eventPeriod,
      categoryTypeEnum: categoryType,
      isRemindRepeated: alertsSectionData.isRemindRepeated,
      remindOnDayTimeDate: alertsSectionData.remindOnDayTimeDate,
      remindOnDayDate: newRemindsSectionData.remindOnDayDate,
      isRemindOnDayActive: alertsSectionData.isRemindOnDayActive,
      remindBeforeDays: alertsSectionData.remindBeforeDays,
      remindBeforeDate: newRemindsSectionData.remindBeforeDate,
      remindBeforeTimeDate: alertsSectionData.remindBeforeTimeDate,
      isRemindBeforeActive: alertsSectionData.isRemindBeforeActive,
      onDayLNEventId: onDayLNEventId,
      beforeLNEventId: beforeLNEventId
    )
  }
}

