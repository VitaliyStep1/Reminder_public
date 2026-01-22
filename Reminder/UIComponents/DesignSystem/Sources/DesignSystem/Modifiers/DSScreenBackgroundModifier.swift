//
//  DSScreenBackgroundModifier.swift
//  DesignSystem
//
//  Created by Vitaliy Stepanenko on 13.11.2025.
//

import SwiftUI

public struct DSScreenBackgroundModifier: ViewModifier {
  
  public func body(content: Content) -> some View {
    content
      .background {
        LinearGradient(
          gradient: Gradient(colors: [DSColor.Background.grouped, DSColor.Background.secondary]),
          startPoint: .top,
          endPoint: .bottom
        )
        .ignoresSafeArea()
      }
  }
}

extension View {
  public func dsScreenBackground() -> some View {
    modifier(DSScreenBackgroundModifier())
  }
}
