//
//  ClosestCreateEventButton.swift
//  ClosestTab
//
//  Created by Vitaliy Stepanenko on 14.11.2025.
//

import SwiftUI
import DesignSystem

struct ClosestCreateEventButton: View {
  let systemImageName: String
  let title: LocalizedStringResource
  let action: () -> Void
  
  public init(systemImageName: String, title: LocalizedStringResource, action: @escaping () -> Void) {
    self.systemImageName = systemImageName
    self.title = title
    self.action = action
  }
  
  var body: some View {
    Button {
      action()
    } label: {
      Label(title: {
        Text(title)
      }, icon: {
        Image(systemName: systemImageName)
      })
    }
    .buttonStyle(DSMainButtonStyle())
  }
}
