//
//  AppConfiguration.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 23.08.2025.
//

import Foundation

public protocol AppConfigurationProtocol: Sendable {
  var isWithSplashScreen: Bool { get }
  var isWithBanner: Bool { get }
  var defaultDefaultRemindTime: (hour: Int, minute: Int, second: Int) { get }
  var supportEmail: String { get }
  var appstoreId: String { get }
  var privacyPolicyURL: URL? { get }
  var termsOfUseURL_en: URL? { get }
  var termsOfUseURL_uk: URL? { get }
  var notificationTitle_en: String { get }
  var notificationTitle_uk: String { get }
  var rateUsAfterEventsCreated1: Int { get }
  var rateUsAfterEventsCreated2: Int { get }
  var rateUsAfterEventsCreated3: Int { get }
  
  static var previewAppConfiguration: AppConfigurationProtocol { get }
}

public final class AppConfiguration: ObservableObject, AppConfigurationProtocol {
  public let isWithSplashScreen = true
  public let isWithBanner = true
  public let defaultDefaultRemindTime = (hour: 10, minute: 0, second: 0)
  public let supportEmail = ""
  public let appstoreId = ""
  public let privacyPolicyURL = URL(string: "")
  
  public var termsOfUseURL_en = URL(string: "")
  public var termsOfUseURL_uk = URL(string: "")

  public let notificationTitle_en = "Notification title"
  public let notificationTitle_uk = "Заголовок повідомлення"
  
  public let rateUsAfterEventsCreated1 = 15
  public let rateUsAfterEventsCreated2 = 40
  public let rateUsAfterEventsCreated3 = 70
  
  public init() { }
  
  @MainActor
  public static let previewAppConfiguration: AppConfigurationProtocol = AppConfiguration()
}
