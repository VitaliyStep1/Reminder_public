//
//  LocalizedStringResource.swift
//  Language
//
//  Created by Vitaliy Stepanenko on 07.12.2025.
//

import Foundation

public extension LocalizedStringResource {
  public func localed(_ locale: Locale) -> LocalizedStringResource {
    print("localed locale: \(locale.identifier)")
    var resource = self
    resource.locale = locale
    return resource
  }
}
