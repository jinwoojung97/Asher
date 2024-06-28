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
    
    static var baseDays: [Day] {
      let month = Date.currentMonth
      var days: [Day] = []
      let calendar = Calendar.current
      let formatter = DateFormatter()
      formatter.dateFormat = "dd"
      
      guard let range = calendar
        .range(of: .day, in: .month, for: month)?
        .compactMap({ return calendar.date(byAdding: .day, value: $0 - 1, to: month) }),
            let rangeFirst = range.first,
            let rangeLast = range.last
      else { return days }
      
      let firstWeekDay = calendar.component(.weekday, from: rangeFirst)
      let lastWeekDay = 7 - calendar.component(.weekday, from: rangeLast)
      
      for index in Array(0..<firstWeekDay - 1).reversed() {
        guard let date = calendar.date(byAdding: .day, value: -index - 1, to: rangeFirst)
        else { return days }
        let shortSymbol = formatter.string(from: date)
        days.append(Day(shortSymbol: shortSymbol, date: date, ignored: true))
      }
      
      range.forEach { date in
        let shortSymbol = formatter.string(from: date)
        days.append(Day(shortSymbol: shortSymbol, date: date))
      }
      
      if lastWeekDay > 0 {
        for index in Array(0..<lastWeekDay) {
          guard let date = calendar.date(byAdding: .day, value: index + 1, to: rangeLast)
          else { return days }
          let shortSymbol = formatter.string(from: date)
          days.append(Day(shortSymbol: shortSymbol, date: date, ignored: true))
        }
      }
      
      return days
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
    
    func toDayString() -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = .current
        
        return formatter.string(from: self)
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
