//
//  CategoriesCategoryRowView.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 30.10.2025.
//

import SwiftUI
import DesignSystem

struct CategoriesCategoryRowView: View {
  let title: String
  let eventsAmountText: String
  let tapAction: () -> Void
  
  var body: some View {
    Button {
      tapAction()
    } label: {
      HStack(spacing: DSSpacing.s8) {
        Text(title)
          .font(.dsHeadline)
          .foregroundStyle(.primary)
        Spacer()
        Text(eventsAmountText)
          .font(.dsSubheadline)
          .foregroundStyle(.secondary)
      }
      .dsCellBackground()
    }
    .buttonStyle(.plain)
    .dsShadow(.r8Medium)
  }
}
