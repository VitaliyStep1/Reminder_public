//
//  UserDefaultsService.swift
//  UserDefaultsStorage
//
//  Created by Vitaliy Stepanenko on 24.10.2025.
//

import Foundation

public final class UserDefaultsService: UserDefaultsServiceProtocol {
  public init() {}
  
  private func object(_ key: UserDefaultsKeyEnum) -> Any? {
    let object = UserDefaults.standard.object(forKey: key.rawValue)
    return object
  }
  
  private func set(_ value: Any?, key: UserDefaultsKeyEnum) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
  }
  
  public var defaultRemindTimeDate: Date? {
    get { object(.defaultRemindTimeDate) as? Date }
    set { set(newValue, key: .defaultRemindTimeDate) }
  }
  
  public var settingsLanguageId: String? {
    get { object(.settingsLanguageId) as? String }
    set { set(newValue, key: .settingsLanguageId) }
  }

  public var lastNotificationsUpdateDate: Date? {
    get { object(.lastNotificationsUpdateDate) as? Date }
    set { set(newValue, key: .lastNotificationsUpdateDate) }
  }

  public var eventCreatedCount: Int {
    get { object(.eventCreatedCount) as? Int ?? 0 }
    set { set(newValue, key: .eventCreatedCount) }
  }

  public var lastRateRequestEventCount: Int {
    get { object(.lastRateRequestEventCount) as? Int ?? 0 }
    set { set(newValue, key: .lastRateRequestEventCount) }
  }

  public var isCategoryAgreementAccepted: Bool {
    get { object(.isCategoryAgreementAccepted) as? Bool ?? false }
    set { set(newValue, key: .isCategoryAgreementAccepted) }
  }
}
