//
//  ClosestViewModel.swift
//  Reminder
//
//  Created by Vitaliy Stepanenko on 23.08.2025.
//

import Foundation
import Combine
import MainTabViewContracts
import DomainContracts
import SwiftUI

@MainActor
public class ClosestViewModel: ObservableObject {
  private let fetchAllEventsUseCase: FetchAllFutureEventsUseCaseProtocol
  private let fetchAllCategoriesUseCase: FetchAllCategoriesUseCaseProtocol
  private let fetchScheduledNotificationsIdsUseCase: FetchScheduledNotificationsIdsUseCaseProtocol
  let mainTabViewSelectionState: MainTabViewSelectionState
  let isWithBanner: Bool
  
  @Published var screenStateEnum: ClosestEntity.ScreenStateEnum
  @Published var allEvents: [ClosestEntity.FutureEvent] = []
  
  let filterViewDataSource: ClosestFilterViewDataSource
  
  private let noEventsText = Localize.closestNoEventsText
  
  private let firstFilterItem = ClosestEntity.FilterItem(id: UUID(), title: "All", filterItemEnum: .all)
  
  public weak var coordinator: (any ClosestCoordinatorProtocol)? {
    didSet {
      subscribeToRouterChanges()
    }
  }
  
  private var cancellables: Set<AnyCancellable> = []
  private var coordinatorCancellables: Set<AnyCancellable> = []
  
  var routerPath: NavigationPath {
    get { coordinator?.router.path ?? NavigationPath() }
    set { coordinator?.router.path = newValue }
  }
  
  public init(
    fetchAllEventsUseCase: FetchAllFutureEventsUseCaseProtocol,
    fetchAllCategoriesUseCase: FetchAllCategoriesUseCaseProtocol,
    fetchScheduledNotificationsIdsUseCase: FetchScheduledNotificationsIdsUseCaseProtocol,
    mainTabViewSelectionState: MainTabViewSelectionState,
    coordinator: (any ClosestCoordinatorProtocol),
    isWithBanner: Bool) {
      self.fetchAllEventsUseCase = fetchAllEventsUseCase
      self.fetchAllCategoriesUseCase = fetchAllCategoriesUseCase
      self.fetchScheduledNotificationsIdsUseCase = fetchScheduledNotificationsIdsUseCase
      self.mainTabViewSelectionState = mainTabViewSelectionState
      self.coordinator = coordinator
      self.isWithBanner = isWithBanner
      
      screenStateEnum = .empty(title: noEventsText)
      let initialFilterItems = [self.firstFilterItem]
      filterViewDataSource = ClosestFilterViewDataSource(filterItems: initialFilterItems, selectedFilterItemId: initialFilterItems[0].id)
      
      subscribeToRouterChanges()
      subscribe()
    }
  
  func taskWasCalled() async {
    await loadEvents()
    await loadFilters()
  }
  
  func createEventClicked() {
    showCategoriesTab()
  }
  
  func takeEventDateText(for date: Date, locale: Locale) -> String {
    let formatter = DateFormatter()
    formatter.locale = locale
    
    var calendar = Calendar.current
    calendar.locale = locale
    
    if calendar.isDateInToday(date) {
      return String(localized: Localize.closestTodayTitle.localed(locale))
    }
    
    if calendar.isDateInTomorrow(date) {
      return String(localized: Localize.closestTomorrowTitle.localed(locale))
    }
    
    let eventYear = calendar.component(.year, from: date)
    let currentYear = calendar.component(.year, from: Date())
    
    if eventYear == currentYear {
      formatter.setLocalizedDateFormatFromTemplate("MMM d")
    } else {
      formatter.setLocalizedDateFormatFromTemplate("MMM d, yyyy")
    }
    
    return formatter.string(from: date)
  }
  
  private func subscribe() {
    Publishers.CombineLatest(
      $allEvents.removeDuplicates(),
      filterViewDataSource.$selectedFilterItemId.removeDuplicates()
    )
    .sink { [weak self] allEvents, selectedFilterItemId in
      self?.updateScreenState(allEvents: allEvents, selectedFilterItemId: selectedFilterItemId)
    }
    .store(in: &cancellables)
  }
  
  private func updateScreenState(allEvents: [ClosestEntity.FutureEvent], selectedFilterItemId: UUID) {
    let filteredEvents = applyFilter(allEvents: allEvents, selectedFilterItemId: selectedFilterItemId)
    
    if filteredEvents.isEmpty {
      screenStateEnum = .empty(title: noEventsText)
    } else {
      let rowTypes = makeRowTypes(from: filteredEvents)
      screenStateEnum = .withData(rowTypes: rowTypes)
    }
  }
  
  private func applyFilter(allEvents: [ClosestEntity.FutureEvent], selectedFilterItemId: UUID) -> [ClosestEntity.FutureEvent] {
    if selectedFilterItemId == firstFilterItem.id {
      return allEvents
    }
    if let filterItem = filterViewDataSource.filterItems.first(where: { $0.id == selectedFilterItemId }) {
      let filterItemEnum = filterItem.filterItemEnum
      if case let .category(category) = filterItemEnum {
        
        let filteredEvents: [ClosestEntity.FutureEvent] = allEvents.filter { event in
          event.originalEvent.categoryId == category.id
        }
        return filteredEvents
      }
    }
    return allEvents
  }
  
