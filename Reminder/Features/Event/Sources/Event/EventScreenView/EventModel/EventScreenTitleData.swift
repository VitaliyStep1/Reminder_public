//
//  EventScreenTitleData.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 12.11.2025.
//

import Foundation

@MainActor
class EventScreenTitleData: ObservableObject {
  @Published var screenTitle: LocalizedStringResource
  
  init(screenTitle: LocalizedStringResource) {
    self.screenTitle = screenTitle
  }
}
