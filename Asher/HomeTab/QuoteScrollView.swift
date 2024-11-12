//
//  InfinityScrollView.swift
//  Asher
//
//  Created by chuchu on 6/19/24.
//

import SwiftUI

struct QuoteScrollView: View {

  @State private var items: [Quote] = [
    Quote(title: "숲", artist: "최유리", isFavorite: false),
    Quote(title: "기억을 걷는 시간", artist: "넬", isFavorite: false),
    Quote(title: "나아지지 않는 날 데리고 산다는 건", artist: "밍기뉴", isFavorite: false),
    Quote(title: "나의 모든 이들에게", artist: "밍기뉴", isFavorite: false),
    Quote(title: "Anti-Hero", artist: "Taylor Swift", isFavorite: false),
    Quote(title: "뜨거워지자", artist: "H1-KEY", isFavorite: false),
    Quote(title: "야경", artist: "터치드", isFavorite: false),
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        GeometryReader { proxy in
          let width = proxy.size.width
          LoopingScrollView(width: width, spacing: 16, items: items) { item in
            VStack {
              Text(item.title)
                .font(.notoSans(width: .bold, size: 18))
                .multilineTextAlignment(.center)
                .foregroundStyle(.subtitleOn)
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
              
              Text(item.artist)
                .font(.notoSans(width: .light, size: 14))
                .foregroundColor(.subtitle)
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
            }
            .frame(maxHeight: .infinity)
            .background(.main1)
            .cornerRadius(10)
            .addBorder(.border, cornerRadius: 10)
            .shadow(radius: 5)
          }
        }
      }
      .frame(height: 200)
      .scrollTargetBehavior(.paging)
    }
  }
}

#Preview {
  QuoteScrollView()
}


