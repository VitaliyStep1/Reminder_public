//
//  PermissionAlertModifier.swift
//  Event
//
//  Created by Vitaliy Stepanenko on 25.12.2025.
//

import SwiftUI

public struct PermissionAlertModifier: ViewModifier {
  @Binding private var isPresented: Bool
  private let title: String
  private let message: String
  private let cancelButtonTitle: String
  private let openSettingsButtonTitle: String
  private let saveWithoutNotificationsButtonTitle: String
  private let cancelHandler: () -> Void
  private let openSettingsHandler: () -> Void
  private let saveWithoutNotificationsHandler: () -> Void
  
  public init(
    isPresented: Binding<Bool>,
    title: String,
    message: String,
    cancelButtonTitle: String,
    openSettingsButtonTitle: String,
    saveWithoutNotificationsButtonTitle: String,
    cancelHandler: @escaping () -> Void,
    openSettingsHandler: @escaping () -> Void,
    saveWithoutNotificationsHandler: @escaping () -> Void
  ) {
    _isPresented = isPresented
    self.title = title
    self.message = message
    self.cancelButtonTitle = cancelButtonTitle
    self.openSettingsButtonTitle = openSettingsButtonTitle
    self.saveWithoutNotificationsButtonTitle = saveWithoutNotificationsButtonTitle
    self.cancelHandler = cancelHandler
    self.openSettingsHandler = openSettingsHandler
    self.saveWithoutNotificationsHandler = saveWithoutNotificationsHandler
  }
  
  public func body(content: Content) -> some View {
    content.alert(title, isPresented: $isPresented) {
      Button(openSettingsButtonTitle) {
        openSettingsHandler()
      }
      Button(saveWithoutNotificationsButtonTitle) {
        saveWithoutNotificationsHandler()
      }
      Button(cancelButtonTitle, role: .cancel) {
        cancelHandler()
      }
    } message: {
      Text(message)
    }
  }
}

public extension View {
  func permissionAlert(
    isPresented: Binding<Bool>,
    title: String,
    message: String,
    cancelButtonTitle: String,
    openSettingsButtonTitle: String,
    saveWithoutNotificationsButtonTitle: String,
    cancelHandler: @escaping () -> Void,
    openSettingsHandler: @escaping () -> Void,
    saveWithoutNotificationsHandler: @escaping () -> Void
  ) -> some View {
    modifier(
      PermissionAlertModifier(
        isPresented: isPresented,
        title: title,
        message: message,
        cancelButtonTitle: cancelButtonTitle,
        openSettingsButtonTitle: openSettingsButtonTitle,
        saveWithoutNotificationsButtonTitle: saveWithoutNotificationsButtonTitle,
        cancelHandler: cancelHandler,
        openSettingsHandler: openSettingsHandler,
        saveWithoutNotificationsHandler: saveWithoutNotificationsHandler
      )
    )
  }
}
