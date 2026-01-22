//
//  EventPresenter.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 20.10.2025.
//

import Foundation
import Combine
import NavigationContracts
import DomainContracts

@MainActor
public final class EventPresenter {
  private let store: EventViewStore
  private var locale: Locale = .current
  private var cancellables = Set<AnyCancellable>()
  
  public init(store: EventViewStore) {
    self.store = store
    configureBindings()
    configureView()
  }
  
  public func updateLocale(_ locale: Locale) {
    self.locale = locale
    store.updateLocale(locale)
    configureView()
    updateRepeatRepresentationIfNeeded(for: store.alertsSectionData.eventPeriod)
  }
  
  public func presentSaving(_ isSaving: Bool) {
    store.buttonsData.isSaving = isSaving
  }
  
  public func presentDeleting(_ isDeleting: Bool) {
    store.buttonsData.isDeleting = isDeleting
  }
  
  public func presentViewBlocked(_ isBlocked: Bool) {
    store.isViewBlocked = isBlocked
  }
  
  public func presentDeleteConfirmation(deleteHandler: @escaping () -> Void) {
    store.confirmationDialogInfo = DeleteConfirmationDialogInfo(
      title: String(localized: Localize.deleteEventTitle.localed(locale)),
      message: String(localized: Localize.deleteEventMessage.localed(locale)),
      deleteButtonHandler: deleteHandler
    )
    store.isConfirmationDialogVisible = true
  }
  
  public func presentEvent(_ event: Event) {
    store.detailsSectionData.eventTitle = event.title
    store.detailsSectionData.eventDate = event.date
    store.detailsSectionData.eventComment = event.comment
    store.alertsSectionData.eventPeriod = event.eventPeriod
    store.alertsSectionData.isRemindRepeated = event.isRemindRepeated
    store.alertsSectionData.remindOnDayTimeDate = event.remindOnDayTimeDate
    store.alertsSectionData.isRemindOnDayActive = event.isRemindOnDayActive
    store.alertsSectionData.remindBeforeDays = event.remindBeforeDays
    store.alertsSectionData.remindBeforeTimeDate = event.remindBeforeTimeDate
    store.alertsSectionData.isRemindBeforeActive = event.isRemindBeforeActive
    store.onDayLNEventId = event.onDayLNEventId
    store.beforeLNEventId = event.beforeLNEventId
  }
  
  public func presentCategory(_ category: DomainContracts.Category) {
    store.category = category
    store.detailsSectionData.categoryType = category.categoryTypeEnum

//    let options = category.categoryRepeat.chooseOptions
//    if options.isEmpty {
      let eventPeriodText = eventPeriodTitle(for: store.alertsSectionData.eventPeriod)
      store.alertsSectionData.repeatRepresentationEnum = .text(text: eventPeriodText)
//    } else {
//      let eventPeriodValues = options
//      let eventPeriodTitles = Dictionary(uniqueKeysWithValues: eventPeriodValues.map { ($0, eventPeriodTitle(for: $0)) })
//      store.alertsSectionData.repeatRepresentationEnum = .picker(values: eventPeriodValues, titles: eventPeriodTitles)
//    }
    
    if case .create = store.eventScreenViewType {
      store.alertsSectionData.eventPeriod = category.categoryRepeat.defaultEventPeriod
    }
    
//    if let firstOption = options.first, !options.contains(store.alertsSectionData.eventPeriod) {
//      store.alertsSectionData.eventPeriod = firstOption
//    }

    configureView()
  }
  
  public func presentEventTitleShouldBeNotEmptyAlert() {
    presentAlert(message: String(localized: Localize.eventTitleEmptyAlert.localed(locale)))
  }
  
  public func presentEventWasNotSavedAlert() {
    presentAlert(message: String(localized: Localize.eventNotSavedAlert.localed(locale)))
  }
  
  public func presentNotificationsWereNotScheduledAlert(completion: @escaping () -> Void) {
   presentAlert(message: String(localized: Localize.notificationsWereNotScheduled.localed(locale))) {
     completion()
    }
  }
  
  public func presentNoLocalNotificationPermissionAlert(cancelHandler: @escaping () -> Void, openSettingsHandler: @escaping () -> Void, saveWithoutNotificationsHandler: @escaping () -> Void) {
    presentNotificationsPermissionAlert(title: "Error", message: "Notifications can't scheduled because application does not have permission to send Local Notifications"/*String(localized: Localize.eventNotSavedAlert.localed(locale))*/, cancelTitle: "Cancel", openSettingsTitle: "Open Settings", saveWithoutNotificationsTitle: "Save without notifications", cancelHandler: cancelHandler, openSettingsHandler: openSettingsHandler, saveWithoutNotificationsHandler: saveWithoutNotificationsHandler)
  }

  public func presentDeleteErrorAlert() {
    presentAlert(message: String(localized: Localize.eventDeleteFailedAlert.localed(locale)))
  }

