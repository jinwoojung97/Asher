//
//  HomeFeature.swift
//  Asher
//
//  Created by chuchu on 6/14/24.
//

import SwiftUI

import ComposableArchitecture

struct HomeFeature: Reducer {
  struct State: Equatable {
    var name: String
    var calendarHeight: CGFloat = .zero
  }
  
  enum Action: Equatable {
    case setCalendarHeight(CGFloat)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .setCalendarHeight(let height):
      state.calendarHeight = height
      
      return .none
    }
  }
}
