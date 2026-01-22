//
//  EventRemindTimeRow.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 10.11.2025.
//

import SwiftUI
import DesignSystem

struct EventRemindTimeRow: View {
  let title: LocalizedStringResource
  @Binding var selection: Date
  let removeAction: (() -> Void)?

  init(title: LocalizedStringResource, selection: Binding<Date>, removeAction: (() -> Void)? = nil) {
    self.title = title
    _selection = selection
    self.removeAction = removeAction
  }
  
  var body: some View {
    HStack(spacing: DSSpacing.s12) {
      VStack(alignment: .leading, spacing: DSSpacing.s6) {
        Text(title)
          .font(.dsSubheadlineSemibold)
          .foregroundStyle(.secondary)
        DatePicker(
          "",
          selection: $selection,
          displayedComponents: .hourAndMinute
        )
        .labelsHidden()
        .datePickerStyle(.compact)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      if let removeAction {
        Button(action: removeAction) {
          Image(systemName: "minus.circle.fill")
            .font(.dsTitle2)
            .foregroundStyle(DSColor.Icon.red)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(String(localized: title))
      }
    }
    .padding(.horizontal, DSSpacing.s14)
    .padding(.vertical, DSSpacing.s12)
    .background(fieldBackground)
    .clipShape(RoundedRectangle(cornerRadius: DSRadius.r14, style: .continuous))
  }

  private var fieldBackground: some View {
    RoundedRectangle(cornerRadius: DSRadius.r14, style: .continuous)
      .fill(DSColor.Background.primary.opacity(0.9))
      .dsShadow(.r6Light)
  }
}
