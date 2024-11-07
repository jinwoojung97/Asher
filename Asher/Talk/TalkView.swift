//
//  TalkView.swift
//  Asher
//
//  Created by chuchu on 7/17/24.
//

import SwiftUI

//struct TalkView: View {
//  @State var newMessage: String = ""
//  
//  var body: some View {
//    GeometryReader { proxy in
//      VStack {
//        ScrollView(.vertical) {
//          LazyVStack(spacing: 16) {
//            ForEach(DataSource.messages) { message in
//              MessageCell(screenProxy: proxy, message: message)
//            }
//          }
//          .padding(.horizontal, 16)
//        }
//        HStack {
//          TextField("Send a message", text: $newMessage, axis: .vertical)
//            .textFieldStyle(.roundedBorder)
//            .modifier(KeyboardAdaptive())
//            .lineLimit(5)
//          Button(action: {print(newMessage)})   {
//            Image(systemName: "paperplane")
//          }
//        }
//        .onAppear(perform: {
//          UIScrollView.appearance().keyboardDismissMode = .interactive
//        })
//      }
//    }
//  }
//}
//
//#Preview {
//  TalkView()
//}

//struct MessageCell: View {
//  var screenProxy: GeometryProxy
//  var message: Message
//  var body: some View {
//    Text(message.content)
//      .padding(.vertical, 8)
//      .padding(.horizontal, 8)
//      .foregroundStyle(message.isReply ? Color.primary: .white)
//      .background {
//        if message.isReply {
//          RoundedRectangle(cornerRadius: 16)
//            .fill(.gray.opacity(0.3))
//        } else {
//          GeometryReader {
//            let size = $0.size
//            let rect = $0.frame(in: .global)
//            let screenSize = screenProxy.size
//            let safeArea = screenProxy.safeAreaInsets
//            let gradients: [Color] = [.gradient1, .gradient2, .gradient3, .gradient4]
//            
//            Rectangle()
//              .fill(.linearGradient(colors: gradients, startPoint: .top, endPoint: .bottom))
//              .mask(alignment: .topLeading) {
//                RoundedRectangle(cornerRadius: 16)
//                  .frame(width: size.width, height: size.height)
//                  .offset(x:rect.minX, y: rect.minY)
//              }
//              .offset(x: -rect.minX, y: -rect.minY)
//              .frame(width: screenSize.width, height: screenSize.height + safeArea.top + safeArea.bottom)
//          }
//          
//        }
//      }
//      .frame(maxWidth: 250, alignment: message.isReply ? .leading: .trailing)
//      .frame(maxWidth: .infinity, alignment: message.isReply ? .leading: .trailing)
//  }
//}
//
//import Combine
//
//final class KeyboardResponder: ObservableObject {
//    @Published var currentHeight: CGFloat = 0
//
//    var keyboardWillShowNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
//    var keyboardWillHideNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
//
//    init() {
//        keyboardWillShowNotification.map { notification in
//            CGFloat((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0)
//        }
//        .assign(to: \.currentHeight, on: self)
//        .store(in: &cancellableSet)
//
//        keyboardWillHideNotification.map { _ in
//            CGFloat(0)
//        }
//        .assign(to: \.currentHeight, on: self)
//        .store(in: &cancellableSet)
//    }
//
//    private var cancellableSet: Set<AnyCancellable> = []
//}
//
//
//struct KeyboardAdaptive: ViewModifier {
//    @ObservedObject private var keyboard = KeyboardResponder()
//
//    func body(content: Content) -> some View {
//        content
//            .padding(.bottom, keyboard.currentHeight)
//    }
//}
