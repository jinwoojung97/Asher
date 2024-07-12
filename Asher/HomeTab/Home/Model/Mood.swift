//
//  Mood.swift
//  Asher
//
//  Created by chuchu on 6/19/24.
//

import Foundation

enum Mood: Codable {
    case best
    case good
    case normal
    case bad
    case worst
    
    var emoji: String {
        switch self {
        case .best: "😆"
        case .good: "🙂"
        case .normal: "😐"
        case .bad: "☹️"
        case .worst: "🤬"
        }
    }
    
    var title: String {
        switch self {
        case .best: "최고"
        case .good: "좋음"
        case .normal: "그저 그럼"
        case .bad: "안 좋음"
        case .worst: "최악" 
        }
    }
    
    var score: Double {
        switch self {
        case .best: 100
        case .good: 75
        case .normal: 50
        case .bad: 25
        case .worst: 0
        }
    }
}

extension Mood: CaseIterable { }

extension Mood: Identifiable {
    var id: UUID { UUID() }
}
