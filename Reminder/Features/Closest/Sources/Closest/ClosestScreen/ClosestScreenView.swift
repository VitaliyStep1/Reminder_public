//
//  ClosestScreenView.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 23.08.2025.
//

import Foundation
import SwiftUI
import AdsUI
import DesignSystem
import Language
import DomainContracts
import Event

public struct ClosestScreenView: View {
  @StateObject var viewModel: ClosestViewModel
  @Environment(\.locale) private var locale
  private let eventCoordinator: EventCoordinatorProtocol
  
  public init(viewModel: ClosestViewModel, eventCoordinator: EventCoordinatorProtocol) {
    _viewModel = StateObject(wrappedValue: viewModel)
    self.eventCoordinator = eventCoordinator
  }
  
  public var body: some View {
    return NavigationStack(path: routerPathBinding) {
      VStack {
        contentView
        if viewModel.isWithBanner {
          AnchoredAdaptiveBannerView(adUnitId: ReminderAdUnitId.closestBanner)
            .padding(.top, 0)
            .padding(.bottom, DSSpacing.s4)
        }
      }
      
      .dsScreenPadding()
      .dsScreenBackground()
      .task {
        await viewModel.taskWasCalled()
      }
      .navigationTitle(
        String(localized: Localize.closestScreenTitle.localed(locale))
      )
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            viewModel.createEventClicked()
          } label: {
            Image(systemName: "plus.circle.fill")
              .font(DSFont.bodySemibold())
              .foregroundStyle(DSColor.Foreground.blue)
          }
          
        }
      }
      .navigationDestination(for: ClosestRoute.self) { route in
        destinationView(for: route)
      }
    }
  }
  
  @ViewBuilder
  var contentView: some View {
    VStack {
      ClosestFilterView(filterViewDataSource: viewModel.filterViewDataSource, tapAction: viewModel.filterItemTapped)
      switch viewModel.screenStateEnum {
      case .empty(let title):
        ClosestEmptyStateView(noEventsText: title, createEventButtonAction: viewModel.createEventClicked)
      case .withData(let rowTypes):
        ClosestWithDataView(
          rowTypes: rowTypes,
          eventDateStringProvider: { event in
            viewModel.takeEventDateText(for: event.future1Date, locale: locale)
          },
          eventTapAction: { event in
            self.viewModel.eventTapped(event: event)
          }
        )
      }
    }
  }
}

private extension ClosestScreenView {
  var routerPathBinding: Binding<NavigationPath> {
    Binding(
      get: { viewModel.routerPath },
      set: { viewModel.routerPath = $0 }
    )
  }
  
  @ViewBuilder
  func destinationView(for route: ClosestRoute) -> some View {
    if let coordinator = viewModel.coordinator {
      coordinator.destination(for: route)
    } else {
      EmptyView()
    }
  }
}
