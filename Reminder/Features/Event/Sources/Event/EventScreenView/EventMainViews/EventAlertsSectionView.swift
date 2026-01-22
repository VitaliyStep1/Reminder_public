//
//  EventAlertsSectionView.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 12.11.2025.
//

import SwiftUI
import DesignSystem

struct EventAlertsSectionView: View {
  @ObservedObject private var alertsSectionData: EventAlertsSectionData
  let interactor: EventInteractor
  
  init(alertsSectionData: EventAlertsSectionData, interactor: EventInteractor) {
    self.alertsSectionData = alertsSectionData
    self.interactor = interactor
  }
  
  var body: some View {
    EventSectionContainer(title: Localize.alertsSectionTitle, systemImageName: "bell.badge") {
      EventSubSectionContainer(title: Localize.repeatEveryTitle) {
        repeatContent
      }
      sectionDivider
      remindTimeView
    }
  }
  
  @ViewBuilder
  private var repeatContent: some View {
    switch alertsSectionData.repeatRepresentationEnum {
    case .picker(let values, let titles):
      let titleString = String(localized: Localize.repeatEveryTitle)
      Picker(titleString, selection: $alertsSectionData.eventPeriod) {
        ForEach(values, id: \.self) { option in
          Text(titles[option] ?? "")
            .tag(option)
        }
      }
      .pickerStyle(.segmented)
    case .text(let text):
      Text(text)
        .font(.dsBodyMedium)
        .padding(.horizontal, DSSpacing.s14)
        .padding(.vertical, DSSpacing.s12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(fieldBackground)
    }
  }

  @ViewBuilder
  private var remindTimeView: some View {
    VStack(alignment: .leading, spacing: DSSpacing.s12) {
      Toggle(Localize.remindOnDayOfEventTitle, isOn: $alertsSectionData.isRemindOnDayActive)
      if alertsSectionData.isRemindOnDayActive {
        DatePicker(
          "",
          selection: $alertsSectionData.remindOnDayTimeDate,
          displayedComponents: .hourAndMinute
        )
        .labelsHidden()
        Toggle(Localize.isNecessaryToRepeatTitle, isOn: $alertsSectionData.isRemindRepeated)
      }

      Toggle(Localize.remindBeforeDayOfEventTitle, isOn: $alertsSectionData.isRemindBeforeActive)
      if alertsSectionData.isRemindBeforeActive {
        DatePicker(
          "",
          selection: $alertsSectionData.remindBeforeTimeDate,
          displayedComponents: .hourAndMinute
        )
        .labelsHidden()
        VStack(alignment: .leading, spacing: DSSpacing.s8) {
          Text(Localize.daysBeforeTitle)
          let daysBeforeTitle = String(localized: Localize.daysBeforeTitle)
          Picker(
            daysBeforeTitle,
            selection: $alertsSectionData.remindBeforeDays
          ) {
            ForEach([1, 2, 3, 5, 7], id: \.self) { day in
              Text(String(day))
                .tag(day)
            }
          }
          .pickerStyle(.segmented)
        }
      }
    }
  }
  
  private func optionalDateBinding(
    keyPath: ReferenceWritableKeyPath<EventAlertsSectionData, Date?>
  ) -> Binding<Date> {
    Binding(
      get: {
        alertsSectionData[keyPath: keyPath] ?? alertsSectionData.defaultRemindTimeDate
      },
      set: { newValue in
        alertsSectionData[keyPath: keyPath] = newValue
      }
    )
  }
  
  private var sectionDivider: some View {
    Divider()
      .padding(.horizontal, DSSpacing.sMinus8)
  }
  
  private var fieldBackground: some View {
    RoundedRectangle(cornerRadius: DSRadius.r14, style: .continuous)
      .fill(DSColor.Background.primary.opacity(0.9))
      .dsShadow(.r4Light)
  }
}
