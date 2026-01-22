//
//  EventSectionContainer.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 09.11.2025.
//

import SwiftUI
import DesignSystem

struct EventSectionContainer<Content: View>: View {
  let title: LocalizedStringResource
  let systemImageName: String
  let isHeaderVisible: Bool
  let contentBuilder: () -> Content

  init(
    title: LocalizedStringResource,
    systemImageName: String,
    isHeaderVisible: Bool = true,
    @ViewBuilder contentBuilder: @escaping () -> Content
  ) {
    self.title = title
    self.systemImageName = systemImageName
    self.isHeaderVisible = isHeaderVisible
    self.contentBuilder = contentBuilder
  }

  var body: some View {
    VStack(alignment: .leading, spacing: DSSpacing.s16) {
      if isHeaderVisible {
        Label(title: {
          Text(title)
        }, icon: {
          Image(systemName: systemImageName)
        })
        .font(.dsTitle3Semibold)
        .foregroundStyle(.primary)
      }
      contentBuilder()
    }
    .padding(DSSpacing.s20)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: DSRadius.r24, style: .continuous)
        .fill(.ultraThinMaterial)
    )
    .overlay(
      RoundedRectangle(cornerRadius: DSRadius.r24, style: .continuous)
        .stroke(DSColor.Stroke.primaryO_08)
    )
    .dsShadow(.r12Heavy)
  }
}
