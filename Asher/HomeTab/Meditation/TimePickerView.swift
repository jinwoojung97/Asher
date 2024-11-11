//
//  TimePickerView.swift
//  Asher
//
//  Created by inforex on 11/11/24.
//

import SwiftUI

import ComposableArchitecture

struct TimePickerView: View {
    
    @EnvironmentObject var viewStore: ViewStoreOf<MeditationFeature>
    
    var colors = Array(1...120)
    @State private var selectedMinute = 10
//    @State var isSettingTime: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    viewStore.send(.setTimeTapped)
                    viewStore.send(.setInitialCount(selectedMinute * 60))
                }
            
            VStack {
                Text("Minutes")
                  .font(.notoSans(width: .bold, size: 18))
                  .foregroundStyle(.subtitleOn)
                
                Picker("minutes", selection: $selectedMinute) {
                    ForEach(colors, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.wheel)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.sub1)
                )
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    TimePickerView()
}
