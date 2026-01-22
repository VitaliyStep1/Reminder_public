//
//  DSSpacing.swift
//  DesignSystem
//
//  Created by Vitaliy Stepanenko on 25.11.2025.
//

import SwiftUI

public enum DSSpacing {
  public static let s2: CGFloat = 2
  public static let s4: CGFloat = 4
  public static let s6: CGFloat = 6
  public static let s8: CGFloat = 8
  public static let s10: CGFloat = 10
  public static let s12: CGFloat = 12
  public static let s14: CGFloat = 14
  public static let s16: CGFloat = 16
  public static let s20: CGFloat = 20
  public static let s24: CGFloat = 24
  public static let s30: CGFloat = 30
  public static let s32: CGFloat = 32

  public static let sMinus8: CGFloat = -8
  
  public enum Screen {
    public static let horizontal = DSSpacing.s16
    public static let top = DSSpacing.s8
    public static let bottom = DSSpacing.s2
  }
}

