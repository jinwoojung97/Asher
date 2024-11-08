//
//  SettingView + Type.swift
//  Asher
//
//  Created by chuchu on 6/28/24.
//

import SwiftUI

import ComposableArchitecture

extension SettingView {
  enum SettingType: CaseIterable {
    case notificationSetting
    case screenLock
    case quotesSetting
    case replayTutorial
    case contactUs
    case chooseTheme
    case clearAllData
    
    var title: String {
      switch self {
      case .notificationSetting: "알림 설정"
      case .screenLock: "화면 잠금"
      case .quotesSetting: "노래 설정"
      case .replayTutorial: "튜토리얼 다시보기"
      case .contactUs: "문의하기"
      case .chooseTheme: "테마 선택하기"
      case .clearAllData: "모든 콘텐츠 및 설정 지우기"
      }
    }
    
    var icon: Image {
      switch self {
      case .notificationSetting: Image(.noti)
      case .screenLock: Image(.lock)
      case .quotesSetting: Image(.quote)
      case .replayTutorial: Image(.replay)
      case .contactUs: Image(.contact)
      case .chooseTheme: Image(.theme)
      case .clearAllData: Image(.clear)
      }
    }
    
    @ViewBuilder
    var view: some View {
        let action = { NavigationManager.shared.pop() }
        let headerView = CustomHeaderView(action: action, title: title)
        
        switch self {
        case .notificationSetting: NotificationSettingView(customHeaderView: headerView)
        case .screenLock: ScreenLockView(customHeaderView: headerView)
        case .contactUs: ContactView(store: Store(initialState: ConatactFeature.State(), reducer: {
            ConatactFeature()
        }), customHeaderView: headerView)
        default: headerView
//        case .screenLock: return
//        case .quotesSetting: return
//        case .replayTutorial: return
//        case .contactUs: return
//        case .chooseTheme: return
//        case .clearAllData: return
        }
      
    }
  }
}
