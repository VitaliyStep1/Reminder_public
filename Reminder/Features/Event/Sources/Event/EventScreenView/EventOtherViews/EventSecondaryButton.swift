//
//  EventSecondaryButton.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 10.11.2025.
//

import SwiftUI
import DesignSystem

struct EventSecondaryButton: View {
  let action: () -> Void
  let title: LocalizedStringResource
  let imageName: String

  init(action: @escaping () -> Void, title: LocalizedStringResource, imageName: String) {
    self.action = action
    self.title = title
    self.imageName = imageName
  }
  
  var body: some View {
    Button(action: action) {
      Label(title: {
        Text(title)
      }, icon: {
        Image(systemName: imageName)
      })
    }
    .buttonStyle(DSSecondaryButtonStyle())
  }
}
