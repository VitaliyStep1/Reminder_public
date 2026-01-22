//
//  ErrorNotificationsPermissionAlertInfo.swift
//  Event
//
//  Created by Vitaliy Stepanenko on 24.12.2025.
//

public struct ErrorNotificationsPermissionAlertInfo {
  let title: String
  let message: String
  let cancelTitle: String
  let openSettingsTitle: String
  let saveWithoutNotificationsTitle: String
  var cancelHandler: () -> Void
  var openSettingsHandler: () -> Void
  var saveWithoutNotificationsHandler: () -> Void
  
  public init(title: String, message: String, cancelTitle: String, openSettingsTitle: String, saveWithoutNotificationsTitle: String, cancelHandler: @escaping () -> Void, openSettingsHandler: @escaping () -> Void, saveWithoutNotificationsHandler: @escaping () -> Void) {
    self.title = title
    self.message = message
    self.cancelTitle = cancelTitle
    self.openSettingsTitle = openSettingsTitle
    self.saveWithoutNotificationsTitle = saveWithoutNotificationsTitle
    self.cancelHandler = cancelHandler
    self.openSettingsHandler = openSettingsHandler
    self.saveWithoutNotificationsHandler = saveWithoutNotificationsHandler
  }
}
