//
//  ConatactFeature.swift
//  Asher
//
//  Created by chuchu on 9/9/24.
//

import SwiftUI

import ComposableArchitecture

@Reducer
struct ConatactFeature {
  
  @ObservableState
  struct State: Equatable {
    var email = ""
    var contents = ""
    var category: ContactCategory?
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case sendButton
    case selectCategory(ContactCategory)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.email):
        
        print("testField, \(state.email)")
        return .none
        
      case .binding(\.contents):
        print("testField, \(state.contents)")
        
        return .none
        
      case .sendButton:
        do {
          try validCheck(state: state)
          submitInquiry(state: state)
        } catch(let error) {
          Toast.shared.present(toastItem: ToastItem(title: error.localizedDescription))
        }
        return .none
      case .selectCategory(let category):
        state.category = category
        return .none
        
      case .binding(_): return .none
      }
    }
  }
  
  private func validCheck(state: State) throws {
    if state.email.isEmpty { throw ContactError.emailIsEmpty }
    if state.contents.isEmpty { throw ContactError.contentsIsEmpty }
    if state.category == nil { throw ContactError.nonSelectedCategory }
  }
  
  private func submitInquiry(state: State) {
    guard let title = state.category?.title else { return }
      IndicatorManager.shared.startAnimation()
      let messageModel = SlackMessageModel()
      .addBlock(blockType: .header(title))
          .addBlock(blockType: .osType)
          .addBlock(blockType: .subtitle(state.email))
          .addBlock(blockType: .contents(state.contents))
          .addBlock(blockType: .divider)
      
    NetworkManager.shared.request(api: .contactUs(messageModel)) { data in
          IndicatorManager.shared.stopAnimation()
          switch data.result {
          case .success(_):
            Toast.shared.present(toastItem: ToastItem(title: "success"))
            NavigationManager.shared.pop()
          case .failure(let error):
              print(error)
          }
      }
  }
  
  enum ContactError: Error, LocalizedError {
    case emailIsEmpty
    case contentsIsEmpty
    case nonSelectedCategory
    
    var errorDescription: String? {
      switch self {
      case .emailIsEmpty: "이메일이나 연락처를 입력해주세요"
      case .contentsIsEmpty: "내용을 입력해주세요"
      case .nonSelectedCategory: "카테고리를 입력해주세요"
      }
    }
  }
  
  
}

enum ContactCategory: CaseIterable {
  case error
  case suggestions
  case etc
  
  var title: String {
    switch self {
    case .error: "🐞버그 발견🐞"
    case .suggestions: "❗️건의사항❗️"
    case .etc: "🎸 기타 🎸"
    }
  }
}
