//
//  CategoriesViewModel.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 23.08.2025.
//

import SwiftUI
import Combine
import DomainContracts
import NavigationContracts
import Domain
import DomainLocalization

@MainActor
public class CategoriesViewModel: ObservableObject {

  let fetchAllCategoriesUseCase: FetchAllCategoriesUseCaseProtocol
  let isWithBanner: Bool

  @Published var screenStateEnum: CategoriesEntity.ScreenStateEnum
  var navigationTitle: String = String(localized: Localize.categoriesNavigationTitle)
  
  public weak var coordinator: (any CreateCoordinatorProtocol)? {
    didSet {
      subscribeToRouterChanges()
    }
  }
  private var cancellables: Set<AnyCancellable> = []
  
  private let noCategoriesText = Localize.noCategoriesText

  var routerPath: NavigationPath {
    get { coordinator?.router.path ?? NavigationPath() }
    set { coordinator?.router.path = newValue }
  }
  
  public init(fetchAllCategoriesUseCase: FetchAllCategoriesUseCaseProtocol,
              coordinator: (any CreateCoordinatorProtocol),
              isWithBanner: Bool) {
    self.fetchAllCategoriesUseCase = fetchAllCategoriesUseCase
    self.coordinator = coordinator
    self.isWithBanner = isWithBanner

    screenStateEnum = .empty(title: noCategoriesText)

    subscribeToRouterChanges()
  }
  
  func taskWasCalled() async {
    await loadCategories()
  }
  
  func categoryRowWasClicked(_ category: CategoriesEntity.Category) {
    coordinator?.categoriesScreenCategoryWasClicked(categoryId: category.id)
  }
  
  func loadCategories() async {
    let allCategories = (try? await fetchAllCategoriesUseCase.execute()) ?? []
    let categories = allCategories.map {
      return CategoriesEntity.Category(id: $0.id, title: $0.title, eventsAmount: $0.eventsAmount)
    }

    self.screenStateEnum = categories.isEmpty
    ? .empty(title: self.noCategoriesText)
    : .withCategories(categories: categories)
  }
  
  func takeEventsAmountText(eventsAmount: Int, locale: Locale) -> String {
    let singular = String(localized: Localize.eventSingular.localed(locale))
    let plural = String(localized: Localize.eventsPlural.localed(locale))
    let pluralMany = String(localized: Localize.eventsPluralMany.localed(locale))
    let title: String
    if locale.languageCode == "uk" {
      let mod10 = eventsAmount % 10
      let mod100 = eventsAmount % 100
      if mod10 == 1 && mod100 != 11 {
        title = singular
      } else if (2...4).contains(mod10) && !(12...14).contains(mod100) {
        title = plural
      } else {
        title = pluralMany
      }
    } else {
      title = eventsAmount == 1 ? singular : plural
    }
    return "\(eventsAmount) \(title)"
  }
  
  func takeLocalizedCategoryTitle(categoryTitle: String, locale: Locale) -> String {
    let title = CategoryLocalizationManager.shared.localize(categoryTitle: categoryTitle, locale: locale)
    return title
  }

  private func subscribeToRouterChanges() {
    cancellables.removeAll()

    coordinator?.router.objectWillChange
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.objectWillChange.send()
      }
      .store(in: &cancellables)
  }
}
