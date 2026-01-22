//
//  SettingsScreenView.swift
//  SettingsTab
//
//  Created by Vitaliy Stepanenko on 24.10.2025.
//

import SwiftUI
import DesignSystem

public struct SettingsScreenView: View {
  @StateObject var viewModel: SettingsViewModel
  @Environment(\.locale) private var locale
  @Environment(\.openURL) private var openURL

  private let optionCellHeight: CGFloat = 56
  
  public init(viewModel: SettingsViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    NavigationStack {
      contentView
        .dsScreenPadding()
        .dsScreenBackground()
        .navigationTitle(
          String(localized: Localize.settingsTitle.localed(locale))
        )
    }
  }
  
  var contentView: some View {
    ScrollView {
      VStack {
        dateOptionView
        languageOptionView(languageOptionViewStore: viewModel.languageOptionViewStore)
        rateUsOptionView
        privacyPolicyOptionView
        termsOfUseOptionView
        supportOptionView
        Spacer()
      }
    }
    .scrollClipDisabled()
  }
  
  var dateOptionView: some View {
    optionCell {
      DatePicker(
        selection: $viewModel.defaultRemindTimeDate,
        displayedComponents: .hourAndMinute
      ) {
        Text(Localize.defaultRemindTimeLabel)
      }
      .datePickerStyle(.compact)
    }
    .dsShadow(.r6Light)
  }
  
  func languageOptionView(@Bindable languageOptionViewStore: SettingsLanguageOptionViewStore) -> some View {
    optionCell {
      HStack {
        Text(Localize.language_column)
        Spacer()
        Picker(selection: $languageOptionViewStore.selectedLanguage) {
          ForEach(languageOptionViewStore.languages) { language in
            Text(language.title).tag(language)
          }
        } label: {
          Text(Localize.language)
        }
        .pickerStyle(.menu)
        .onChange(of: languageOptionViewStore.selectedLanguage) { selectedLanguage in
          languageOptionViewStore.selectedLanguageChangedHandler(selectedLanguage)
        }
      }
    }
    .dsShadow(.r4Heavy)
  }

  var supportOptionView: some View {
    Button {
      openSupportEmail()
    } label: {
      VStack(alignment: .leading, spacing: 4) {
        Text(Localize.supportPrompt)
        HStack {
          Text(Localize.support)
          Spacer()
          Text(viewModel.supportEmail)
            .foregroundStyle(.secondary)
        }
      }
      .dsCellBackground()
    }
    .buttonStyle(.plain)
    .dsShadow(.r4Heavy)
  }

  var rateUsOptionView: some View {
    Button {
      openAppStore()
    } label: {
      optionCell {
        HStack {
          Text(Localize.rateUs)
          Spacer()
          Image(systemName: "chevron.right")
            .foregroundStyle(.secondary)
        }
      }
    }
    .buttonStyle(.plain)
    .dsShadow(.r4Heavy)
  }

  var privacyPolicyOptionView: some View {
    Button {
      openPrivacyPolicy()
    } label: {
      optionCell {
        HStack {
          Text(Localize.privacyPolicy)
          Spacer()
          Image(systemName: "chevron.right")
            .foregroundStyle(.secondary)
        }
      }
    }
    .buttonStyle(.plain)
    .dsShadow(.r4Heavy)
  }

  var termsOfUseOptionView: some View {
    Button {
      openTermsOfUse()
    } label: {
      optionCell {
        HStack {
          Text(Localize.termOfUse)
          Spacer()
          Image(systemName: "chevron.right")
            .foregroundStyle(.secondary)
        }
      }
    }
    .buttonStyle(.plain)
    .dsShadow(.r4Heavy)
  }

  private func optionCell<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    content()
      .dsCellBackground()
      .frame(height: optionCellHeight)
      .clipShape(RoundedRectangle(cornerRadius: DSRadius.r16, style: .continuous))
  }

  private func openSupportEmail() {
    guard let supportEmailURL = viewModel.supportEmailURL else {
      return
    }

    openURL(supportEmailURL)
  }

  private func openAppStore() {
    guard let appStoreURL = viewModel.appStoreURL else {
      return
    }

    openURL(appStoreURL)
  }

  private func openPrivacyPolicy() {
    guard let privacyPolicyURL = viewModel.privacyPolicyURL else {
      return
    }

    openURL(privacyPolicyURL)
  }

  private func openTermsOfUse() {
    guard let termsOfUseURL = viewModel.termsOfUseURL else {
      return
    }

    openURL(termsOfUseURL)
  }
}
