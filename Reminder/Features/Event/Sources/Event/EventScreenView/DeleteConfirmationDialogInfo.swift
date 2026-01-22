//
//  DeleteConfirmationDialogInfo.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 04.10.2025.
//

public struct DeleteConfirmationDialogInfo {
  let title: String
  let message: String
  var deleteButtonHandler: () -> Void
  
  public init(title: String, message: String, deleteButtonHandler: @escaping () -> Void) {
    self.title = title
    self.message = message
    self.deleteButtonHandler = deleteButtonHandler
  }
}
