//
//  EventViewStore.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 20.10.2025.
//

import Foundation
import DomainContracts
import NavigationContracts

@MainActor
public final class EventViewStore: ObservableObject {
  public let eventScreenViewType: EventScreenViewType

  let screenTitleData: EventScreenTitleData
  let detailsSectionData: EventDetailsSectionData
  let alertsSectionData: EventAlertsSectionData
  let newRemindsSectionData: EventNewRemindsSectionData
  let buttonsData: EventButtonsData
  
  @Published public var isViewBlocked: Bool
  
  @Published public var isAlertVisible: Bool
  public var alertInfo: ErrorAlertInfo
  
  @Published public var isPermissionAlertVisible: Bool
  public var permissionAlertInfo: ErrorNotificationsPermissionAlertInfo
  
  @Published public var isConfirmationDialogVisible: Bool
  public var confirmationDialogInfo: DeleteConfirmationDialogInfo

  public var category: DomainContracts.Category?

  @Published public var onDayLNEventId: UUID?
  @Published public var beforeLNEventId: UUID?

  let categoryEventWasUpdatedDelegate: (any EventCategoryEventWasUpdatedDelegate)?

  public init(eventScreenViewType: EventScreenViewType, categoryEventWasUpdatedDelegate: (any EventCategoryEventWasUpdatedDelegate)?, locale: Locale = .current) {
    self.eventScreenViewType = eventScreenViewType

    self.screenTitleData = EventScreenTitleData(screenTitle: "")
    self.detailsSectionData = EventDetailsSectionData(
      eventTitle: "",
      eventComment: "",
      eventDate: Date(),
      isYearIncluded: false
    )

    self.alertsSectionData = EventAlertsSectionData(
      repeatRepresentationEnum: .text(text: ""),
      eventPeriod: .everyYear,
      isRemindTime2ViewVisible: false,
      isAddRemindTimeButtonVisible: true,
      defaultRemindTimeDate: Date(),
      isRemindRepeated: true,
      remindOnDayTimeDate: Date(),
      remindOnDayDate: Date(),
      isRemindOnDayActive: true,
      remindBeforeDays: 7,
      remindBeforeDate: nil,
      remindBeforeTimeDate: Date(),
      isRemindBeforeActive: false
    )
    
    self.newRemindsSectionData = EventNewRemindsSectionData(remindOnDayDate: nil, remindBeforeDate: nil, isNoNotificationPermissionViewVisible: true)
    
    self.buttonsData = EventButtonsData(
      isSaving: false,
      isDeleting: false,
      isDeleteButtonVisible: false,
      saveButtonTitle: "",
      cancelButtonTitle: String(localized: Localize.cancelTitle.localed(locale)),
      deleteButtonTitle: String(localized: Localize.deleteButtonTitle.localed(locale))
    )
    
    self.isViewBlocked = false
    self.isAlertVisible = false
    self.alertInfo = ErrorAlertInfo(message: "")
    self.isPermissionAlertVisible = false
    self.permissionAlertInfo = ErrorNotificationsPermissionAlertInfo(title: "", message: "", cancelTitle: "", openSettingsTitle: "", saveWithoutNotificationsTitle: "", cancelHandler: {}, openSettingsHandler: {}, saveWithoutNotificationsHandler: {})
    self.isConfirmationDialogVisible = false
    self.confirmationDialogInfo = DeleteConfirmationDialogInfo(title: "", message: "", deleteButtonHandler: {})
    self.category = nil
    self.onDayLNEventId = nil
    self.beforeLNEventId = nil
    self.categoryEventWasUpdatedDelegate = categoryEventWasUpdatedDelegate
  }

  func updateLocale(_ locale: Locale) {
    buttonsData.cancelButtonTitle = String(localized: Localize.cancelTitle.localed(locale))
    buttonsData.deleteButtonTitle = String(localized: Localize.deleteButtonTitle.localed(locale))
  }
}
