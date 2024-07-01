//
//  HomeFeature.swift
//  Asher
//
//  Created by chuchu on 6/14/24.
//

import SwiftUI
import SwiftData

import ComposableArchitecture

struct HomeFeature: Reducer {
  @Dependency(\.swiftData) var context
  @Dependency(\.databaseService) var databaseService
  
  struct State: Equatable {
    var name: String
    var items: [Item] = []
    var selectedMonth: Date = .currentMonth
    var selectedDay: Date = .now
    var currentMonth: String { format("MMMM") }
    var year: String { format("YYYY") }
    var monthProgress: CGFloat {
      let calendar = Calendar.current
      if let index = selectedMonthDates
        .firstIndex(where: { calendar.isDate($0.date, inSameDayAs: selectedDay) }) {
        return CGFloat(index / 7).rounded()
      }
      
      return 1.0
    }
    var selectedMonthDates: [Day] { extractDates(selectedMonth) }
    var calendarGridHeight: CGFloat { CGFloat(selectedMonthDates.count / 7) * 50 }
    
    func format(_ format: String) -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = format
      
      return formatter.string(from: selectedMonth)
    }
    
    mutating func monthUpdate(_ increment: Bool = true) {
      guard case let calendar = Calendar.current,
            let month = calendar.date(byAdding: .month, value: increment ? 1: -1, to: selectedMonth),
            let day = calendar.date(byAdding: .month, value: increment ? 1: -1, to: selectedDay)
      else { return }
      
      self.selectedMonth = month
      self.selectedDay = day
    }
    
    var calendarHeight: CGFloat { Const.calendarTitleViewHeight + Const.weekLabelHeight +
      UIApplication.shared.safeAreaInset.top + Const.topPadding + Const.bottomPadding +
      calendarGridHeight + Const.welcomeMessageHeight
    }
    
    func extractDates(_ month: Date) -> [Day] {
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
        let mood = DatabaseManager.shared.fetchItems(with: getItemDescriptor(date: date)).first?.mood
        days.append(Day(shortSymbol: shortSymbol, date: date, mood: mood))
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
    
    private func getItemDescriptor(date: Date) -> FetchDescriptor<Item> {
      let dayString = date.toDayString()
      let fetchPredicate = #Predicate<Item> { $0.date == dayString }
      
      return FetchDescriptor(predicate: fetchPredicate)
    }
  }
  
  enum Action: Equatable {
    case addMood(Date, Mood)
    case fetchAll
    case menuTapped(MenuView.Menu)
    case selecteDay(Date)
    case updateMonth(Bool)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .addMood(let date, let mood):
      addMood(date: date, mood: mood)
      return .none
      
    case .fetchAll:
      state.items = DatabaseManager.shared.fetchAllItems()
      return .none
      
    case .menuTapped(let menu):
      switch menu {
      case .checkMood:
        break
      case .meditation:
        NavigationManager.shared.push(MeditationView())
      case .chat:
        break
      }
      print(menu)
      return .none
      
    case .selecteDay(let date):
      state.selectedDay = date
      return .none
      
    case .updateMonth(let increment):
      withAnimation {
        state.monthUpdate(increment)
      }
      
      return .none
    }
  }
  
  private func getItemDescriptor(date: Date) -> FetchDescriptor<Item> {
    let dayString = date.toDayString()
    let fetchPredicate = #Predicate<Item> { $0.date == dayString }
    
    return FetchDescriptor(predicate: fetchPredicate)
  }
  
  private func addMood(date: Date, mood: Mood) {
    let item = DatabaseManager.shared.fetchItems(with: getItemDescriptor(date: date)).first
    if let item { item.mood = mood }
    else {
      let newItem = Item(date: date.toDayString(), mood: mood)
      DatabaseManager.shared.addItem(newItem)
    }
  }
}
