//
//  EventNewRemindView.swift
//  Categories
//
//  Created by Vitaliy Stepanenko on 16.12.2025.
//

import SwiftUI
import DesignSystem

struct EventNewRemindView: View {
  let dateTimeString: String
  let isScheduled: Bool?
  
  var body: some View {
    HStack(spacing: DSSpacing.s12) {
      Image(systemName: "alarm")
        .font(DSFont.semibold18())
        .padding(.leading, DSSpacing.s32)
      Text(dateTimeString)
        .font(DSFont.medium18())
      if let isScheduled {
        Image(systemName: isScheduled ? "checkmark.circle" : "minus.circle")
          .foregroundStyle(isScheduled ? DSColor.Icon.green : DSColor.Icon.red)
          .font(DSFont.semibold22())
          .padding(.leading, DSSpacing.s16)
        Spacer()
      }
    }
  }
}
