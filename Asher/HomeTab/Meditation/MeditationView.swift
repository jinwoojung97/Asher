//
//  MeditationView.swift
//  Asher
//
//  Created by chuchu on 6/26/24.
//

import SwiftUI
import AVFoundation

import ComposableArchitecture

struct MeditationView: View {
  @Environment(\.dismiss) private var dismiss
  @ObservedObject var viewStore : ViewStoreOf<MeditationFeature>
  @StateObject private var throttler = Throttler(for: .seconds(1))
  
  @State var player: AVAudioPlayer?
  
  init() {
    let store = Store(initialState: MeditationFeature.State()) { MeditationFeature() }
    self.viewStore = ViewStore(store, observe: {$0})
  }
  
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Button(action: {
            stopSound()
            throttler.handleTrigger = { viewStore.send(.backButtonTapped) }
            throttler.trigger.send(())
          },label: { Image(.back) })
          .frame(width: 48, height: 48)
          .padding(.leading, 8)
          
          Spacer()
        }
        .overlay {
          Text("명상하기")
            .font(.notoSans(width: .bold, size: 18))
            .foregroundStyle(.subtitleOn)
        }
        .frame(height: 56)
        
        
        Spacer()
        
        
        VStack(spacing: 48) {
          HStack(spacing: 16) {
            let component = viewStore.timeComponent
            timerView((oncePlace: component.minOncePlace, tensPlace: component.minTensPlace))
            timerView((oncePlace: component.secOncePlace, tensPlace: component.secTensPlace))
          }
          .onTapGesture {
            if !viewStore.isTimerRunning {
              viewStore.send(.setTimeTapped)
            }
            
          }
          
          Button(action: {
            viewStore.send(.startTimer)
          }, label: {
            RoundedRectangle(cornerRadius: 24)
              .foregroundStyle(Color(red: 48/255, green: 148/255, blue: 232/255))
              .overlay {
                Text(viewStore.state.isTimerRunning ? "Stop" : "Start")
                  .font(.notoSans(width: .medium, size: 22))
                  .foregroundStyle(.subtitleOn)
              }
              .padding(.horizontal, 20)
              .frame(height: 48)
          })
        }
        
        Spacer()
      }
      .overlay {
        if viewStore.state.isSettingTime {
          TimePickerView()
            .environmentObject(viewStore)
        }
      }
      .onChange(of: viewStore.isTimerRunning) { isRunning in
        if isRunning {
          playSound()
        } else {
          stopSound()
        }
      }
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
        foreground: .subtitleOn,
        background: .clockBg
      )
      
      FlipClockEffectView(
        value: .constant(component.oncePlace),
        size: CGSize(width: 77.5, height: 100),
        fontSize: 70,
        cornerRadius: 10,
        foreground: .subtitleOn,
        background: .clockBg
      )
    }
  }
  
  
  func playSound() {
    guard let url = Bundle.main.url(forResource: "meditation", withExtension: "mp3") else {return}
    do {
      player = try AVAudioPlayer(contentsOf: url)
      player?.play()
    } catch(let err) {
      print(err.localizedDescription)
    }
  }
  
  func stopSound() {
    player?.stop()
  }
}


#Preview {
  CustomHeaderView(action: { print("wow") }, title: "Test" )
}
