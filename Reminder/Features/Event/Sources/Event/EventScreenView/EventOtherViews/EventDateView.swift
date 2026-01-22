//
//  EventDateView.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 27.10.2025.
//

import SwiftUI
import DesignSystem

struct EventDateView: View {
  @State private var isDateDatePickerVisible = false
  @State private var temporaryEventDate = Date()
  @State private var selectedMonth = 1
  @State private var selectedDay = 1
  @Binding var eventDate: Date
  @Environment(\.locale) private var locale

  private let dateDisplayStyle: DateDisplayStyle

  init(eventDate: Binding<Date>, dateDisplayStyle: DateDisplayStyle = .fullDate) {
    self._eventDate = eventDate
    self.dateDisplayStyle = dateDisplayStyle
  }

  var body: some View {
    Button {
      temporaryEventDate = eventDate
      syncSelectedComponents()
      isDateDatePickerVisible = true
    } label: {
      HStack(spacing: DSSpacing.s8) {
//        VStack(alignment: .leading, spacing: DSSpacing.s4) {
//          Text(Localize.eventDateLabel)
//            .font(.dsHeadline)
//            .foregroundStyle(DSColor.Text.primary)
          Text(eventDateFormatter.string(from: eventDate))
            .font(.dsSubheadline)
            .foregroundStyle(DSColor.Text.primary)
//        }
        Spacer()
        Image(systemName: "calendar")
          .font(.dsTitle3)
          .padding(DSSpacing.s10)
          .background(
            Circle()
              .fill(DSColor.Fill.accentO_12)
          )
          .foregroundStyle(DSColor.Icon.accent)
          .dsShadow(.r10AccentSoft)
      }
      .padding(.horizontal, DSSpacing.s14)
      .padding(.vertical, DSSpacing.s6)
      .background {
        RoundedRectangle(cornerRadius: DSRadius.r12)
          .fill(DSColor.Background.primary)
          .dsShadow(.r6Light)
      }
    }
    .sheet(isPresented: $isDateDatePickerVisible) {
      datePickerSheetView()
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
  }
  
  private func datePickerSheetView() -> some View {
    VStack(spacing: DSSpacing.s24) {
      HStack {
        Spacer()
        Text(Localize.selectEventDateTitle)
          .font(.dsTitle3Semibold)
          .foregroundStyle(.primary)
        Spacer()
      }

      datePickerContent

      HStack(spacing: DSSpacing.s16) {
        Button {
          isDateDatePickerVisible = false
        } label: {
          Text(Localize.cancelTitle)
            .font(.dsHeadline)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DSSpacing.s12)
            .background(
              RoundedRectangle(cornerRadius: DSRadius.r12, style: .continuous)
                .stroke(DSColor.Stroke.secondary, lineWidth: 1)
            )
        }

        Button {
          eventDate = temporaryEventDate
          isDateDatePickerVisible = false
        } label: {
          Text(Localize.doneTitle)
            .font(.dsHeadline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DSSpacing.s12)
            .background(
              RoundedRectangle(cornerRadius: DSRadius.r12, style: .continuous)
                .fill(DSColor.Fill.accent)
            )
            .foregroundStyle(DSColor.Text.white)
        }
        
      }
      .padding(.horizontal)
    }
    .padding(.horizontal, DSSpacing.s8)
    .padding(.vertical, DSSpacing.s8)
    .frame(maxWidth: .infinity)
    .background(DSColor.Background.primary)
  }

  @ViewBuilder
  private var datePickerContent: some View {
    switch dateDisplayStyle {
    case .fullDate:
      standardDatePicker
    case .monthAndDay:
      monthAndDayPicker
    case .dayOnly:
      dayOnlyPicker
    }
  }

  private var standardDatePicker: some View {
    DatePicker("", selection: $temporaryEventDate, displayedComponents: [.date])
      .datePickerStyle(.wheel)
      .labelsHidden()
      .padding(.vertical, DSSpacing.s8)
      .frame(maxWidth: .infinity)
      .background(
        RoundedRectangle(cornerRadius: DSRadius.r16, style: .continuous)
          .fill(DSColor.Background.secondary)
      )
      .padding(.horizontal)
  }

  private var monthAndDayPicker: some View {
    HStack(spacing: DSSpacing.s16) {
      Picker(Localize.eventDateLabel, selection: $selectedMonth) {
        ForEach(Array(monthSymbols.enumerated()), id: \.offset) { index, symbol in
          Text(symbol)
            .tag(index + 1)
        }
      }
      .pickerStyle(.wheel)
      .frame(maxWidth: .infinity)
      .onChange(of: selectedMonth) { _ in
        updateTemporaryDate(month: selectedMonth, day: selectedDay)
      }

      Picker(Localize.eventDateLabel, selection: $selectedDay) {
        ForEach(daysRangeForSelectedMonth, id: \.self) { day in
          Text(String(day))
            .tag(day)
        }
      }
      .pickerStyle(.wheel)
      .frame(maxWidth: .infinity)
      .onChange(of: selectedDay) { _ in
        updateTemporaryDate(month: selectedMonth, day: selectedDay)
      }
    }
    .padding(.vertical, DSSpacing.s8)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: DSRadius.r16, style: .continuous)
        .fill(DSColor.Background.secondary)
    )
    .padding(.horizontal)
  }

  private var dayOnlyPicker: some View {
    Picker(Localize.eventDateLabel, selection: $selectedDay) {
      ForEach(daysRangeForSelectedMonth, id: \.self) { day in
        Text(String(day))
          .tag(day)
      }
    }
    .pickerStyle(.wheel)
    .padding(.vertical, DSSpacing.s8)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: DSRadius.r16, style: .continuous)
        .fill(DSColor.Background.secondary)
    )
    .padding(.horizontal)
    .onChange(of: selectedDay) { _ in
      updateTemporaryDate(day: selectedDay)
    }
  }

  private var eventDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = locale

    switch dateDisplayStyle {
    case .fullDate:
      formatter.dateStyle = .medium
      formatter.timeStyle = .none
    case .monthAndDay:
      formatter.setLocalizedDateFormatFromTemplate("MMMMd")
    case .dayOnly:
      formatter.setLocalizedDateFormatFromTemplate("d")
    }

    return formatter
  }

  private var monthSymbols: [String] {
    let formatter = DateFormatter()
    formatter.locale = locale
    return formatter.monthSymbols
  }

  private var daysRangeForSelectedMonth: ClosedRange<Int> {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year], from: temporaryEventDate)
    components.month = selectedMonth
    components.day = 1

    let baseDate = calendar.date(from: components) ?? temporaryEventDate
    let daysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count ?? 31

    return 1...daysInMonth
  }

  private func updateTemporaryDate(month: Int? = nil, day: Int? = nil) {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day], from: temporaryEventDate)

    if let month {
      components.month = month
    }

    if let day {
      let adjustedDay = min(day, daysRangeForSelectedMonth.upperBound)
      components.day = adjustedDay
      selectedDay = adjustedDay
    }

    temporaryEventDate = calendar.date(from: components) ?? temporaryEventDate
  }

  private func syncSelectedComponents() {
    let calendar = Calendar.current
    selectedMonth = calendar.component(.month, from: temporaryEventDate)
    selectedDay = calendar.component(.day, from: temporaryEventDate)
  }
}

extension EventDateView {
  enum DateDisplayStyle {
    case fullDate
    case monthAndDay
    case dayOnly
  }
}
