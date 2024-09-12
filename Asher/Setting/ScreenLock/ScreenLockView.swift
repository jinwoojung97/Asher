//
//  ScreenLockView.swift
//  Asher
//
//  Created by chuchu on 8/28/24.
//

import SwiftUI

import ComposableArchitecture

struct ScreenLockView: View {
  let customHeaderView: CustomHeaderView
  @State var store = Store(initialState: ScreenLockFeature.State()) { ScreenLockFeature() }
  let auth = BiometricsAuthManager()
  
  init(customHeaderView: CustomHeaderView) {
    self.customHeaderView = customHeaderView
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      customHeaderView
      GeometryReader { _ in
        VStack {
          Toggle(isOn: viewStore.binding(get: \.usePassword, send: { .setUsePassword($0) })) {
            Text("잠금 설정")
          }
          .padding(.horizontal)
          .padding(.bottom, 4)
          
          Divider()
          
          if viewStore.usePassword {
            Toggle(isOn: viewStore.binding(get: \.useBiometricsAuth, send: { .setBiometricsAuth($0) })) {
              Text("생체 인증")
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            Button(action: {
              viewStore.send(.openChangePassword)
            }) {
              Text("비밀번호 재설정")
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.border)
            .cornerRadius(8)
            
          }
        }
        .fullScreenCover(isPresented: viewStore.binding(get: \.openLockScreen, send: { _ in .openLockScreen })) {
          LockScreenViewControllerWrapper(lockType: .newPassword) { didUnlock in
            viewStore.send(.setUsePassword(didUnlock))
          }
        }
        .fullScreenCover(isPresented: viewStore.binding(get: \.openChangePassword, send: { _ in .openChangePassword })) {
          LockScreenViewControllerWrapper(lockType: .changePassword) { _ in }
        }
        .alert("메시지", isPresented: viewStore.binding(get: \.showErrorAlert, send: { _ in .openAlert })) {
          Button("설정", role: .cancel) {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
          }
        }
      }
    }
  }
}
