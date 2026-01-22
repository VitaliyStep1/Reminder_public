//
//  EventButtonsView.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 12.11.2025.
//

import SwiftUI
import DesignSystem

struct EventButtonsView: View {
  @ObservedObject private var buttonsData: EventButtonsData
  let interactor: EventInteractor
  
  init(buttonsData: EventButtonsData, interactor: EventInteractor) {
    self.buttonsData = buttonsData
    self.interactor = interactor
  }
  
  var body: some View {
    VStack(spacing: DSSpacing.s12) {
      EventSaveButton(
        buttonTappedAction: interactor.saveButtonTapped,
        title: buttonsData.saveButtonTitle,
        isProgressViewVisible: buttonsData.isSaving
      )
      .disabled(buttonsData.isSaving || buttonsData.isDeleting)
      
      EventCancelButton(
        buttonTappedAction: interactor.cancelButtonTapped,
        title: buttonsData.cancelButtonTitle
      )
      .disabled(buttonsData.isSaving || buttonsData.isDeleting)
      
      if buttonsData.isDeleteButtonVisible {
        EventDeleteButton(
          buttonTappedAction: interactor.deleteButtonTapped,
          title: buttonsData.deleteButtonTitle,
          isProgressViewVisible: buttonsData.isDeleting
        )
        .disabled(buttonsData.isSaving || buttonsData.isDeleting)
      }
    }
    .padding(.bottom, DSSpacing.s8)
  }
}
