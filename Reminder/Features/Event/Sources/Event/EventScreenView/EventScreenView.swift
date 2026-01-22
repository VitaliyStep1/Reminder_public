//
//  EventScreenView.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 13.09.2025.
//

import SwiftUI
import DesignSystem
import DomainLocalization

public struct EventScreenView: View {
  @ObservedObject private var store: EventViewStore
  private let interactor: EventInteractor
  @Environment(\.locale) private var locale
  
  public init(store: EventViewStore, interactor: EventInteractor) {
    self.store = store
    self.interactor = interactor
  }
  
  public var body: some View {
    contentView
      .padding(.top, Styles.Padding.ScreenPadding.top)
      .padding(.bottom, Styles.Padding.ScreenPadding.bottom)
//      .dsScreenPadding()
      .dsScreenBackground()
      .navigationTitle(navigationTitle)
      .navigationBarTitleDisplayMode(.inline)
      .disabled(store.isViewBlocked)
      .dsErrorAlert(
        isPresented: $store.isAlertVisible,
        message: store.alertInfo.message,
        completion: store.alertInfo.completion
      )
      .permissionAlert(isPresented: $store.isPermissionAlertVisible,
                       title: store.permissionAlertInfo.title,
                       message: store.permissionAlertInfo.message,
                       cancelButtonTitle: store.permissionAlertInfo.cancelTitle,
                       openSettingsButtonTitle: store.permissionAlertInfo.openSettingsTitle,
                       saveWithoutNotificationsButtonTitle: store.permissionAlertInfo.saveWithoutNotificationsTitle,
                       cancelHandler: store.permissionAlertInfo.cancelHandler,
                       openSettingsHandler: store.permissionAlertInfo.openSettingsHandler,
                       saveWithoutNotificationsHandler: store.permissionAlertInfo.saveWithoutNotificationsHandler)
      .dsDeleteConfirmationDialog(
        isPresented: $store.isConfirmationDialogVisible,
        title: store.confirmationDialogInfo.title,
        deleteAction: store.confirmationDialogInfo.deleteButtonHandler,
        message: store.confirmationDialogInfo.message
      )
      .task {
        interactor.updateLocale(locale)
        await interactor.taskWasCalled()
      }
      .onChange(of: locale) { newLocale in
        interactor.updateLocale(newLocale)
      }
  }
  
  //MARK: - Views

  var contentView: some View {
    ScrollView(showsIndicators: false) {
      LazyVStack(spacing: DSSpacing.s24) {
        EventScreenTitleView(screenTitleData: store.screenTitleData)
        EventDetailsSectionView(detailsSectionData: store.detailsSectionData, categoryType: store.category?.categoryTypeEnum)
        EventAlertsSectionView(alertsSectionData: store.alertsSectionData, interactor: interactor)
        EventNewRemindsSectionView(newRemindsSectionData: store.newRemindsSectionData, interactor: interactor)
        EventButtonsView(buttonsData: store.buttonsData, interactor: interactor)
      }
      .padding(.horizontal, Styles.Padding.ScreenPadding.horizontal)
      
      //      .frame(maxWidth: 640)
      //      .frame(maxWidth: .infinity)
    }
    .scrollClipDisabled()
  }

  private var navigationTitle: String {
    guard let categoryTitle = store.category?.title else { return "" }
    return CategoryLocalizationManager.shared.localize(categoryTitle: categoryTitle, locale: locale)
  }
}

