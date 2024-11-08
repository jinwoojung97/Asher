//
//  MeditationView.swift
//  Asher
//
//  Created by chuchu on 6/26/24.
//

import SwiftUI

import ComposableArchitecture

struct MeditationView: View {
  @Environment(\.dismiss) private var dismiss
  @State var store = Store(initialState: MeditationFeature.State()) { MeditationFeature() }
  @StateObject private var throttler = Throttler(for: .seconds(1))
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationStack {
        
        ZStack {
          HStack {
            Button(action: {
              throttler.handleTrigger = { viewStore.send(.backButtonTapped) }
              throttler.trigger.send(())
            },
                   label: { Image(.back) })
            .frame(width: 48, height: 48)
            .padding(.leading, 8)
            
            Spacer()
          }
          
          Text("명상하기test")
            .font(.notoSans(width: .bold, size: 18))
            .foregroundStyle(.subtitleOn)
        }
        
        
        
        VStack {
          HStack(spacing: 16) {
            let component = viewStore.timeComponent
            timerView((oncePlace: component.minOncePlace, tensPlace: component.minTensPlace))
            timerView((oncePlace: component.secOncePlace, tensPlace: component.secTensPlace))
          }
        }
        
        
        Button(action: {
          viewStore.send(.startTimer)
        }, label: {
          Text("Start")
        })
        Spacer()
      }
      
      //      .sheet(isPresented: $isNavigating) {
      //        Text("destination").onTapGesture {
      //          isNavigating.toggle()
      //        }
      //      }
    }
  }
  
  @ViewBuilder
  func timerView(_ component: (oncePlace: Int, tensPlace: Int)) -> some View {
    HStack(spacing: 8) {
      FlipClockEffectView(
        value: .constant(component.tensPlace),
        size: CGSize(width: 77, height: 100),
        fontSize: 70,
        cornerRadius: 10,
        foreground: .white,
        background: .red
      )
      
      FlipClockEffectView(
        value: .constant(component.oncePlace),
        size: CGSize(width: 77.5, height: 100),
        fontSize: 70,
        cornerRadius: 10,
        foreground: .white,
        background: .red
      )
    }
  }
}


#Preview {
  CustomHeaderView(action: { print("wow") }, title: "Test" )
}
