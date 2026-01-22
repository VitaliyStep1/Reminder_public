//
//  SplashScreenView.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 23.08.2025.
//

import SwiftUI
import DesignSystem

public struct SplashScreenView: View {
  @Binding var isSplashScreenVisible: Bool
  
  public init(isSplashScreenVisible: Binding<Bool>) {
    _isSplashScreenVisible = isSplashScreenVisible
  }
  
  public var body: some View {
    ZStack {
      DSColor.Background.accent.ignoresSafeArea(edges: .all)
      VStack(alignment: .center) {
        Image("SplashIcon", bundle: .module)
          .dsShadow(.r14AccentStrong)
        Text(Localize.splashTitle)
          .font(.dsTitleLarge)
          .foregroundStyle(DSColor.Text.white)
          .multilineTextAlignment(.center)
          .frame(maxWidth: .infinity)
          .dsShadow(.r14AccentStrong)
      }
    }.task {
      try? await Task.sleep(for: .seconds(2))
      self.isSplashScreenVisible = false
    }
  }
}
