//
//  HomeView.swift
//  Asher
//
//  Created by chuchu on 6/7/24.
//


import SwiftUI

import ComposableArchitecture

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
      .scrollIndicators(.hidden)
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
      ForEach(MenuView.Menu.allCases, id: \.hashValue) { menu in
        MenuView(menu: menu) {
          print("Button \(menu.title) tapped")
        }
      }
    }
    .padding()
  }
}



