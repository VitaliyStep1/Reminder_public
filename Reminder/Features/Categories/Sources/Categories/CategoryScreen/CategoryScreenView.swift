//
//  CategoryScreenView.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 25.08.2025.
//

import SwiftUI
import AdsUI
import DesignSystem

public struct CategoryScreenView: View {
  @StateObject var viewModel: CategoryViewModel
  @Environment(\.locale) private var locale

  public init(viewModel: CategoryViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    contentView
      .dsScreenPadding()
      .dsScreenBackground()
      .onAppear {
        viewModel.updateLocale(locale)
        viewModel.viewAppeared()
      }
      .task {
        viewModel.updateLocale(locale)
        await viewModel.viewTaskCalled()
      }
      .onChange(of: locale) { newLocale in
        viewModel.updateLocale(newLocale)
      }
      .navigationTitle(viewModel.navigationTitle)
      .navigationBarTitleDisplayMode(.inline)
      .alert(String(localized: Localize.agreementTitle.localed(locale)), isPresented: $viewModel.isAgreementAlertVisible) {
        Button(String(localized: Localize.agreementAcceptButtonTitle.localed(locale))) {
          viewModel.acceptAgreementTapped()
        }
        Button(String(localized: Localize.agreementCancelButtonTitle.localed(locale)), role: .cancel) {
          viewModel.cancelAgreementTapped()
        }
      } message: {
        Text(Localize.agreementMessage.localed(locale))
      }
      .dsErrorAlert(
        isPresented: $viewModel.isAlertVisible,
        message: viewModel.alertInfo.message,
        completion: viewModel.alertInfo.completion
      )
      .safeAreaInset(edge: .bottom) {
        if viewModel.isWithBanner {
          AnchoredAdaptiveBannerView(adUnitId: ReminderAdUnitId.categoryBanner)
            .padding(.top, DSSpacing.s12)
        }
      }
  }
}

private extension CategoryScreenView {
  @ViewBuilder
  var contentView: some View {
    VStack(spacing: DSSpacing.s20) {
      CategoryHeaderView(title: viewModel.headerTitle, subtitle: viewModel.headerSubTitle)

      switch viewModel.screenStateEnum {
      case .empty(let title):
        emptyStateView(title: title.localed(locale))
      case .withEvents(let events):
        withEventsView(events: events)
      }

      CategoryAddButton(systemImageName: "plus.circle.fill", title: Localize.addNewEventButtonTitle.localed(locale), action: viewModel.addButtonTapped)
    }
  }
  
  @ViewBuilder
  func emptyStateView(title: LocalizedStringResource) -> some View {
    Spacer()
    DSNoDataView(systemImageName: "calendar.badge.plus", title: title)
    Spacer()
  }
  
  func withEventsView(events: [CategoryEntity.Event]) -> some View {
    ScrollView {
      LazyVStack(spacing: DSSpacing.s2) {
        ForEach(events) { event in
          CategoryEventRowView(title: event.title, dateString: event.date, tapAction: {
            viewModel.eventTapped(eventId: event.id)
          })
        }
      }
      .padding(.vertical, DSSpacing.s4)
    }
    .scrollClipDisabled()
  }
}
