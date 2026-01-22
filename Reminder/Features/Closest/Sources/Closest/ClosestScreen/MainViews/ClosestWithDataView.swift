//
//  ClosestWithDataView.swift
//  Closest
//
//  Created by Vitaliy Stepanenko on 18.12.2025.
//

import SwiftUI
import DesignSystem

struct ClosestWithDataView: View {
  let rowTypes: [ClosestEntity.RowTypeEnum]
  let eventDateStringProvider: (ClosestEntity.FutureEvent) -> String
  let eventTapAction: (ClosestEntity.FutureEvent) -> Void
  @State private var collapsedMonths: Set<String> = []

  private struct RowItem: Identifiable {
    let id: String
    let rowType: ClosestEntity.RowTypeEnum
    let monthId: String?
  }

  private var rowItems: [RowItem] {
    var currentMonthId: String?

    return rowTypes.map { rowType in
      switch rowType {
      case .month:
        currentMonthId = rowType.id
        return RowItem(id: rowType.id, rowType: rowType, monthId: currentMonthId)
      case .event:
        return RowItem(id: rowType.id, rowType: rowType, monthId: currentMonthId)
      }
    }
  }

  var body: some View {
    ScrollView {
      LazyVStack(spacing: DSSpacing.s2) {
        ForEach(rowItems) { rowItem in
          switch rowItem.rowType {
          case .month(let month):
            ClosestMonthView(
              monthIndex: month.monthIndex,
              year: month.year,
              eventsCount: month.eventsCount,
              isCollapsed: collapsedMonths.contains(rowItem.monthId ?? ""),
              tapAction: { toggleCollapse(for: rowItem.monthId) }
            )
          case .event(let event):
            if !isCollapsed(rowItem.monthId) {
              ClosestEventView(
                eventTitle: event.originalEvent.title,
                dateString: eventDateStringProvider(event),
                iconStateEnum: event.remindIconStateEnum,
                tapAction: {
                  eventTapAction(event)
                }
              )
            }
          }
        }
      }
      .padding(.vertical, DSSpacing.s4)
    }
    .scrollClipDisabled()
  }

  private func isCollapsed(_ monthId: String?) -> Bool {
    guard let monthId else { return false }
    return collapsedMonths.contains(monthId)
  }

  private func toggleCollapse(for monthId: String?) {
    guard let monthId else { return }
    if collapsedMonths.contains(monthId) {
      collapsedMonths.remove(monthId)
    } else {
      collapsedMonths.insert(monthId)
    }
  }
}
