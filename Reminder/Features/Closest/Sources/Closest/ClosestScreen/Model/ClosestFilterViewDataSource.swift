//
//  ClosestFilterViewDataSource.swift
//  Closest
//
//  Created by Vitaliy Stepanenko on 18.12.2025.
//

import Foundation

class ClosestFilterViewDataSource: ObservableObject {
  @Published var filterItems: [ClosestEntity.FilterItem]
  @Published var selectedFilterItemId: UUID
  
  init(filterItems: [ClosestEntity.FilterItem], selectedFilterItemId: UUID) {
    self.filterItems = filterItems
    self.selectedFilterItemId = selectedFilterItemId
  }
}
