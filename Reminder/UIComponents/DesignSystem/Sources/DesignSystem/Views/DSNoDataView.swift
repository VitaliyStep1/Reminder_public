//
//  DSNoDataView.swift
//  DesignSystem
//
//  Created by Vitaliy Stepanenko on 13.11.2025.
//

import SwiftUI

public struct DSNoDataView: View {
  let systemImageName: String
  let title: LocalizedStringResource
  
  public init(systemImageName: String, title: LocalizedStringResource) {
    self.systemImageName = systemImageName
    self.title = title
  }
  
  public var body: some View {
    VStack(spacing: 24) {
      Image(systemName: systemImageName)
        .font(.dsIconXLarge)
        .foregroundStyle(DSColor.Icon.accent)

      Text(title)
        .font(.dsBody)
        .multilineTextAlignment(.center)
        .foregroundStyle(DSColor.Text.secondary)
    }
  }
}
