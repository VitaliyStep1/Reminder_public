//
//  EventScreenBuilder.swift
//  Event
//
//  Created by Vitaliy Stepanenko on 22.12.2025.
//

import DomainContracts

public typealias EventScreenBuilder = (_ eventScreenViewType: EventScreenViewType, _ categoryEventWasUpdatedDelegate: EventCategoryEventWasUpdatedDelegate?, _ coordinator: any EventCoordinatorProtocol) -> EventScreenView
public typealias EventReadScreenBuilder = (_ eventId: Identifier, _ coordinator: any EventCoordinatorProtocol) -> EventReadScreenView
