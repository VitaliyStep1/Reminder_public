//
//  EventCancelButton.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 10.11.2025.
//

import SwiftUI
import DesignSystem

struct EventCancelButton: View {
  let buttonTappedAction: () -> Void
  let title: String
  
  init(buttonTappedAction: @escaping () -> Void, title: String) {
    self.buttonTappedAction = buttonTappedAction
    self.title = title
  }
  
  var body: some View {
    Button(action: {
      buttonTappedAction()
    }) {
      Text(title)
    }
    .buttonStyle(DSCancelButtonStyle())
  }
}
