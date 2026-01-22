//
//  Untitled.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 05.10.2025.
//

import SwiftUI
import DomainContracts
import Event

public enum CreateRoute: Hashable {
  case category(Identifier)
  case event(EventScreenViewType)
}
