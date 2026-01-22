//
//  CategoryHeaderView.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 14.11.2025.
//

import SwiftUI
import DesignSystem

struct CategoryHeaderView: View {
  let title: String
  let subtitle: String

  var body: some View {
    VStack(alignment: .leading, spacing: DSSpacing.s8) {
      Text(title)
        .font(.dsTitleLarge)
        .foregroundStyle(.primary)

      Text(subtitle)
        .font(.dsCallout)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
