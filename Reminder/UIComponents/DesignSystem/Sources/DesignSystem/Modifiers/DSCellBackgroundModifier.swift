//
//  DSCellBackgroundModifier.swift
//  DesignSystem
//
//  Created by Vitaliy Stepanenko on 14.11.2025.
//

import SwiftUI

public struct DSCellBackgroundModifier: ViewModifier {
  private let cornerRadius: CGFloat
  private let verticalPadding: CGFloat
  public init(cornerRadius: CGFloat, verticalPadding: CGFloat) {
    self.cornerRadius = cornerRadius
    self.verticalPadding = verticalPadding
  }
  
  public func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, DSSpacing.s16)
      .padding(.vertical, verticalPadding)
      .background {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .fill(DSColor.Background.groupedSecondary)
      }
      .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
  }
}

extension View {
  public func dsCellBackground(radius: CGFloat = DSRadius.r16, verticalPadding: CGFloat = DSSpacing.s16) -> some View {
    modifier(DSCellBackgroundModifier(cornerRadius: radius, verticalPadding: verticalPadding))
  }
}
