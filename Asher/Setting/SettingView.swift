//
//  SettingView.swift
//  Asher
//
//  Created by chuchu on 6/28/24.
//

import SwiftUI

struct SettingView: View {
  @State private var showLockScreen = false
  private let throttler = Throttler(for: .seconds(1))
  
  var body: some View {
    
    NavigationStack {
      VStack {
        Text("설정")
          .font(.notoSans(width: .bold, size: 18))
          .foregroundStyle(.subtitleOn)
        
        ForEach(SettingType.allCases, id: \.self) { type in
          makeSettingView(type: type)
            .frame(height: 48)
            .onTapGesture { onTapGesture(type: type) }
        }
        Spacer()
      }
    }
    .fullScreenCover(isPresented: $showLockScreen) {
      LockScreenViewControllerWrapper { didUnlock in
        if didUnlock {
          throttler.handleTrigger = { NavigationManager.shared.push(SettingType.screenLock.view) }
          throttler.trigger.send(())
        }
      }
        .ignoresSafeArea()
    }
  }
  
  private func onTapGesture(type: SettingType) {
    switch type {
    case .screenLock:
      if UserDefaultsManager.shared.usePassword { showLockScreen = true }
      else { fallthrough }
      
    default:
      throttler.handleTrigger = { NavigationManager.shared.push(type.view) }
      throttler.trigger.send(())
    }
    
  }
  
  @ViewBuilder
  private func makeSettingView(type: SettingType) -> some View {
    HStack {
      type.icon
        .resizable()
        .frame(width: 40, height: 40)
      
      Text(type.title)
        .font(.notoSans(width: .regular, size: 16))
        .foregroundStyle(.subtitleOn)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
    }
    .padding(.all, 16)
    .contentShape(.rect)
  }
}

#Preview {
  SettingView()
}

struct LockScreenViewControllerWrapper: UIViewControllerRepresentable {
  public var lockType: LockType = .enterLockScreen
  public var unlockAction: ((Bool) -> ())? = nil
  
  func makeUIViewController(context: Context) -> some LockScreenViewController {
    let viewController = LockScreenViewController(type: lockType)
    
    viewController.unlockAction = unlockAction
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
}