  private func showCategoriesTab() {
    mainTabViewSelectionState.selection = .create
  }
  
  private func loadEvents() async {
    let events = (try? await fetchAllEventsUseCase.execute()) ?? []
    let scheduledNotificationsIds = Set(await fetchScheduledNotificationsIdsUseCase.execute())
    let allEvents: [ClosestEntity.FutureEvent] = events.map {
      let remindIconStateEnum = self.takeRemindIconStateEnum(event: $0, scheduledNotificationsIds: scheduledNotificationsIds)
      let event = ClosestEntity.Event(id: $0.originalEvent.id, title: $0.originalEvent.title, date: $0.originalEvent.date, categoryId: $0.originalEvent.categoryId)
      let futureEvent = ClosestEntity.FutureEvent(originalEvent: event, future1Date: $0.future1Date, future2Date: $0.future2Date, remindIconStateEnum: remindIconStateEnum)
      return futureEvent
    }.sorted { $0.future1Date < $1.future1Date }
    
    self.allEvents = allEvents
  }
  
  func takeRemindIconStateEnum(event: FutureEvent, scheduledNotificationsIds: Set<UUID>) -> ClosestEntity.RemindIconStateEnum {
    if event.originalEvent.remindBeforeDate == nil && event.originalEvent.remindOnDayDate == nil {
      return ClosestEntity.RemindIconStateEnum.noReminds
    }
    let onDayScheduled = scheduledNotificationsIds.contains(event.originalEvent.onDayLNEventId)
    let beforeScheduled = scheduledNotificationsIds.contains(event.originalEvent.beforeLNEventId)
    
    if event.originalEvent.remindBeforeDate != nil && event.originalEvent.remindOnDayDate != nil {
      if onDayScheduled && beforeScheduled {
        return ClosestEntity.RemindIconStateEnum.scheduledReminds
      }
      if onDayScheduled || beforeScheduled {
        return ClosestEntity.RemindIconStateEnum.someRemindsAreScheduledAndSomeAreNot
      }
    } else {
      if onDayScheduled || beforeScheduled {
        return ClosestEntity.RemindIconStateEnum.scheduledReminds
      }
    }
    
    
    return ClosestEntity.RemindIconStateEnum.notScheduledReminds
  }
  
  private func loadFilters() async {
    let allCategories = (try? await fetchAllCategoriesUseCase.execute()) ?? []
    let filters: [ClosestEntity.FilterItem] = allCategories.map { category in
      let closestCategory = ClosestEntity.Category(id: category.id, title: category.title)
      return .init(
        id: category.id,
        title: category.title,
        filterItemEnum: .category(closestCategory)
      )
    }
    
    let availableFilters = [firstFilterItem] + filters
    filterViewDataSource.filterItems = availableFilters
    let currentSelectedId = filterViewDataSource.selectedFilterItemId
    let stillExists = availableFilters.contains(where: { $0.id == currentSelectedId })
    filterViewDataSource.selectedFilterItemId = stillExists ? currentSelectedId : firstFilterItem.id
  }
  
  func filterItemTapped(id: UUID) {
    filterViewDataSource.selectedFilterItemId = id
  }
  
  private func makeRowTypes(from events: [ClosestEntity.FutureEvent]) -> [ClosestEntity.RowTypeEnum] {
    let calendar = Calendar.current
    
    var eventsCountForMonth: [String: Int] = [:]
    
    for event in events {
      let components = calendar.dateComponents([.year, .month], from: event.future1Date)
      guard let monthIndex = components.month, let year = components.year else { continue }
      let key = "\(year)-\(monthIndex)"
      eventsCountForMonth[key, default: 0] += 1
    }
    
    var rowTypes: [ClosestEntity.RowTypeEnum] = []
    var currentMonth: (year: Int, month: Int)?
    
    for event in events {
      let components = calendar.dateComponents([.year, .month], from: event.future1Date)
      let monthIndex = components.month ?? 0
      let year = components.year ?? 0
      let key = "\(year)-\(monthIndex)"
      let eventsCount = eventsCountForMonth[key] ?? 0
      
      if currentMonth?.year != year || currentMonth?.month != monthIndex {
        currentMonth = (year: year, month: monthIndex)
        let month = ClosestEntity.Month(
          monthIndex: monthIndex,
          year: year,
          eventsCount: eventsCount
        )
        rowTypes.append(.month(month: month))
      }
      
      rowTypes.append(.event(event: event))
    }
    
    return rowTypes
  }
  
  func eventTapped(event: ClosestEntity.FutureEvent) {
    let eventId = event.originalEvent.id
    coordinator?.pushScreen(.event(eventId))
  }
  
  private func subscribeToRouterChanges() {
    coordinatorCancellables.removeAll()
    
    coordinator?.router.objectWillChange
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.objectWillChange.send()
      }
      .store(in: &coordinatorCancellables)
  }
}
