//
//  EventReadScreenView.swift
//  Event
//
//  Created by OpenAI Assistant on 2024-06-11.
//

import SwiftUI
import DesignSystem
import DomainContracts
import DomainLocalization

public struct EventReadScreenView: View {
  @StateObject var viewModel: EventReadViewModel
  @Environment(\.locale) private var locale
  
  public init(viewModel: EventReadViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    contentView
      .frame(maxWidth: .infinity, alignment: .leading)
      .dsScreenPadding()
      .dsScreenBackground()
      .navigationTitle(navigationTitle)
      .navigationBarTitleDisplayMode(.inline)
      .task {
        await viewModel.taskWasCalled()
      }
      .navigationDestination(for: EventRoute.self) { route in
        destinationView(for: route)
      }
  }
}

private extension EventReadScreenView {
  var navigationTitle: String {
    switch viewModel.screenState {
    case .content(let eventDetails):
      if let categoryTitle = eventDetails.categoryTitle {
        return CategoryLocalizationManager.shared.localize(categoryTitle: categoryTitle, locale: locale)
      }

      return eventDetails.title
    case .loading, .error:
      return ""
    }
  }
  
  @ViewBuilder
  var contentView: some View {
    VStack(alignment: .leading, spacing: DSSpacing.s16) {
      ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.s16) {
          contentStateView
        }
      }
      .scrollClipDisabled()
      Button(action: viewModel.editButtonTapped) {
        Text(Localize.editEventButtonTitle.localed(locale))
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(DSMainButtonStyle())
      .padding(.bottom, DSSpacing.s10)
    }
  }
  
  @ViewBuilder
  var contentStateView: some View {
    switch viewModel.screenState {
    case .loading:
      ProgressView()
        .frame(maxWidth: .infinity, alignment: .center)
    case .error(let errorMessage):
      Text(errorMessage)
        .font(.dsBody)
        .foregroundStyle(DSColor.Text.error)
        .frame(maxWidth: .infinity, alignment: .leading)
    case .content(let eventDetails):
      VStack(alignment: .leading, spacing: DSSpacing.s16) {
        eventDetailsView(eventDetails)

        notificationsSectionView(eventDetails)
      }
    }
  }

  func eventDetailsView(_ eventDetails: EventReadViewModel.EventDetails) -> some View {
    EventSectionContainer(
      title: Localize.eventDetailsSectionTitle,
      systemImageName: "square.and.pencil",
      isHeaderVisible: false
    ) {
      EventSubSectionContainer(title: titleLabel(for: eventDetails), foregroundStyle: .primary) {
        readOnlyFieldView(text: eventDetails.title)
      }

      if !eventDetails.comment.isEmpty {
        sectionDivider

        EventSubSectionContainer(title: Localize.eventCommentTitle, foregroundStyle: .primary) {
          readOnlyFieldView(text: eventDetails.comment)
        }
      }

      sectionDivider

      EventSubSectionContainer(title: dateLabel(for: eventDetails), foregroundStyle: .primary) {
        dateValueView(dateDescription(for: eventDetails))
      }
    }
  }
  
  func dateDescription(for eventDetails: EventReadViewModel.EventDetails) -> String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: eventDetails.date)
  }

  func titleLabel(for eventDetails: EventReadViewModel.EventDetails) -> LocalizedStringResource {
    isBirthday(eventDetails) ? Localize.eventNameTitle : Localize.eventTitleTitle
  }

  func dateLabel(for eventDetails: EventReadViewModel.EventDetails) -> LocalizedStringResource {
    isBirthday(eventDetails) ? Localize.birthdayDateTitle : Localize.eventDateTitle
  }

  func isBirthday(_ eventDetails: EventReadViewModel.EventDetails) -> Bool {
    eventDetails.categoryType == .birthdays
  }

  private var sectionDivider: some View {
    Divider()
      .padding(.horizontal, DSSpacing.sMinus8)
  }

  private func readOnlyFieldView(text: String, isPlaceholder: Bool = false) -> some View {
    Text(text)
      .font(.dsBody)
      .foregroundStyle(isPlaceholder ? DSColor.Text.secondary : DSColor.Text.primary)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, DSSpacing.s14)
      .padding(.vertical, DSSpacing.s12)
      .background(
        RoundedRectangle(cornerRadius: DSRadius.r14, style: .continuous)
          .fill(DSColor.Background.primary.opacity(0.9))
      )
  }

  private func dateValueView(_ text: String) -> some View {
    HStack(spacing: DSSpacing.s8) {
      Text(text)
        .font(.dsSubheadline)
        .foregroundStyle(DSColor.Text.primary)

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
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: DSRadius.r12)
        .fill(DSColor.Background.primary)
    )
  }

  func notificationsSectionView(_ eventDetails: EventReadViewModel.EventDetails) -> some View {
    EventSectionContainer(title: Localize.newRemindsSectionTitle, systemImageName: "square.and.pencil") {
      VStack(alignment: .leading, spacing: DSSpacing.s12) {
        if let remindBeforeDate = eventDetails.remindBeforeDate {
          EventNewRemindView(
            dateTimeString: formattedReminderDate(remindBeforeDate),
            isScheduled: eventDetails.isRemindBeforeScheduled
          )
        }

        if let remindOnDayDate = eventDetails.remindOnDayDate {
          EventNewRemindView(
            dateTimeString: formattedReminderDate(remindOnDayDate),
            isScheduled: eventDetails.isRemindOnDayScheduled
          )
        }

        if !eventDetails.isNotificationsPermissionGranted {
          Text(Localize.notificationsNotAllowedText)
            .font(.dsBody)
            .foregroundStyle(DSColor.Text.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
    }
  }

  private func formattedReminderDate(_ date: Date) -> String {
    date.formatted(
      .dateTime.day(.twoDigits).month(.twoDigits).year(.defaultDigits).hour().minute()
    )
  }
  
  @ViewBuilder
  func destinationView(for route: EventRoute) -> some View {
    if let coordinator = viewModel.coordinator {
      coordinator.destination(for: route)
    } else {
      EmptyView()
    }
  }
}
