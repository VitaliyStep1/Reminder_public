//
//  ClosestFilterItemView.swift
//  Closest
//
//  Created by Vitaliy Stepanenko on 18.12.2025.
//

import DomainLocalization
import Language
import DesignSystem
import SwiftUI

struct ClosestFilterItemView: View {
  @Environment(\.locale) private var locale

  let filterItem: ClosestEntity.FilterItem
  let isSelected: Bool
  let tapAction: (UUID) -> Void

  private var localizedTitle: String {
    switch filterItem.filterItemEnum {
    case .all:
      return String(localized: Localize.closestAllFilterTitle.localed(locale))
    case .category(let category):
      return CategoryLocalizationManager.shared.localize(categoryTitle: category.title, locale: locale)
    }
  }

  var body: some View {
    Button(action: {
      tapAction(filterItem.id)
    }, label: {
      Text(localizedTitle)
        .font(.dsTitle3Semibold)
        .lineLimit(1)
        .foregroundStyle(isSelected ? DSColor.Text.white : DSColor.Text.accent)
        .padding(.horizontal, DSSpacing.s14)
        .padding(.vertical, DSSpacing.s10)
        .background(
          RoundedRectangle(cornerRadius: DSRadius.r12, style: .continuous)
            .fill(isSelected ? DSColor.Fill.accent : DSColor.Fill.accentO_12)
        )
        .overlay(
          RoundedRectangle(cornerRadius: DSRadius.r12, style: .continuous)
            .strokeBorder(
              DSColor.Stroke.accent.opacity(isSelected ? 0.45 : 0.2),
              lineWidth: 1
            )
        )
        .contentShape(Rectangle())
    })
    .buttonStyle(.plain)
    .accessibilityLabel(Text(localizedTitle))
    .accessibilityAddTraits(isSelected ? .isSelected : [])
  }
}
