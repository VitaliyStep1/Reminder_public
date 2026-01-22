//
//  ScreenBuilders.swift
//  Categories
//
//  Created by Vitaliy Stepanenko on 04.12.2025.
//

import SwiftUI
import DomainContracts
import Event

public typealias CategoryScreenBuilder = (_ categoryId: Identifier) -> CategoryScreenView

public typealias CategoriesScreenBuilder = () -> CategoriesScreenView
