//
//  Localize.swift
//  Categories
//
//  Created by OpenAI Assistant on 28.11.2025.
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
  static var eventDeleteFailedAlert: LocalizedStringResource { localizedResource("eventDeleteFailedAlert") }
  static var eventNotFoundAlert: LocalizedStringResource { localizedResource("eventNotFoundAlert") }
  static var categoryNotFoundAlert: LocalizedStringResource { localizedResource("categoryNotFoundAlert") }
  static var eventsNotFetchedAlert: LocalizedStringResource { localizedResource("eventsNotFetchedAlert") }

  static var createEventScreenTitle: LocalizedStringResource { localizedResource("createEventScreenTitle") }
  static var createEventButtonTitle: LocalizedStringResource { localizedResource("createEventButtonTitle") }
  static var editEventScreenTitle: LocalizedStringResource { localizedResource("editEventScreenTitle") }
  static var saveEventButtonTitle: LocalizedStringResource { localizedResource("saveEventButtonTitle") }

  static var yearTitle: LocalizedStringResource { localizedResource("yearTitle") }
  static var monthTitle: LocalizedStringResource { localizedResource("monthTitle") }
  static var dayTitle: LocalizedStringResource { localizedResource("dayTitle") }

  static var newRemindsSectionTitle: LocalizedStringResource { localizedResource("newRemindsSectionTitle") }
  static var noNewRemindsText: LocalizedStringResource { localizedResource("noNewRemindsText") }
  static var notificationsNotAllowedText: LocalizedStringResource { localizedResource("notificationsNotAllowedText") }
  static var allowNotificationsButton: LocalizedStringResource { localizedResource("allowNotificationsButton") }

  static var eventDetailsSectionTitle: LocalizedStringResource { localizedResource("eventDetailsSectionTitle") }
  static var eventTitleTitle: LocalizedStringResource { localizedResource("eventTitleTitle") }
  static var eventTitlePlaceholder: LocalizedStringResource { localizedResource("eventTitlePlaceholder") }
  static var eventCommentTitle: LocalizedStringResource { localizedResource("eventCommentTitle") }
  static var eventCommentPlaceholder: LocalizedStringResource { localizedResource("eventCommentPlaceholder") }
  static var eventDateTitle: LocalizedStringResource { localizedResource("eventDateTitle") }
  static var eventDateLabel: LocalizedStringResource { localizedResource("eventDateLabel") }
  static var selectEventDateTitle: LocalizedStringResource { localizedResource("selectEventDateTitle") }
  static var cancelTitle: LocalizedStringResource { localizedResource("cancelTitle") }
  static var deleteButtonTitle: LocalizedStringResource { localizedResource("deleteButtonTitle") }
  static var doneTitle: LocalizedStringResource { localizedResource("doneTitle") }

  static var alertsSectionTitle: LocalizedStringResource { localizedResource("alertsSectionTitle") }
  static var repeatEveryTitle: LocalizedStringResource { localizedResource("repeatEveryTitle") }
  static var addRemindTimeButtonTitle: LocalizedStringResource { localizedResource("addRemindTimeButtonTitle") }
  static var remindTime1Title: LocalizedStringResource { localizedResource("remindTime1Title") }
  static var remindTime2Title: LocalizedStringResource { localizedResource("remindTime2Title") }

  static var categoriesNavigationTitle: LocalizedStringResource { localizedResource("categoriesNavigationTitle") }
  static var noCategoriesText: LocalizedStringResource { localizedResource("noCategoriesText") }
  static var eventSingular: LocalizedStringResource { localizedResource("eventSingular") }
  static var eventsPlural: LocalizedStringResource { localizedResource("eventsPlural") }
  static var eventsPluralMany: LocalizedStringResource { localizedResource("eventsPluralMany") }
  static var addNewEventButtonTitle: LocalizedStringResource { localizedResource("addNewEventButtonTitle") }
  static var categoryNoEventsText: LocalizedStringResource { localizedResource("categoryNoEventsText") }
  static var addedEventsFormat: LocalizedStringResource { localizedResource("addedEventsFormat") }
  static var agreementTitle: LocalizedStringResource { localizedResource("agreementTitle") }
  static var agreementAcceptButtonTitle: LocalizedStringResource { localizedResource("agreementAcceptButtonTitle") }
  static var agreementCancelButtonTitle: LocalizedStringResource { localizedResource("agreementCancelButtonTitle") }
  static var agreementMessage: LocalizedStringResource { localizedResource("agreementMessage") }
}

extension LocalizedStringResource {
  func localed(_ locale: Locale) -> LocalizedStringResource {
    var resource = self
    resource.locale = locale
    return resource
  }
}