  public func presentEventWasNotFoundAlert(completion: @escaping (() -> Void)) {
    presentViewBlocked(true)
    presentAlert(message: String(localized: Localize.eventNotFoundAlert.localed(locale)), completion: completion)
  }

  public func presentCategoryWasNotFoundAlert(completion: @escaping (() -> Void)) {
    presentViewBlocked(true)
    presentAlert(message: String(localized: Localize.categoryNotFoundAlert.localed(locale)), completion: completion)
  }
  
  public func presentAlert(message: String, completion: (() -> Void)? = nil) {
    store.alertInfo = ErrorAlertInfo(message: message, completion: completion)
    store.isAlertVisible = true
  }
  
  private func presentNotificationsPermissionAlert(title: String, message: String, cancelTitle: String, openSettingsTitle: String, saveWithoutNotificationsTitle: String, cancelHandler: @escaping () -> Void, openSettingsHandler: @escaping () -> Void, saveWithoutNotificationsHandler: @escaping () -> Void) {
    store.permissionAlertInfo = ErrorNotificationsPermissionAlertInfo(title: title, message: message, cancelTitle: cancelTitle, openSettingsTitle: openSettingsTitle, saveWithoutNotificationsTitle: saveWithoutNotificationsTitle, cancelHandler: cancelHandler, openSettingsHandler: openSettingsHandler, saveWithoutNotificationsHandler: saveWithoutNotificationsHandler)
    store.isPermissionAlertVisible = true
  }

  public func presentDefaultRemindTimeDate(defaultRemindTimeDate: Date) {
    store.alertsSectionData.defaultRemindTimeDate = defaultRemindTimeDate
    store.alertsSectionData.remindOnDayTimeDate = defaultRemindTimeDate
    store.alertsSectionData.remindBeforeTimeDate = defaultRemindTimeDate
  }
  
  private func configureView() {
    store.screenTitleData.screenTitle = screenTitle(
      for: store.eventScreenViewType,
      categoryType: store.category?.categoryTypeEnum ?? store.detailsSectionData.categoryType
    )

    switch store.eventScreenViewType {
    case .create:
      store.buttonsData.isDeleteButtonVisible = false
      store.buttonsData.saveButtonTitle = String(localized: Localize.createEventButtonTitle.localed(locale))
    case .edit(_, _):
      store.buttonsData.isDeleteButtonVisible = true
      store.buttonsData.saveButtonTitle = String(localized: Localize.saveEventButtonTitle.localed(locale))
      store.buttonsData.deleteButtonTitle = String(localized: Localize.deleteButtonTitle.localed(locale))
    case .notVisible:
      store.screenTitleData.screenTitle = ""
      store.buttonsData.isDeleteButtonVisible = false
      store.buttonsData.saveButtonTitle = ""
    }

    store.buttonsData.cancelButtonTitle = String(localized: Localize.cancelTitle.localed(locale))
  }

  private func screenTitle(for eventScreenViewType: EventScreenViewType,
                           categoryType: CategoryTypeEnum?) -> LocalizedStringResource {
    switch eventScreenViewType {
    case .create:
      return createScreenTitle(for: categoryType)
    case .edit(_, _):
      return editScreenTitle(for: categoryType)
    case .notVisible:
      return ""
    }
  }

  private func createScreenTitle(for categoryType: CategoryTypeEnum?) -> LocalizedStringResource {
    switch categoryType {
    case .birthdays:
      return Localize.createBirthdayScreenTitle
    case .aniversaries:
      return Localize.createAnniversaryScreenTitle
    case .other_year:
      return Localize.createEventScreenTitle
    default:
      return Localize.createNotificationScreenTitle
    }
  }

  private func editScreenTitle(for categoryType: CategoryTypeEnum?) -> LocalizedStringResource {
    switch categoryType {
    case .birthdays:
      return Localize.editBirthdayScreenTitle
    case .aniversaries:
      return Localize.editAnniversaryScreenTitle
    case .other_year:
      return Localize.editEventScreenTitle
    default:
      return Localize.editNotificationScreenTitle
    }
  }

  private func configureBindings() {
    store.alertsSectionData.$eventPeriod
      .receive(on: RunLoop.main)
      .sink { [weak self] eventPeriod in
        self?.updateRepeatRepresentationIfNeeded(for: eventPeriod)
      }
      .store(in: &cancellables)
  }

  private func updateRepeatRepresentationIfNeeded(for eventPeriod: EventPeriodEnum) {
    guard case .text = store.alertsSectionData.repeatRepresentationEnum else { return }
    store.alertsSectionData.repeatRepresentationEnum = .text(text: eventPeriodTitle(for: eventPeriod))
  }

  private func eventPeriodTitle(for eventPeriod: EventPeriodEnum) -> String {
    switch eventPeriod {
    case .everyYear:
      return String(localized: Localize.yearTitle.localed(locale))
    case .everyMonth:
      return String(localized: Localize.monthTitle.localed(locale))
    case .everyDay:
      return String(localized: Localize.dayTitle.localed(locale))
    }
  }
}
