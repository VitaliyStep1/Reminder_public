//
//  Localize.swift
//  Event
//
//  Created by OpenAI Assistant on 02.01.2026.
//
import SwiftUI

enum Localize {
  private static let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
  private static func localizedResource(_ localizationValue: String.LocalizationValue) -> LocalizedStringResource {
    .init(localizationValue, bundle: Localize.bundleDescription)
  }

  static var deleteEventTitle: LocalizedStringResource { localizedResource("deleteEventTitle") }
  static var deleteEventMessage: LocalizedStringResource { localizedResource("deleteEventMessage") }
  static var eventTitleEmptyAlert: LocalizedStringResource { localizedResource("eventTitleEmptyAlert") }
  static var eventNotSavedAlert: LocalizedStringResource { localizedResource("eventNotSavedAlert") }
  static var notificationsWereNotScheduled: LocalizedStringResource { localizedResource("notificationsWereNotScheduled") }
  static var eventDeleteFailedAlert: LocalizedStringResource { localizedResource("eventDeleteFailedAlert") }
  static var eventNotFoundAlert: LocalizedStringResource { localizedResource("eventNotFoundAlert") }
  static var categoryNotFoundAlert: LocalizedStringResource { localizedResource("categoryNotFoundAlert") }

  static var createEventScreenTitle: LocalizedStringResource { localizedResource("createEventScreenTitle") }
  static var createBirthdayScreenTitle: LocalizedStringResource { localizedResource("createBirthdayScreenTitle") }
  static var createAnniversaryScreenTitle: LocalizedStringResource { localizedResource("createAnniversaryScreenTitle") }
  static var createNotificationScreenTitle: LocalizedStringResource { localizedResource("createNotificationScreenTitle") }
  static var createEventButtonTitle: LocalizedStringResource { localizedResource("createEventButtonTitle") }
  static var editEventScreenTitle: LocalizedStringResource { localizedResource("editEventScreenTitle") }
  static var editBirthdayScreenTitle: LocalizedStringResource { localizedResource("editBirthdayScreenTitle") }
  static var editAnniversaryScreenTitle: LocalizedStringResource { localizedResource("editAnniversaryScreenTitle") }
  static var editNotificationScreenTitle: LocalizedStringResource { localizedResource("editNotificationScreenTitle") }
  static var saveEventButtonTitle: LocalizedStringResource { localizedResource("saveEventButtonTitle") }

  static var yearTitle: LocalizedStringResource { localizedResource("yearTitle") }
  static var monthTitle: LocalizedStringResource { localizedResource("monthTitle") }
  static var dayTitle: LocalizedStringResource { localizedResource("dayTitle") }

  static var newRemindsSectionTitle: LocalizedStringResource { localizedResource("newRemindsSectionTitle") }
  static var noNewRemindsText: LocalizedStringResource { localizedResource("noNewRemindsText") }
  static var notificationsNotAllowedText: LocalizedStringResource { localizedResource("notificationsNotAllowedText") }
  static var allowNotificationsButton: LocalizedStringResource { localizedResource("allowNotificationsButton") }
  static var editEventButtonTitle: LocalizedStringResource { localizedResource("editEventButtonTitle") }

  static var eventDetailsSectionTitle: LocalizedStringResource { localizedResource("eventDetailsSectionTitle") }
  static var eventTitleTitle: LocalizedStringResource { localizedResource("eventTitleTitle") }
  static var eventTitlePlaceholder: LocalizedStringResource { localizedResource("eventTitlePlaceholder") }
  static var eventNameTitle: LocalizedStringResource { localizedResource("eventNameTitle") }
  static var eventNamePlaceholder: LocalizedStringResource { localizedResource("eventNamePlaceholder") }
  static var eventCommentTitle: LocalizedStringResource { localizedResource("eventCommentTitle") }
  static var eventCommentPlaceholder: LocalizedStringResource { localizedResource("eventCommentPlaceholder") }
  static var eventDateTitle: LocalizedStringResource { localizedResource("eventDateTitle") }
  static var birthdayDateTitle: LocalizedStringResource { localizedResource("birthdayDateTitle") }
  static var eventDateLabel: LocalizedStringResource { localizedResource("eventDateLabel") }
  static var eventDateWithYearToggleTitle: LocalizedStringResource { localizedResource("eventDateWithYearToggleTitle") }
  static var selectEventDateTitle: LocalizedStringResource { localizedResource("selectEventDateTitle") }
  static var cancelTitle: LocalizedStringResource { localizedResource("cancelTitle") }
  static var deleteButtonTitle: LocalizedStringResource { localizedResource("deleteButtonTitle") }
  static var doneTitle: LocalizedStringResource { localizedResource("doneTitle") }

  static var alertsSectionTitle: LocalizedStringResource { localizedResource("alertsSectionTitle") }
  static var repeatEveryTitle: LocalizedStringResource { localizedResource("repeatEveryTitle") }
  static var addRemindTimeButtonTitle: LocalizedStringResource { localizedResource("addRemindTimeButtonTitle") }
  static var remindTime1Title: LocalizedStringResource { localizedResource("remindTime1Title") }
  static var remindTime2Title: LocalizedStringResource { localizedResource("remindTime2Title") }
  static var remindOnDayOfEventTitle: LocalizedStringResource { localizedResource("remindOnDayOfEventTitle") }
  static var isNecessaryToRepeatTitle: LocalizedStringResource { localizedResource("isNecessaryToRepeatTitle") }
  static var remindBeforeDayOfEventTitle: LocalizedStringResource { localizedResource("remindBeforeDayOfEventTitle") }
  static var daysBeforeTitle: LocalizedStringResource { localizedResource("daysBeforeTitle") }
}

extension LocalizedStringResource {
  func localed(_ locale: Locale) -> LocalizedStringResource {
    var resource = self
    resource.locale = locale
    return resource
  }
}
