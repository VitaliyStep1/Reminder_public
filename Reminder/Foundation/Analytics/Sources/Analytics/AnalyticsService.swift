//
//  AnalyticsService.swift
//  Analytics
//
//  Created by Vitaliy Stepanenko on 20.01.2026.
//

import Foundation
import AppsFlyerLib
import AnalyticsContracts

public final class AnalyticsService: AnalyticsServiceProtocol {
  public init() {}
  
  public func track(event: String) {
    track(event: event, values: nil)
  }

  public func track(event: String, values: [String: Any]?) {
    AppsFlyerLib.shared().logEvent(event, withValues: values)
  }
}
