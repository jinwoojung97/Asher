//
//  MessageView.swift
//  Asher
//
//  Created by chuchu on 6/13/24.
//

import SwiftUI
import Combine

struct Message: Identifiable {
  var id = UUID()
  var content: String
  var isReply: Bool = false
}

struct DataSource {
  
  static var messages = [
    Message(content: "안녕? 나는 너의 친구가 될 툭툭이야.\n 잘 부탁해!", isReply: true),
    Message(content: "오늘 하루는 어땠어?", isReply: true)
  ]
    
    static let gptKey = Bundle.main.getValue(key: .chatGpt, as: String.self) ?? ""
    
    static let systemText = """
너는 친구처럼 내 이야기를 편하게 들어주고, 따뜻하게 조언해주는 역할을 해. 반말로 친근하게 이야기해줘. 공감하고 편안한 분위기에서 상담해줘.
"""
}
