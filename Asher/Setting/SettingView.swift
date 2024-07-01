//
//  SettingView.swift
//  Asher
//
//  Created by chuchu on 6/28/24.
//

import SwiftUI

struct SettingView: View {
  private let throttler = Throttler(for: .seconds(1))
  
  var body: some View {
    
    NavigationStack {
      VStack {
        Text("설정")
          .font(.notoSans(width: .bold, size: 18))
          .foregroundStyle(.subtitleOn)
        
        ForEach(SettingType.allCases, id: \.self) { type in
          makeSettingView(type: type)
            .frame(height: 48)
            .onTapGesture { onTapGesture(type: type) }
        }
        Spacer()
      }
    }
  }
  
  private func onTapGesture(type: SettingType) {
    throttler.handleTrigger = { NavigationManager.shared.push(type.view) }
    throttler.trigger.send(())
  }
  
  @ViewBuilder
  private func makeSettingView(type: SettingType) -> some View {
    HStack {
      type.icon
        .resizable()
        .frame(width: 40, height: 40)
      
      Text(type.title)
        .font(.notoSans(width: .regular, size: 16))
        .foregroundStyle(.subtitleOn)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
    }
    .padding(.all, 16)
    .contentShape(.rect)
  }
}

#Preview {
  SettingView()
}
