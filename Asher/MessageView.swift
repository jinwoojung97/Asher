//
//  MessageView.swift
//  Asher
//
//  Created by chuchu on 6/13/24.
//

import SwiftUI
import Combine

struct Message: Identifiable {
  var id = UUID()
  var content: String
  var isReply: Bool = false
}

struct DataSource {
  
  static let messages = [
    
    Message(content: "Hi there!", isReply: true),
    
    Message(content: "Hello! How can I assist you today?"),
    Message(content: "How are you doing?", isReply: true),
    Message(content: "I'm just a computer program, so I don't have feelings, but I'm here and ready to help you with any questions or tasks you have. How can I assist you today?"),
    Message(content: "Tell me a joke.", isReply: true),
    Message(content: "Certainly! Here's one for you: Why don't scientists trust atoms? Because they make up everything!"),
    Message(content: "How far away is the Moon from the Earth?", isReply: true),
    Message(content: "The average distance from the Moon to the Earth is about 238,855 miles (384,400 kilometers). This distance can vary slightly because the Moon follows an elliptical orbit around the Earth, but the figure I mentioned is the average distance.")
    
  ]
}


struct MessageView : View {
  var currentMessage: Message
  
  var body: some View {
    HStack(alignment: .bottom, spacing: 10) {
      if !currentMessage.isReply {
        Image(systemName: "person.circle.fill")
          .resizable()
          .frame(width: 40, height: 40, alignment: .center)
          .cornerRadius(20)
      } else {
        Spacer()
      }
//      MessageCell(contentMessage: currentMessage.content,
//                  isCurrentUser: currentMessage.isReply)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
  }
}

//struct MessageCell: View {
//  var contentMessage: String
//  var isCurrentUser: Bool
//  
//  var body: some View {
//    Text(contentMessage)
//      .padding(10)
//      .foregroundColor(isCurrentUser ? Color.white : Color.black)
//      .background(isCurrentUser ? Color.blue : Color(UIColor.systemGray6 ))
//      .cornerRadius(10)
//  }
//}

struct TestChatView: View {
  @State var messages = DataSource.messages
  @State var newMessage: String = ""
  
  
  var body: some View {
    VStack {
      ScrollViewReader { proxy in
        ScrollView {
            LazyVStack {
                //            ForEach(messages, id: \.self) { message in
                //              MessageView(currentMessage: message)
                //                .id(message)
                //            }
                //          }
                //          .onReceive(Just(messages)) { _ in proxy.scrollTo(messages.last, anchor: .bottom) }
                //          .onAppear {
                //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                //              proxy.scrollTo(messages.last, anchor: .bottom) }
                //            }
            }
        }
        
        HStack {
          TextField("Send a message", text: $newMessage)
            .textFieldStyle(.roundedBorder)
            .lineLimit(5)
          Button(action: sendMessage)   {
            Image(systemName: "paperplane")
          }
        }
        .padding(6)
      }
    }
    
    
    
  }
  
  func sendMessage() {
    if !newMessage.isEmpty {
      messages.append(Message(content: newMessage, isReply: true))
      messages.append(Message(content: "Reply of " + newMessage))
      newMessage = ""
    }
  }
}
