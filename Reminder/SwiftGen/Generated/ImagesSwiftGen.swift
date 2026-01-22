// 🤖 This file was code-generated. Do not edit!!!

import SwiftUI
import Foundation


/// Bundle resolver for assets (SPM or App target)
private let _assetsBundle: Bundle = {
  #if SWIFT_PACKAGE
  return Bundle.module
  #else
  final class _BundleToken {}
  return Bundle(for: _BundleToken.self)
  #endif
}()



// MARK: - Images
public extension Image {
      /// Image for `SomeBerry`
      static var someBerry: Image {
        Image("SomeBerry", bundle: _assetsBundle)
      }
}

// MARK: - Colors
public extension Color {
      /// Color for `AccentColor`
      static var accentColor: Color {
        Color("AccentColor", bundle: _assetsBundle)
      }
}

