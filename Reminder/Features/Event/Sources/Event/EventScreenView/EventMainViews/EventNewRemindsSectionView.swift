//
//  EventNewRemindsSectionView.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 12.11.2025.
//

import SwiftUI
import DesignSystem

struct EventNewRemindsSectionView: View {
  @ObservedObject private var newRemindsSectionData: EventNewRemindsSectionData
  private let interactor: EventInteractor

  init(newRemindsSectionData: EventNewRemindsSectionData, interactor: EventInteractor) {
    self.newRemindsSectionData = newRemindsSectionData
    self.interactor = interactor
  }
  
  var body: some View {
    EventSectionContainer(title: Localize.newRemindsSectionTitle, systemImageName: "square.and.pencil") {
      
      VStack {
        if let remindBeforeDate = newRemindsSectionData.remindBeforeDate {
          EventNewRemindView(
            dateTimeString: newRemindsSectionData.takeStringFromDate(date: remindBeforeDate),
            isScheduled: nil
          )
        }
        if let remindOnDayDate = newRemindsSectionData.remindOnDayDate {
          EventNewRemindView(
            dateTimeString: newRemindsSectionData.takeStringFromDate(date: remindOnDayDate),
            isScheduled: nil
          )
        }
      }
      
      if newRemindsSectionData.isNoNotificationPermissionViewVisible {
        noRemindPermissionView
      }
    }
  }
  
  @ViewBuilder
  private var noRemindPermissionView: some View {
    Text(Localize.notificationsNotAllowedText)
    Button {
      interactor.allowNotificationsButtonTapped()
    } label: {
      Text(Localize.allowNotificationsButton)
    }
    .buttonStyle(DSSecondaryButtonStyle())
  }
}
