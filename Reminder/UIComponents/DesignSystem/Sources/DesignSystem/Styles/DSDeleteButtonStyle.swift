//
//  DSDeleteButtonStyle.swift
//  DesignSystem
//
//  Created by Vitaliy Stepanenko on 14.11.2025.
//

import SwiftUI

public struct DSDeleteButtonStyle: ButtonStyle {
  public init() {}
  
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.dsHeadlineLarge)
      .frame(maxWidth: .infinity)
      .padding(.vertical, DSSpacing.s14)
      .background(
        LinearGradient(
          colors: [DSColor.Gradient.redStart, DSColor.Gradient.redEnd],
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .foregroundStyle(DSColor.Foreground.white)
      .clipShape(RoundedRectangle(cornerRadius: DSRadius.r14, style: .continuous))
      .dsShadow(.r10Danger)
  }
}
