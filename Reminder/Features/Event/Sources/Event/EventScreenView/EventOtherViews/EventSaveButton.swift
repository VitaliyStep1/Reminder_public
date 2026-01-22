//
//  EventSaveButton.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 10.11.2025.
//

import SwiftUI
import DesignSystem

struct EventSaveButton: View {
  let buttonTappedAction: () -> Void
  let title: String
  let isProgressViewVisible: Bool
  
  init(buttonTappedAction: @escaping () -> Void, title: String, isProgressViewVisible: Bool) {
    self.buttonTappedAction = buttonTappedAction
    self.title = title
    self.isProgressViewVisible = isProgressViewVisible
  }
  
  var body: some View {
    Button(action: {
      buttonTappedAction()
    }) {
    HStack(spacing: DSSpacing.s10) {
        if isProgressViewVisible {
          ProgressView()
            .tint(DSColor.ProgressViewTint.white)
          Text(title)
        } else {
          Image(systemName: "checkmark.circle.fill")
          Text(title)
        }
      }
    }
    .buttonStyle(DSMainButtonStyle())
  }
}
