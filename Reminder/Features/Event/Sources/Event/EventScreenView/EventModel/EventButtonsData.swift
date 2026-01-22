//
//  EventButtonsData.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 12.11.2025.
//

import Foundation

@MainActor
class EventButtonsData: ObservableObject {
  @Published public var isSaving: Bool
  @Published public var isDeleting: Bool
  
  @Published public var isDeleteButtonVisible: Bool
  @Published public var saveButtonTitle: String
  public var cancelButtonTitle: String
  public var deleteButtonTitle: String
  
  init(isSaving: Bool, isDeleting: Bool, isDeleteButtonVisible: Bool, saveButtonTitle: String, cancelButtonTitle: String, deleteButtonTitle: String) {
    self.isSaving = isSaving
    self.isDeleting = isDeleting
    self.isDeleteButtonVisible = isDeleteButtonVisible
    self.saveButtonTitle = saveButtonTitle
    self.cancelButtonTitle = cancelButtonTitle
    self.deleteButtonTitle = deleteButtonTitle
  }
}
