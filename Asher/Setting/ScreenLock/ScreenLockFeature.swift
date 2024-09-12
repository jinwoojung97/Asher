//
//  ScreenLockFeature.swift
//  Asher
//
//  Created by chuchu on 8/28/24.
//

import SwiftUI

import ComposableArchitecture

struct ScreenLockFeature: Reducer {
  let auth = BiometricsAuthManager()
  struct State: Equatable {
    var usePassword = UserDefaultsManager.shared.usePassword
    var useBiometricsAuth = UserDefaultsManager.shared.useBiometricsAuth
    var openLockScreen = false
    var showErrorAlert = false
    var openChangePassword = false
  }
  
  enum Action: Equatable {
    case setUsePassword(Bool)
    case setBiometricsAuth(Bool)
    case openLockScreen
    case openChangePassword
    case tapChangePassword
    case lockAction(BiometricsAuthManager.AuthenticationState)
    case openAlert
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .setUsePassword(let usePassword):
      if usePassword { state.openLockScreen = true }
      state.usePassword = usePassword
      UserDefaultsManager.shared.usePassword = usePassword
      
      return .none
      
    case .setBiometricsAuth(let useBiometricsAuth):
      if useBiometricsAuth {
        return .run { send in
          await send(.lockAction(auth.execute()))
        }
      }
      else {
        setUseBiometricsAuth(into: &state, canUse: false)
        return .none
      }
      
    case .openLockScreen:
      state.openLockScreen.toggle()
      return .none
    case .openChangePassword:
      state.openChangePassword.toggle()
      return .none
    case .tapChangePassword:
      state.openLockScreen.toggle()
      return .none
    case .lockAction(let action):
      switch action {
      case .loggedIn:
        setUseBiometricsAuth(into: &state, canUse: true)
        
      case .fail(_):
        setUseBiometricsAuth(into: &state, canUse: false)
        state.showErrorAlert = true
      }
      return .none
    case .openAlert:
      state.showErrorAlert = false
      return .none
    }
  }
  
  private func test() {
    
  }
  
  private func setUseBiometricsAuth(into state: inout State, canUse: Bool) {
    state.useBiometricsAuth = canUse
    UserDefaultsManager.shared.useBiometricsAuth = canUse
  }
}
