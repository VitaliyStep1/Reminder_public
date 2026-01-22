//
//  DSMainTextFieldStyle.swift
//  DesignSystem
//
//  Created by Vitaliy Stepanenko on 15.11.2025.
//

import SwiftUI

public struct DSMainTextFieldStyle: TextFieldStyle {
  private let isTextNotEmpty: Bool
  
  public init(isTextNotEmpty: Bool) {
    self.isTextNotEmpty = isTextNotEmpty
  }
  
  public func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding(.horizontal, DSSpacing.s14)
      .padding(.vertical, DSSpacing.s12)
      .background(fieldBackground)
      .overlay(
        RoundedRectangle(cornerRadius: DSRadius.r14, style: .continuous)
          .stroke(DSColor.Stroke.accent.opacity(isTextNotEmpty ? 0.4 : 0), lineWidth: 1)
      )
  }

  private var fieldBackground: some View {
    RoundedRectangle(cornerRadius: DSRadius.r14, style: .continuous)
      .fill(DSColor.Background.primary.opacity(0.9))
      .dsShadow(.r4Light)
  }
}
