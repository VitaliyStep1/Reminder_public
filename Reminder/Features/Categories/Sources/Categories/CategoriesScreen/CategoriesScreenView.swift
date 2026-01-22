//
//  CategoriesScreenView.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 23.08.2025.
//

import SwiftUI
import DesignSystem
import AdsUI
import NavigationContracts
import Domain

public struct CategoriesScreenView: View {
  @StateObject var viewModel: CategoriesViewModel
  @Environment(\.locale) private var locale
  
  public init(viewModel: CategoriesViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    NavigationStack(path: routerPathBinding) {
      contentView
        .frame(maxWidth: .infinity)
        .dsScreenPadding()
        .dsScreenBackground()
        .task {
          await viewModel.taskWasCalled()
        }
        .navigationTitle(
          String(localized: Localize.categoriesNavigationTitle.localed(locale))
        )
        .navigationDestination(for: CreateRoute.self) { route in
          destinationView(for: route)
        }
        .safeAreaInset(edge: .bottom) {
          if viewModel.isWithBanner {
            AnchoredAdaptiveBannerView(adUnitId: ReminderAdUnitId.categoriesBanner)
              .padding(.top, DSSpacing.s12)
          }
        }
    }
  }
}

private extension CategoriesScreenView {
  var routerPathBinding: Binding<NavigationPath> {
    Binding(
      get: { viewModel.routerPath },
      set: { viewModel.routerPath = $0 }
    )
  }
  
  @ViewBuilder
  var contentView: some View {
    switch viewModel.screenStateEnum {
    case .empty(let title):
      emptyStateView(title: title)
    case .withCategories(let categories):
      categoriesView(categories: categories)
    }
  }
  
  private func categoriesView(categories: [CategoriesEntity.Category]) -> some View {
    ScrollView {
      LazyVStack(spacing: DSSpacing.s14) {
        ForEach(categories) { category in
          CategoriesCategoryRowView(
            title: viewModel.takeLocalizedCategoryTitle(categoryTitle: category.title, locale: locale),
            eventsAmountText: viewModel.takeEventsAmountText(eventsAmount: category.eventsAmount, locale: locale),
            tapAction: {
              viewModel.categoryRowWasClicked(category)
            })
        }
      }
      .padding(.vertical, DSSpacing.s4)
    }
    .scrollClipDisabled()
  }
  
  private func emptyStateView(title: LocalizedStringResource) -> some View {
    VStack {
      Spacer()
      DSNoDataView(systemImageName: "square.grid.2x2", title: title)
      Spacer()
    }
  }
  
  @ViewBuilder
  func destinationView(for route: CreateRoute) -> some View {
    if let coordinator = viewModel.coordinator {
      coordinator.destination(for: route)
    } else {
      EmptyView()
    }
  }
}
