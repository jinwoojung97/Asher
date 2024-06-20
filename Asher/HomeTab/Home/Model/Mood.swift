//
//  Mood.swift
//  Asher
//
//  Created by chuchu on 6/19/24.
//

import Foundation

enum Mood: Codable {
  case happy
  case sad
  case angry
  
  var emoji: String {
    switch self {
    case .happy: "😁"
    case .sad: "😢"
    case .angry: "😡"
    }
  }
}
