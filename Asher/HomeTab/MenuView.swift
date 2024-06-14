//
//  MenuView.swift
//  Asher
//
//  Created by chuchu on 6/14/24.
//

import SwiftUI

struct MenuView: View {
  let menu: HomeView.menu
  
  init(menu: HomeView.menu) {
    self.menu = menu
  }
  
  var body: some View {
    ZStack {
      Rectangle()
        .foregroundStyle(.sub1)
        .addBorder(.border, width: 1, cornerRadius: 10)
      
      VStack(spacing: 12) {
        HStack {
          menu.icon
            .resizable()
            .frame(width: 24, height: 24)
            .padding(.leading, 16)
          
          Spacer()
        }
        
        
        VStack(spacing: 4) {
          AlignmentedText(text: menu.title)
            .font(.notoSans(width: .bold, size: 16))
            .foregroundStyle(.subtitleOn)
          
          AlignmentedText(text: menu.subtitle)
            .font(.notoSans(width: .regular, size: 14))
            .foregroundStyle(.subtitle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .frame(height: 115)
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 4)
  }
}

