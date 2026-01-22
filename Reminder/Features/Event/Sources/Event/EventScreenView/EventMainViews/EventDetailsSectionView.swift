//
//  EventDetailsSectionView.swift
//  CategoriesTab
//
//  Created by Vitaliy Stepanenko on 12.11.2025.
//

import SwiftUI
import DesignSystem
import DomainContracts

struct EventDetailsSectionView: View {
  @ObservedObject private var detailsSectionData: EventDetailsSectionData
  private let categoryType: CategoryTypeEnum?

  init(detailsSectionData: EventDetailsSectionData, categoryType: CategoryTypeEnum?) {
    self.detailsSectionData = detailsSectionData
    self.categoryType = categoryType
  }

  var body: some View {
    EventSectionContainer(
      title: Localize.eventDetailsSectionTitle,
      systemImageName: "square.and.pencil",
      isHeaderVisible: false
    ) {
      EventSubSectionContainer(title: titleLabel, foregroundStyle: .primary) {
        EventTextField(
          placeholder: titlePlaceholder,
          text: $detailsSectionData.eventTitle,
          isAutocorrectionDisabled: true
        )
      }
      sectionDivider
      EventSubSectionContainer(title: Localize.eventCommentTitle, foregroundStyle: .primary) {
        EventTextField(placeholder: Localize.eventCommentPlaceholder, text: $detailsSectionData.eventComment)
      }
      if shouldShowDateSection {
        sectionDivider
        EventSubSectionContainer(title: dateLabel, foregroundStyle: .primary) {
          datePickerSectionView
        }
      }
    }
  }

  private var datePickerSectionView: some View {
    VStack(alignment: .leading, spacing: DSSpacing.s14) {
      EventDateView(eventDate: $detailsSectionData.eventDate, dateDisplayStyle: dateDisplayStyle)
        .padding(.trailing, DSSpacing.s4)

      if shouldShowYearToggle {
        Toggle(Localize.eventDateWithYearToggleTitle, isOn: $detailsSectionData.isYearIncluded)
          .padding(.horizontal, DSSpacing.s4)
      }
    }
  }

  private var shouldShowYearToggle: Bool {
    guard let categoryType = resolvedCategoryType else { return false }

    switch categoryType {
    case .birthdays, .aniversaries, .other_year:
      return true
    default:
      return false
    }
  }

  private var dateDisplayStyle: EventDateView.DateDisplayStyle {
    switch resolvedCategoryType {
    case .birthdays, .aniversaries, .other_year:
      return detailsSectionData.isYearIncluded ? .fullDate : .monthAndDay
    case .other_month:
      return .dayOnly
    case .other_day:
      return .fullDate
    case .none:
      return .fullDate
    }
  }

  private var shouldShowDateSection: Bool {
    guard let categoryType = resolvedCategoryType else { return true }

    return categoryType != .other_day
  }

  private var resolvedCategoryType: CategoryTypeEnum? {
    categoryType ?? detailsSectionData.categoryType
  }

  private var titleLabel: LocalizedStringResource {
    isBirthday ? Localize.eventNameTitle : Localize.eventTitleTitle
  }

  private var titlePlaceholder: LocalizedStringResource {
    isBirthday ? Localize.eventNamePlaceholder : Localize.eventTitlePlaceholder
  }

  private var dateLabel: LocalizedStringResource {
    isBirthday ? Localize.birthdayDateTitle : Localize.eventDateTitle
  }

  private var isBirthday: Bool {
    resolvedCategoryType == .birthdays
  }

  private var sectionDivider: some View {
    Divider()
      .padding(.horizontal, DSSpacing.sMinus8)
  }
}
