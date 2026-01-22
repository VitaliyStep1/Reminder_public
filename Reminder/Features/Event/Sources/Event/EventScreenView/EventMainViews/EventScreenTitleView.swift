//
//  EventScreenTitleView.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 09.11.2025.
//

import SwiftUI
import DesignSystem

struct EventScreenTitleView: View {
  @ObservedObject private var screenTitleData: EventScreenTitleData
  
  init(screenTitleData: EventScreenTitleData) {
    self.screenTitleData = screenTitleData
  }
  
  var body: some View {
    Label {
      Text(screenTitleData.screenTitle)
        .font(.dsTitleLarge)
    } icon: {
      Image(systemName: "calendar.badge.plus")
        .font(.dsTitle3Semibold)
        .foregroundStyle(DSColor.Icon.white)
        .padding(DSSpacing.s12)
        .background(
          Circle()
            .fill(
              LinearGradient(
                colors: [DSColor.Gradient.accentStart, DSColor.Gradient.accentEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
        )
        .dsShadow(.r14AccentStrong)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
