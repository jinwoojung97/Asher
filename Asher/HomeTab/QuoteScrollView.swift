//
//  InfinityScrollView.swift
//  Asher
//
//  Created by chuchu on 6/19/24.
//

import SwiftUI

struct QuoteScrollView: View {
  @State private var items: [Quote] = [Quote(content: "행복은 습관이다, 그것을 몸에 지니라", author: "추", isFavorite: false),
                                       Quote(content: "너 자신을 알라", author: "소크라테스", isFavorite: false),
                                       Quote(content: "행복은 습관이다, 그것을 몸에 지니라", author: "허버트", isFavorite: false),
                                       Quote(content: "가장 큰 영광은 한 번도 실패하지 않음이 아니라, 실패할 때마다 다시 일어서는 데 있다", author: "공자", isFavorite: false),
                                       Quote(content: "당신이 할 수 있다고 믿든, 할 수 없다고 믿든, 믿는 대로 될 것이다", author: "헨리 포드", isFavorite: false),
                                       Quote(content: "삶이 있는 한 희망은 있다", author: "키케로", isFavorite: false),
                                       Quote(content: "산다는 것은 끊임없이 태어나는 것이다", author: "괴테", isFavorite: false),
                                       Quote(content: "지금이야말로 당신이 마음먹기에 달려 있다", author: "프란시스 베이컨", isFavorite: false),
                                       Quote(content: "행동은 모든 성공의 가장 기초적인 열쇠이다", author: "파블로 피카소", isFavorite: false),
                                       Quote(content: "기회는 일어나는 것이 아니라 만들어내는 것이다", author: "크리스 그로서", isFavorite: false),
                                       Quote(content: "위대한 일을 이루려면 우리는 행동할 뿐 아니라 꿈꾸어야 하고, 계획할 뿐 아니라 믿어야 한다", author: "아나톨 프랑스", isFavorite: false),
                                       ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        GeometryReader { proxy in
          let width = proxy.size.width
          LoopingScrollView(width: width, spacing: 16, items: items) { item in
            VStack {
              Text(item.quote)
                .font(.notoSans(width: .bold, size: 18))
                .multilineTextAlignment(.center)
                .foregroundStyle(.subtitleOn)
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
              
              Text(item.author)
                .font(.notoSans(width: .light, size: 14))
                .foregroundColor(.subtitle)
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
            }
            .frame(maxHeight: .infinity)
            .background(.main1)
            .cornerRadius(10)
            .shadow(radius: 5)
          }
        }
      }
      .frame(height: 150)
      .scrollTargetBehavior(.paging)
    }
  }
}

#Preview {
  QuoteScrollView()
}


