//
//  MeditationFeature.swift
//  Asher
//
//  Created by chuchu on 6/27/24.
//

import SwiftUI

import ComposableArchitecture

struct MeditationFeature: Reducer {
  @AppStorage("initialCount") var initialCount: Int = 300
  @Dependency (\.continuousClock) var clock
  struct State: Equatable {
    var initialCount: Int = 300
    var count: Int = 300
    var timeComponent = TimeComponent(time: 300)
    var isTimerRunning = false
  }
  
  enum CancelID { case timer }
  
  enum Action: Equatable {
    case backButtonTapped
    case timerTick
    case setInitialCount(Int)
    case startTimer
    case resetTimer
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .backButtonTapped:
      NavigationManager.shared.pop()
      return .none
    case .timerTick:
      state.count -= 1
      state.timeComponent = TimeComponent(time: state.count)
      
      return if state.count == 0 && state.isTimerRunning { .send(.startTimer) }
      else { .none }
    case .setInitialCount(let count):
      state.initialCount = count
      state.count = count
      state.timeComponent = TimeComponent(time: count)
      
      return .none
    case .startTimer:
      let initialCount = state.initialCount
      state.isTimerRunning.toggle()
      if state.isTimerRunning {
        return .run { send in
          await send(.timerTick)
          for await _ in clock.timer(interval: .seconds(1)) {
            await send(.timerTick)
          }
        }.cancellable(id: CancelID.timer)
      } else {
        return .run { send in
          await send(.resetTimer)
          try await clock.sleep(for: .seconds(0.8))
          return await send(.setInitialCount(initialCount))
        }
      }
      
      
    case .resetTimer:
      return .cancel(id: CancelID.timer)
    }
  }
}

extension MeditationFeature {
  struct TimeComponent: Equatable {
    let time: Int
    var minutes: Int { time / 60 }
    var seconds: Int { time % 60 }
    var minOncePlace: Int { minutes % 10 }
    var minTensPlace: Int { minutes / 10 }
    var secOncePlace: Int { seconds % 10 }
    var secTensPlace: Int { seconds / 10 }
  }
}
