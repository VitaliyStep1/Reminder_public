//
//  MainTabViewSelectionState.swift
//  MainTabView
//
//  Created by Vitaliy Stepanenko on 17.10.2025.
//

import Foundation

public class MainTabViewSelectionState: ObservableObject {
  @Published public var selection: MainTabViewSelectionEnum = .closest
  
  public init(selection: MainTabViewSelectionEnum) {
    self.selection = selection
  }
}
