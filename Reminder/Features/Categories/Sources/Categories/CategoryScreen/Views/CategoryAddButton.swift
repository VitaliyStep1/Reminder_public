//
//  CategoryAddButton.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 14.11.2025.
//

import SwiftUI
import DesignSystem

struct CategoryAddButton: View {
  let systemImageName: String
  let title: LocalizedStringResource
  let action: () -> Void

  public init(systemImageName: String, title: LocalizedStringResource, action: @escaping () -> Void) {
    self.systemImageName = systemImageName
    self.title = title
    self.action = action
  }
  
  public var body: some View {
    Button(action: {
      action()
    }) {
      Label(title: {
        Text(title)
      }, icon: {
        Image(systemName: systemImageName)
      })
    }
    .buttonStyle(DSMainButtonStyle())
  }
}
