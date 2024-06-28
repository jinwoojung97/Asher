//
//  CustomHeaderView.swift
//  Asher
//
//  Created by chuchu on 6/28/24.
//

import SwiftUI

struct CustomHeaderView: View {
  let action: () -> ()
  let title: String
  
  var body: some View {
    ZStack {
      HStack {
        Button(action: action, label: {
          Image(.back)
        })
        .frame(width: 48, height: 48)
        .padding(.leading, 8)
        
        Spacer()
      }
      
      
      Text(title)
        .font(.notoSans(width: .bold, size: 18))
        .foregroundStyle(.subtitleOn)
    }
    Spacer()
  }
}

