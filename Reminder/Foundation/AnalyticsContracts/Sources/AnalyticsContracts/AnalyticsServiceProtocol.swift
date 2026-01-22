//
//  AnalyticsServiceProtocol.swift
//  AnalyticsContracts
//
//  Created by Vitaliy Stepanenko on 20.01.2026.
//

import Foundation

public protocol AnalyticsServiceProtocol {
  func track(event: String)
  func track(event: String, values: [String: Any]?)
}
