//
//  EventTextField.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 09.11.2025.
//

import SwiftUI
import DesignSystem

struct EventTextField: View {
  let placeholder: LocalizedStringResource
  let isAutocorrectionDisabled: Bool
  @Binding var text: String

  init(
    placeholder: LocalizedStringResource,
    text: Binding<String>,
    isAutocorrectionDisabled: Bool = false
  ) {
    self.placeholder = placeholder
    _text = text
    self.isAutocorrectionDisabled = isAutocorrectionDisabled
  }
  
  var body: some View {
    let placeholderString = String(localized: placeholder)
    TextField(placeholderString, text: $text)
      .autocorrectionDisabled(isAutocorrectionDisabled)
      .textFieldStyle(DSMainTextFieldStyle(isTextNotEmpty: !text.isEmpty))
  }
}
