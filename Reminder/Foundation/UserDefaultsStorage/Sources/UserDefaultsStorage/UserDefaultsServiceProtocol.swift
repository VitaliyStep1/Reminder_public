//
//  UserDefaultsServiceProtocol.swift
//  UserDefaultsStorage
//
//  Created by Vitaliy Stepanenko on 24.10.2025.
//

import Foundation

public protocol UserDefaultsServiceProtocol: AnyObject, Sendable {
  var defaultRemindTimeDate: Date? { get set }
  var settingsLanguageId: String? { get set }
  var lastNotificationsUpdateDate: Date? { get set }
  var eventCreatedCount: Int { get set }
  var lastRateRequestEventCount: Int { get set }
  var isCategoryAgreementAccepted: Bool { get set }
}
