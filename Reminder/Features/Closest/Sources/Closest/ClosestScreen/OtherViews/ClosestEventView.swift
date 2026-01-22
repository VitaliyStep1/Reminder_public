//
//  ClosestEventView.swift
//  Closest
//
//  Created by Vitaliy Stepanenko on 18.12.2025.
//

import SwiftUI
import DesignSystem

struct ClosestEventView: View {
  let eventTitle: String
  let dateString: String
  let iconStateEnum: ClosestEntity.RemindIconStateEnum
  let tapAction: () -> Void

  var body: some View {
    let iconColor: Color
    let iconImageSystemName: String
    switch iconStateEnum {
    case .notScheduledReminds:
      iconColor = DSColor.Icon.red
      iconImageSystemName = "clock.badge.xmark"
    case .scheduledReminds:
      iconColor = DSColor.Icon.green
      iconImageSystemName = "alarm"
    case .someRemindsAreScheduledAndSomeAreNot:
      iconColor = DSColor.Icon.orange
      iconImageSystemName = "alarm"
    case .noReminds:
      iconColor = DSColor.Icon.gray
      iconImageSystemName = "minus.circle"
    }
    return Button(action: tapAction) {
      HStack(alignment: .top, spacing: DSSpacing.s8) {
        Text(eventTitle)
          .font(DSFont.title3())
          .foregroundStyle(DSColor.Text.primary)
          .multilineTextAlignment(.leading)
        Spacer()
        HStack(spacing: DSSpacing.s4) {
          Image(systemName: iconImageSystemName)
            .foregroundStyle(iconColor)
            .padding(.trailing, DSSpacing.s10)
          Text(dateString)
            .foregroundStyle(DSColor.Text.secondary)
        }
      }
    }
    .dsCellBackground(radius: DSRadius.r8, verticalPadding: DSSpacing.s10)
    .dsShadow(.r8Medium)
  }
}
