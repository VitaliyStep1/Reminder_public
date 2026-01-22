//
//  EventSubSectionContainer.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 09.11.2025.
//

import SwiftUI
import DesignSystem

struct EventSubSectionContainer<Content: View>: View {
  let title: LocalizedStringResource
  let foregroundStyle: Color
  let contentBuilder: () -> Content

  init(
    title: LocalizedStringResource,
    foregroundStyle: Color = .secondary,
    @ViewBuilder contentBuilder: @escaping () -> Content
  ) {
    self.title = title
    self.foregroundStyle = foregroundStyle
    self.contentBuilder = contentBuilder
  }

  var body: some View {
    VStack(alignment: .leading, spacing: DSSpacing.s8) {
      Text(title)
        .font(.dsSubheadlineSemibold)
        .foregroundStyle(foregroundStyle)
      contentBuilder()
    }
  }
}
