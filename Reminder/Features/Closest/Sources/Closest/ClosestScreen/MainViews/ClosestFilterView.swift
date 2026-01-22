//
//  ClosestFilterView.swift
//  Closest
//
//  Created by Vitaliy Stepanenko on 18.12.2025.
//

import SwiftUI
import DesignSystem

struct ClosestFilterView: View {
  @ObservedObject var filterViewDataSource: ClosestFilterViewDataSource
  let tapAction: (UUID) -> Void
  
  var body: some View {
    ScrollViewReader { scrollProxy in
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: DSSpacing.s12) {
          ForEach(filterViewDataSource.filterItems, id: \.id) { item in
            ClosestFilterItemView(
              filterItem: item,
              isSelected: item.id == filterViewDataSource.selectedFilterItemId,
              tapAction: tapAction
            )
            .id(item.id)
          }
        }
        .padding(.horizontal, DSSpacing.s16)
        .padding(.vertical, DSSpacing.s8)
      }
      .frame(height: 50)
      .onAppear {
        scrollToSelectedItem(with: scrollProxy)
      }
      .onChange(of: filterViewDataSource.selectedFilterItemId) { _ in
        withAnimation(.easeInOut) {
          scrollToSelectedItem(with: scrollProxy)
        }
      }
    }
  }
  
  private func scrollToSelectedItem(with scrollProxy: ScrollViewProxy) {
    scrollProxy.scrollTo(filterViewDataSource.selectedFilterItemId, anchor: .center)
  }
}
