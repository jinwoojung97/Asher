//
//  Date +.swift
//  Core
//
//  Created by chuchu on 2023/07/20.
//

import Foundation

extension Date {
    static var currentMonth: Date {
        guard case let calendar = Calendar.current,
              case let components = calendar.dateComponents([.month, .year], from: .now),
              let currentMonth = calendar.date(from: components)
        else { return .now }
        
        return currentMonth
    }
    
    var category: DayCategory? {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return .today
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()),
                    calendar.isDate(self, inSameDayAs: yesterday) {
            return .yesterday
        }
        return nil
    }
    
    func toString() -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        formatter.locale = .current
        
        return formatter.string(from: self)
    }
    
    func toInt() -> Int {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = .current
        
        return Int(Int(formatter.string(from: self)) ?? 0)
    }
}

extension Date {
    enum DayCategory {
        case yesterday
        case today
        
        var toString: String {
            switch self {
            case .yesterday: "어제"
            case .today: "오늘"
            }
        }
        
        var title: String {
            "\(toString)의 기분을 체크해보세요!"
        }
    }
}
