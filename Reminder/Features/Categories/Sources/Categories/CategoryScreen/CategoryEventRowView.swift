//
//  CategoryEventCellView.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 22.09.2025.
//

import SwiftUI
import DesignSystem

public struct CategoryEventRowView: View {
  var title: String
  var dateString: String
  let tapAction: () -> Void
  
  public var body: some View {
    Button {
      tapAction()
    } label: {
      VStack(alignment: .leading, spacing: DSSpacing.s4) {
        HStack {
          Text(title)
            .font(.dsHeadline)
            .foregroundStyle(.primary)
          Spacer()
          Text(dateString)
            .font(DSFont.medium18())
            .monospacedDigit()
            .foregroundStyle(.secondary)
        }
      }
      .dsCellBackground(radius: DSRadius.r8, verticalPadding: DSSpacing.s10)
    }
    .buttonStyle(.plain)
    .dsShadow(.r8Medium)
  }
}

#Preview {
  CategoryEventRowView(title: "Title", dateString: "1.01.2001", tapAction: { })
}
