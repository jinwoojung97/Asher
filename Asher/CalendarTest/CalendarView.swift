//
//  CalendarView.swift
//  Asher
//
//  Created by chuchu on 6/17/24.
//

import SwiftUI

struct CalendarView: View {
  @State private var selectedMonth: Date = .currentMonth
  @State private var selectedDay: Date = .now
  
    var body: some View {
      let maxHeight = calendarHeight - (Const.calendarTitleViewHeight + Const.weekLabelHeight +
                                     UIApplication.shared.safeAreaInset.top + Const.topPadding +
                                     Const.bottomPadding)
      
        ScrollView(.vertical) {
            VStack(spacing: 0) {
              calendarView()
                VStack(spacing: 15) {
                    ForEach(1...15, id: \.self) { _ in
                      cardView()
                    }
                }
                .padding(16)
            }
        }
        .ignoresSafeArea()
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(CustomScrollBehavior(maxHeight: maxHeight))
    }
  
  @ViewBuilder
  func cardView() -> some View {
    RoundedRectangle(cornerRadius: 15)
      .fill(.blue.gradient)
      .frame(height: 70)
      .overlay(alignment: .leading) {
        HStack(spacing: 12) {
          Circle()
            .frame(width: 40, height: 40)
          
          VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5)
              .frame(width: 100, height: 5)
            
            RoundedRectangle(cornerRadius: 5)
              .frame(width: 70, height: 5)
          }
        }
        .foregroundStyle(.white.opacity(0.25))
        .padding(15)
      }
  }
  
  @ViewBuilder
  func calendarView() -> some View {
    GeometryReader { proxy in
      let size = proxy.size
      let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
      /// Converting Scroll into Progress
      let maxHeight = size.height - (Const.calendarTitleViewHeight + Const.weekLabelHeight +
                                     UIApplication.shared.safeAreaInset.top + Const.topPadding +
                                     Const.bottomPadding)
      let progress = max(min((-minY / maxHeight), 1), 0)
      
      VStack(alignment: .leading, spacing: 0) {
        Text(currentMonth)
          .font(.notoSans(width: .black, size: 35 - (10 * progress)))
          .offset(y: -50 * progress)
          .frame(maxHeight: .infinity, alignment: .bottom)
          .overlay(alignment: .topLeading) {
            GeometryReader { proxy in
              let size = proxy.size
              
              Text(year)
                .font(.notoSans(width: .bold, size: 25 - (10 * progress)))
                .offset(x: (size.width + 5) * progress)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .overlay(alignment: .topTrailing) {
            HStack(spacing: 16) {
              Button("", systemImage: "chevron.left") {
                monthUpdate(false)
              }
              .contentShape(.rect)
              
              Button("", systemImage: "chevron.right") {
                monthUpdate()
              }
              .contentShape(.rect)
            }
            .offset(x: 150 * progress)
          }
          .frame(height: Const.calendarTitleViewHeight)
        
        VStack(spacing: 0) {
          HStack(spacing: 0) {
            ForEach(Calendar.current.weekdaySymbols, id: \.self) { symbol in
              Text(symbol.prefix(3))
                .font(.notoSans(width: .regular, size: 12))
                .frame(maxWidth: .infinity)
                .foregroundStyle(.secondary)
            }
          }
          .frame(height: Const.weekLabelHeight, alignment: .bottom)
          
          LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
            ForEach(selectedMonthDates) { day in
              Text(day.shortSymbol)
                .foregroundStyle(day.ignored ? .secondary: .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .overlay(alignment: .bottom) {
                  Circle()
                    .fill(.white)
                    .frame(width: 5, height: 5)
                    .opacity(Calendar.current.isDate(day.date, inSameDayAs: selectedDay) ? 1: 0)
                    .offset(y: progress * -2)
                }
                .contentShape(.rect)
                .onTapGesture {
                  selectedDay = day.date
                }
            }
          }
          .frame(height: calendarGridHeight - (calendarGridHeight - 50) * progress, alignment: .top)
          .offset(y: monthProgress * -50 * progress)
          .contentShape(.rect)
          .clipped()
        }
        .offset(y: progress * -50)
      }
      .foregroundStyle(.white)
      .padding(.horizontal, Const.horizontalPadding)
      .padding(.top, Const.topPadding)
      .padding(.top, UIApplication.shared.safeAreaInset.top)
      .padding(.bottom, Const.bottomPadding)
      .frame(maxHeight: .infinity)
      .frame(height: size.height - (maxHeight * progress), alignment: .top)
      .background(.red.gradient)
      .clipped()
      .contentShape(.rect)
      .offset(y: -minY)
    }
    .frame(height: calendarHeight)
    .zIndex(100)
  }
  
  func format(_ format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    
    return formatter.string(from: selectedMonth)
  }
  
  func monthUpdate(_ increment: Bool = true) {
    guard case let calendar = Calendar.current,
          let month = calendar.date(byAdding: .month, value: increment ? 1: -1, to: selectedMonth),
          let day = calendar.date(byAdding: .month, value: increment ? 1: -1, to: selectedDay)
    else { return }
    
    selectedMonth = month
    selectedDay = day
  }
  
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
  var calendarHeight: CGFloat { Const.calendarTitleViewHeight + Const.weekLabelHeight +
    UIApplication.shared.safeAreaInset.top + Const.topPadding + Const.bottomPadding +
    calendarGridHeight }
}


#Preview {
  CalendarView()
}

struct Day: Identifiable {
  var id = UUID()
  var shortSymbol: String
  var date: Date
  var ignored: Bool = false
}

extension View {
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
}

struct CustomScrollBehavior: ScrollTargetBehavior {
  var maxHeight: CGFloat
  func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
    if target.rect.minY < maxHeight {
      target.rect = .zero
    }
  }
}
