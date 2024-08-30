//
//  ScreenLockFeature.swift
//  Asher
//
//  Created by chuchu on 8/28/24.
//

import SwiftUI

import ComposableArchitecture

struct ScreenLockFeature: Reducer {
  struct State: Equatable {
    var usePassword = UserDefaultsManager.shared.usePassword
    var useBiometricsAuth = UserDefaultsManager.shared.useBiometricsAuth
    var openLockScreen = false
  }
  
  enum Action: Equatable {
    
    case setUsePassword(Bool)
    case setBiometricsAuth(Bool)
    case openLockScreen
    case tapChangePassword
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .setUsePassword(let usePassword):
      if usePassword { state.openLockScreen = true }
      state.usePassword = usePassword
      UserDefaultsManager.shared.usePassword = usePassword
      return .none
      
    case .setBiometricsAuth(let useBiometricsAuth):
      state.useBiometricsAuth = useBiometricsAuth
      UserDefaultsManager.shared.useBiometricsAuth = useBiometricsAuth
      BiometricsAuthManager().execute()
      return .none
      
    case .openLockScreen:
      state.openLockScreen.toggle()
      return .none
    case .tapChangePassword:
      state.openLockScreen.toggle()
      return .none
    }
  }
}

