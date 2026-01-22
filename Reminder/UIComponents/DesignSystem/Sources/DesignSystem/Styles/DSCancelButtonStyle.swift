//
//  DSCancelButtonStyle.swift
//  DesignSystem
//
//  Created by Vitaliy Stepanenko on 14.11.2025.
//

import SwiftUI

public struct DSCancelButtonStyle: ButtonStyle {
  public init() {}
  
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.dsHeadlineLarge)
      .frame(maxWidth: .infinity)
      .padding(.vertical, DSSpacing.s14)
      .background(
        RoundedRectangle(cornerRadius: DSRadius.r16, style: .continuous)
          .fill(.ultraThinMaterial)
      )
      .foregroundStyle(DSColor.Foreground.blue)
      .overlay(
        RoundedRectangle(cornerRadius: DSRadius.r16, style: .continuous)
          .stroke(DSColor.Stroke.secondary.opacity(0.2), lineWidth: 1)
      )
  }
}
