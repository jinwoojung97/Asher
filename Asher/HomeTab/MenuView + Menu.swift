//
//  MenuView + Menu.swift
//  Asher
//
//  Created by chuchu on 6/14/24.
//

import SwiftUI

extension MenuView {
  enum Menu: CaseIterable {
    case checkMood
    case meditation
    case chat
    
    var title: String {
      switch self {
      case .checkMood:
        "기분 체크"
      case .meditation:
        "명상"
      case .chat:
        "툭톡"
      }
    }
    
    var subtitle: String {
      switch self {
      case .checkMood: "오늘의 기분을 체크해요."
      case .meditation: "마음의 안정을 찾아요."
      case .chat: "툭터놓고 talk 해요."
      }
    }
    
    var icon: Image {
      switch self {
      case .checkMood: Image(.mood)
      case .meditation: Image(.meditate)
      case .chat: Image(.chat)
      }
    }
  }
}
