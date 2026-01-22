//
//  CategoryViewModel.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 25.08.2025.
//

import Combine
import Foundation
import NavigationContracts
import DomainContracts
import Domain
import DomainLocalization
import Event
import UserDefaultsStorage

@MainActor
public class CategoryViewModel: ObservableObject {
  let fetchEventsUseCase: FetchEventsUseCaseProtocol
  let fetchCategoryUseCase: FetchCategoryUseCaseProtocol
  let userDefaultsService: UserDefaultsServiceProtocol
  var categoryId: Identifier
  private var locale: Locale = .current
  let isWithBanner: Bool
  
  @Published var screenStateEnum: CategoryEntity.ScreenStateEnum
  
  private var events: [CategoryEntity.Event] = [] {
    didSet {
      updateScreenState()
    }
  }
  @Published var navigationTitle: String = "" {
    didSet {
      headerTitle = navigationTitle
    }
  }
  @Published var isAlertVisible: Bool = false
  @Published var isAgreementAlertVisible: Bool = false
  @Published var headerTitle: String = ""
  @Published var headerSubTitle: String = ""
  var router: any CreateRouterProtocol
  
  var alertInfo: ErrorAlertInfo = ErrorAlertInfo(message: "")
  
  var createEventViewTitle = ""
  var createEventViewDate = Date()
  var createEventViewComment = ""
  private let noEventsText = Localize.categoryNoEventsText
  
  private var cancellables: Set<AnyCancellable> = []
  
  public init(
    categoryId: Identifier,
    fetchEventsUseCase: FetchEventsUseCaseProtocol,
    fetchCategoryUseCase: FetchCategoryUseCaseProtocol,
    userDefaultsService: UserDefaultsServiceProtocol,
    router: any CreateRouterProtocol,
    isWithBanner: Bool
  ) {
    self.categoryId = categoryId
    self.fetchEventsUseCase = fetchEventsUseCase
    self.fetchCategoryUseCase = fetchCategoryUseCase
    self.userDefaultsService = userDefaultsService
    self.router = router
    self.isWithBanner = isWithBanner
    self.screenStateEnum = .empty(title: noEventsText.localed(locale))
    
    observeRouterUpdates()
  }
  
  func updateLocale(_ locale: Locale) {
    self.locale = locale
    updateScreenState()
  }
  
  func viewAppeared() {
  }
  
  func viewTaskCalled() async {
    await updateEventList()
    await updateNavigationTitle()
  }
  
  func addButtonTapped() {
    if userDefaultsService.isCategoryAgreementAccepted {
      showCreateEventView()
    } else {
      isAgreementAlertVisible = true
    }
  }
  
  func acceptAgreementTapped() {
    isAgreementAlertVisible = false
    userDefaultsService.isCategoryAgreementAccepted = true
    showCreateEventView()
  }
  
  func cancelAgreementTapped() {
    isAgreementAlertVisible = false
  }
  
  func eventTapped(eventId: Identifier) {
    showEditEventView(eventId: eventId)
  }
  
  func closeViewWasCalled() {
    router.popScreen()
  }
  
  private func showCreateEventView() {
    let eventScreenViewType = EventScreenViewType.create(categoryId: categoryId)
    router.pushScreen(.event(eventScreenViewType))
  }
  
  private func updateEventList() async {
    do {
      let events = try await fetchEventsUseCase.execute(categoryId: categoryId)
      let entityEvents: [CategoryEntity.Event] = events.map { event in
        let date = event.date.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year(.defaultDigits))
        return CategoryEntity.Event(id: event.id, title: event.title, date: date)
      }
      
      self.events = entityEvents
    } catch {
      showEventsWereNotFetchedAlert()
    }
  }
  
  private func updateNavigationTitle() async {
    let category = try? await fetchCategoryUseCase.execute(categoryId: categoryId)
    let categoryTitle = category?.title ?? ""
    
    navigationTitle = CategoryLocalizationManager.shared.localize(categoryTitle: categoryTitle, locale: locale)
  }
  
  private func showEditEventView(eventId: Identifier) {
    let eventScreenViewType = EventScreenViewType.edit(eventId: eventId, source: .direct)
    router.pushScreen(.event(eventScreenViewType))
  }
  
  private func showEventsWereNotFetchedAlert() {
    alertInfo = ErrorAlertInfo(message: String(localized: Localize.eventsNotFetchedAlert.localed(locale)))
    isAlertVisible = true
  }
  
  private func observeRouterUpdates() {
    router.objectWillChange
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else { return }
      }
      .store(in: &cancellables)
  }
  
  private func updateScreenState() {
    let eventsTitle = events.count == 1 ? String(localized: Localize.eventSingular.localed(locale)) : String(localized: Localize.eventsPlural.localed(locale))
    headerSubTitle = String(format: String(localized: Localize.addedEventsFormat.localed(locale)), events.count, eventsTitle)
    
    if events.isEmpty {
      screenStateEnum = .empty(title: noEventsText.localed(locale))
    } else {
      screenStateEnum = .withEvents(events: events)
    }
  }
}
