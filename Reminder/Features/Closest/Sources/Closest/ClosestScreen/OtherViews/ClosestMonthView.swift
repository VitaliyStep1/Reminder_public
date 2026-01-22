//
//  ClosestMonthView.swift
//  Closest
//
//  Created by Vitaliy Stepanenko on 21.12.2025.
//

import SwiftUI
import DesignSystem
import Language

struct ClosestMonthView: View {
  @Environment(\.calendar) private var calendar
  @Environment(\.locale) private var locale

  let monthIndex: Int
  let year: Int
  let eventsCount: Int
  let isCollapsed: Bool
  let tapAction: () -> Void

  private var monthTitle: String {
    var calendar = calendar
    calendar.locale = locale

    guard let date = calendar.date(from: DateComponents(year: year, month: monthIndex)) else { return "" }

    let currentDate = Date()
    if let currentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) {
      if calendar.isDate(date, equalTo: currentMonth, toGranularity: .month) {
        return String(localized: Localize.closestThisMonthTitle.localed(locale))
      }

      if
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth),
        calendar.isDate(date, equalTo: nextMonth, toGranularity: .month)
      {
        return String(localized: Localize.closestNextMonthTitle.localed(locale))
      }
    }

    let dateYear = calendar.component(.year, from: date)
    let currentYear = calendar.component(.year, from: currentDate)

    let dateString: String
    if dateYear == currentYear {
      dateString = date.formatted(
        .dateTime
          .month(.wide)
          .locale(locale)
      )
    } else {
      dateString = date.formatted(
        .dateTime
          .month(.wide)
          .year(.defaultDigits)
          .locale(locale)
      )
    }
    return dateString.capitalized(with: locale)
  }

  private var eventsCountText: String {
    String(format: String(localized: Localize.closestEventsCountFormat.localed(locale)), eventsCount)
  }

  var body: some View {
    HStack(spacing: DSSpacing.s10) {
      Spacer()
      Text(monthTitle)
        .font(.dsTitle3Semibold)
        .foregroundStyle(DSColor.Text.primary)

      Text(eventsCountText)
        .font(.dsBodySemibold)
        .foregroundStyle(DSColor.Text.secondary)

      Image(systemName: isCollapsed ? "chevron.down" : "chevron.up")
        .font(.dsBodySemibold)
        .foregroundStyle(DSColor.Text.secondary)
    }
    .padding(.vertical, DSSpacing.s8)
    .padding(.horizontal, DSSpacing.s12)
    .background {
      RoundedRectangle(cornerRadius: DSRadius.r12, style: .continuous)
        .fill(DSColor.Background.grouped)
        .strokeBorder(DSColor.Stroke.secondaryO_2, lineWidth: 1)
    }
    .contentShape(Rectangle())
    .onTapGesture(perform: tapAction)
  }
}
