//
//  AlertInfo.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 03.10.2025.
//

public struct ErrorAlertInfo {
  let message: String
  var completion: (() -> Void)?
  
  public init(message: String) {
    self.message = message
  }
  
  public init(message: String, completion: (() -> Void)?) {
    self.message = message
    self.completion = completion
  }
}
