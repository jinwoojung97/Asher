//
//  HomeView.swift
//  Asher
//
//  Created by chuchu on 6/7/24.
//


import SwiftUI

struct HomeView: View {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @State var store = Store(initialState: HomeFeature.State(name: "연학")) { HomeFeature() }
  
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        VStack(spacing: 32) {
          Text("\(viewStore.name)님 환영해요.")
            .font(.notoSans(width: .bold, size: 32))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
          
          
          GeometryReader { proxy in
            let width = proxy.size.width
            let calendarWidth = width - 32
            let calendarHeight = calendarWidth * 5 / 4
            
            Rectangle()
              .frame(width: calendarWidth, height: calendarHeight)
              .padding(.horizontal, 16)
              .foregroundStyle(.yellow)
              .onAppear { store.send(.setCalendarHeight(calendarHeight)) }
              .overlay {
                Text("달력")
                  .font(.notoSans(width: .extraBold, size: 40))
              }
          }
          .frame(height: viewStore.calendarHeight)
          
          menuView(viewStore: viewStore)
        }
      }
    }
    .padding(.bottom, 75)
  }
  
  @ViewBuilder
  private func menuView(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
    
    var columns: [GridItem] {
      horizontalSizeClass == .regular ?
      [GridItem(.flexible())]:
      [GridItem(.flexible()), GridItem(.flexible())]
    }
    
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(menu.allCases, id: \.hashValue) { menu in
        MenuView(menu: menu)
          .onTapGesture { print("Button \(menu.title) tapped") }
      }
    }
    .padding()
  }
}

extension HomeView {
  enum menu: CaseIterable {
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

import ComposableArchitecture

struct HomeFeature: Reducer {
  struct State: Equatable {
    var name: String
    var calendarHeight: CGFloat = .zero
  }
  
  enum Action: Equatable {
    case setCalendarHeight(CGFloat)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .setCalendarHeight(let height):
      state.calendarHeight = height
      
      return .none
    }
  }
}
