//
//  CalendarView.swift
//  Asher
//
//  Created by chuchu on 6/17/24.
//

import SwiftUI
import SwiftData

import ComposableArchitecture

struct HomeView: View {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @State var store = Store(initialState: HomeFeature.State(name: "연학")) { HomeFeature() }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      let maxHeight = viewStore.state.calendarHeight - (Const.calendarTitleViewHeight + Const.weekLabelHeight +
                                        UIApplication.shared.safeAreaInset.top + Const.topPadding +
                                        Const.bottomPadding)
      
      ScrollView(.vertical) {
        VStack(spacing: 0) {
          calendarView(viewStore: viewStore)
          
          if let category = viewStore.state.selectedDay.category {
            checkMoodView(category: category, viewStore: viewStore)
          }
          
          menuView(viewStore: viewStore)
          
          quoteView(viewStore: viewStore)
          
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
      .padding(.bottom, 75)
      .onAppear { viewStore.send(.fetchAll) }
    }
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
  func calendarView(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
    GeometryReader { proxy in
      let size = proxy.size
      let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
      /// Converting Scroll into Progress
      let maxHeight = size.height - (Const.calendarTitleViewHeight + Const.weekLabelHeight +
                                     UIApplication.shared.safeAreaInset.top + Const.topPadding +
                                     Const.bottomPadding + Const.welcomeMessageHeight)
      let progress = max(min((-minY / maxHeight), 1), 0)
      
      VStack(alignment: .leading, spacing: 0) {
        Text("\(viewStore.name)님 환영해요.")
          .font(.notoSans(width: .bold, size: 32))
          .padding(.bottom, 8)
          .frame(height: Const.welcomeMessageHeight)
          .foregroundStyle(.subtitleOn)
        
        Text(viewStore.state.currentMonth)
          .font(.notoSans(width: .black, size: 35 - (10 * progress)))
          .offset(y: -50 * progress)
          .frame(maxHeight: .infinity, alignment: .bottom)
          .overlay(alignment: .topLeading) {
            GeometryReader { proxy in
              let size = proxy.size
              
              Text(viewStore.state.year)
                .font(.notoSans(width: .bold, size: 25 - (10 * progress)))
                .offset(x: (size.width + 5) * progress)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .overlay(alignment: .bottomTrailing) {
            HStack(spacing: 0) {
              Button("", systemImage: "chevron.left") {
                viewStore.send(.updateMonth(false))
              }
              .frame(width: 50, height: 50)
              .contentShape(.rect)
              
              Button("", systemImage: "chevron.right") {
                viewStore.send(.updateMonth(true))
              }
              .frame(width: 50, height: 50)
              .contentShape(.rect)
            }
            .offset(x: 150 * progress)
          }
          .foregroundStyle(.subtitleOn)
          .frame(height: Const.calendarTitleViewHeight)
        
        VStack(spacing: 0) {
          HStack(spacing: 0) {
            ForEach(Calendar.current.weekdaySymbols, id: \.self) { symbol in
              Text(symbol.prefix(3))
                .font(.notoSans(width: .bold, size: 12))
                .frame(maxWidth: .infinity)
                .foregroundStyle(.subtitleOn)
            }
          }
          .frame(height: Const.weekLabelHeight, alignment: .bottom)
          
          LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
            ForEach(viewStore.state.selectedMonthDates) { day in
                Text(day.shortSymbol)
                  .font(.notoSans(width: .medium, size: 15))
                  .foregroundStyle(day.ignored ? .subtitle: .subtitleOn)
                  .frame(maxWidth: .infinity)
                  .frame(height: 50)
                  .shadow(radius: day.ignored ? 0: 2)
                  .overlay {
                    Circle()
                      .fill(.red)
                      .frame(width: 25, height: 25)
                      .opacity(Calendar.current.isDate(day.date, inSameDayAs: viewStore.state.selectedDay) ? 0.2: 0) // TODO: feature로 옮기기
                  }
                  .overlay(alignment: .bottom) {
                    if let mood = day.mood {
                      Text(mood.emoji)
                        .font(.notoSans(width: .medium, size: 10))
                        .opacity(0.8)
                    }
                  }
                  .contentShape(.rect)
                  .onTapGesture {
                    if day.ignored {
                      let increment = viewStore.state.selectedDay < day.date
                      viewStore.send(.updateMonth(increment))
                    }
                    viewStore.send(.selecteDay(day.date))
                    
                    viewStore.send(.addMood(day.date, .sad))
              }
            }
          }
          .frame(height: viewStore.state.calendarGridHeight - (viewStore.state.calendarGridHeight - 50) * progress, alignment: .top)
          .offset(y: viewStore.state.monthProgress * -50 * progress)
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
      .background(.main1)
      .clipped()
      .contentShape(.rect)
      .offset(y: -minY)
      .gesture(drag)
    }
    .frame(height: viewStore.state.calendarHeight)
    .zIndex(100)
  }
  
  @ViewBuilder
  private func menuView(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
    
    var columns: [GridItem] {
      horizontalSizeClass == .regular ?
      [GridItem(.flexible())]:
      [GridItem(.flexible()), GridItem(.flexible())]
    }
    
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(MenuView.Menu.allCases, id: \.hashValue) { menu in
        MenuView(menu: menu) {
          viewStore.send(.menuTapped(menu))
        }
      }
    }
    .padding()
  }
  
  @ViewBuilder
  private func checkMoodView(
    category: Date.DayCategory,
    viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>
  ) -> some View {
    VStack() {
      Text(category.title)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding()
  }
  
  @ViewBuilder
  private func quoteView(
    viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>
  ) -> some View { QuoteScrollView() }
  
  var drag: some Gesture {
    DragGesture()
      .onEnded { store.send(.updateMonth($0.startLocation.x > $0.location.x))  }
  }
}


#Preview {
  HomeView()
}


struct CustomScrollBehavior: ScrollTargetBehavior {
  var maxHeight: CGFloat
  func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
    if target.rect.minY < maxHeight {
      target.rect = .zero
    }
  }
}
