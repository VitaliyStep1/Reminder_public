//
//  SplashScreenViewFactory.swift
//  Start
//
//  Created by Vitaliy Stepanenko on 03.12.2025.
//

import SwiftUI

public protocol SplashScreenViewFactoryProtocol {
  func makeSplashScreen(isVisible: Binding<Bool>) -> AnyView
}

public final class SplashScreenViewFactory: SplashScreenViewFactoryProtocol {
  public init() {}
  
  public func makeSplashScreen(isVisible: Binding<Bool>) -> AnyView {
    AnyView(SplashScreenView(isSplashScreenVisible: isVisible))
  }
}
