//
//  MenuView.swift
//  Asher
//
//  Created by chuchu on 6/14/24.
//

import SwiftUI

struct MenuView: View {
  let menu: MenuView.Menu
  var onTap: (() -> Void)?
  
  @State private var isPressed: Bool = false
  
  init(menu: MenuView.Menu, onTap: (() -> Void)? = nil) {
    self.menu = menu
    self.onTap = onTap
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
    .scaleEffect(isPressed ? 0.95 : 1.0)
    .animation(.easeInOut(duration: 0.2), value: isPressed)
    .onTapGesture {
      withAnimation {
        isPressed = true
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        withAnimation {
          isPressed = false
        }
        onTap?()
      }
    }
  }
}

