//
//  Date +.swift
//  Core
//
//  Created by chuchu on 2023/07/20.
//

import Foundation

public extension Date {
    
    static var currentMonth: Date {
        guard case let calendar = Calendar.current,
              case let components = calendar.dateComponents([.month, .year], from: .now),
              let currentMonth = calendar.date(from: components)
        else { return .now }
        
        return currentMonth
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
