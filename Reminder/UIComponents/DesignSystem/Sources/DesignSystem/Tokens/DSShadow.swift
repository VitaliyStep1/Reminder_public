import SwiftUI

public struct DSShadow {
  public let color: Color
  public let radius: CGFloat
  public let x: CGFloat
  public let y: CGFloat

  public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
    self.color = color
    self.radius = radius
    self.x = x
    self.y = y
  }
}

public extension DSShadow {
  static let r2ExtraLight = DSShadow(color: DSColor.Shadow.blackO_05, radius: 2, x: 0, y: 1)
  static let r4Light = DSShadow(color: DSColor.Shadow.blackO_06, radius: 4, x: 0, y: 3)
  static let r4Medium = DSShadow(color: DSColor.Shadow.blackO_08, radius: 4, x: 0, y: 3)
  static let r4Heavy = DSShadow(color: DSColor.Shadow.blackO_1, radius: 4, x: 0, y: 3)
  static let r6Light = DSShadow(color: DSColor.Shadow.blackO_06, radius: 6, x: 0, y: 4)
  static let r8Medium = DSShadow(color: DSColor.Shadow.blackO_08, radius: 8, x: 0, y: 6)
  static let r12Heavy = DSShadow(color: DSColor.Shadow.blackO_1, radius: 12, x: 0, y: 10)
  
  static let r10AccentSoft = DSShadow(color: DSColor.Shadow.accentO_25, radius: 10, x: 0, y: 6)
  static let r14AccentStrong = DSShadow(color: DSColor.Shadow.accentO_3, radius: 14, x: 0, y: 10)
  static let r12Category = DSShadow(color: DSColor.Shadow.blueO_3, radius: 12, x: 0, y: 8)
  static let r10Danger = DSShadow(color: DSColor.Shadow.redO_2, radius: 10, x: 0, y: 8)
}

public extension View {
  func dsShadow(_ dsShadow: DSShadow) -> some View {
    shadow(color: dsShadow.color, radius: dsShadow.radius, x: dsShadow.x, y: dsShadow.y)
  }
}
