//
//  ContactView.swift
//  Asher
//
//  Created by chuchu on 9/9/24.
//

import SwiftUI

import ComposableArchitecture

struct ContactView: View {
  @State var store: StoreOf<ConatactFeature>
  let customHeaderView: CustomHeaderView
  
  var body: some View {
    customHeaderView
    
    VStack {
      wrapperView {
        TextField(
          "eamil",
          text: $store.email,
          prompt: Text("연락 받을 곳을 입력해주세요!")
            .foregroundStyle(.subtitle)
            .font(.notoSans(width: .regular, size: 16))
        )
        .font(.notoSans(width: .regular, size: 16))
      }
      .frame(height: 80)
      
      Menu (content: {
        ForEach(ContactCategory.allCases, id: \.self) { category in
          Button(action: { store.send(.selectCategory(category)) }) {
            Text(category.title)
              .font(.notoSans(width: .regular, size: 16))
          }
        }
      }) {
        wrapperView {
          Text(store.state.category?.title ?? "카테고리를 선택해 주세요")
            .font(.notoSans(width: .regular, size: 16))
            .foregroundStyle(store.state.category == nil ? .subtitle: .subtitleOn)
          
        }
        .frame(height: 80)
      }
      
      wrapperView {
        TextEditor(text: $store.contents)
          .scrollContentBackground(.hidden)
          .background(.clear)
          .foregroundStyle(.subtitleOn)
          .font(.notoSans(width: .regular, size: 16))
      }
      .frame(height: 144)
      
      RoundedRectangle(cornerRadius: 12)
        .foregroundStyle(.button)
        .overlay(alignment: .center) {
          Text("보내기")
            .font(.notoSans(width: .bold, size: 16))
            .foregroundStyle(.white)
            .padding(16)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .onTapGesture { store.send(.sendButton) }
        .frame(height: 72)
      
      Spacer()
    }
  }
  
  @ViewBuilder
  func wrapperView<V>(
    @ViewBuilder content: () -> V
  ) -> some View where V : View {
    RoundedRectangle(cornerRadius: 12)
      .foregroundStyle(.main2)
      .overlay(alignment: .leading) {
        content()
          .padding(16)
      }
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
  }
}
