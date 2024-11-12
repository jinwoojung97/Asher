//
//  NotificationFeature.swift
//  Asher
//
//  Created by chuchu on 7/22/24.
//

import SwiftUI
import UserNotifications

import ComposableArchitecture

struct NotificationFeature: Reducer {
  struct State: Equatable {
    var notiInfo = UserDefaultsManager.shared.notiSetting
  }
  
  enum Action: Equatable {
    case setUseNoti(Bool)
    case setSelectedDay(Days)
    case setDaySetting(DaySetting)
    case setNotiTime(Date)
    case onAppear
    case onDisappear
    case saveNotiInfo
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .setUseNoti(let useNoti):
      state.notiInfo.useNoti = useNoti
      return .none
      
    case .setSelectedDay(let day):
      let selectedDay = state.notiInfo.selectedDay
      let isSelectedDay = selectedDay.contains(day)
      let hasMultipleDays = selectedDay.count > 1
      if isSelectedDay && hasMultipleDays { state.notiInfo.selectedDay.remove(day) }
      else { state.notiInfo.selectedDay.update(with: day) }
      
      return .none
      
    case .setDaySetting(let setting):
      state.notiInfo.selectedDay = setting.daySetting
      return .none
      
    case .setNotiTime(let notiTime):
      state.notiInfo.notiTime = notiTime
      return .none
      
    case .onAppear:
      checkNoti()
      return .none
    case .onDisappear:
      return .send(.saveNotiInfo)
    case .saveNotiInfo:
      let notiInfo = state.notiInfo
      UserDefaultsManager.shared.notiSetting = notiInfo
      if notiInfo.useNoti { saveNoti(noti: state.notiInfo) }
      else { deleteAllNotifications() }
      
      
      return .none
    }
  }
  
  func saveNoti(noti: NotiInfo,
                completion: (((Bool) -> ())?) = nil) {
      var result: [Bool] = []
      let notiContent = getContent()
      
      deleteAllNotifications()

      for info in noti.selectedDay {
        let component = getDateComponent(date: noti.notiTime, day: info)
          let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
          let request = UNNotificationRequest(
              identifier: UUID().uuidString,
              content: notiContent,
              trigger: trigger
          )
          
          UNUserNotificationCenter.current().add(request) { error in
              result.append(error == nil)
          }
      }
      
      completion?(result.reduce(true) { $0 || $1 })
  }
  
  private func getContent() -> UNMutableNotificationContent {
      let notiContent = UNMutableNotificationContent()
      
      notiContent.title = "오늘 기분을 같이 체크해봐요 😀"
      notiContent.body = "오늘도 당신은 빛나요"
      notiContent.userInfo = ["targetScene": "splash"] // 푸시 받을때 오는 데이터
      
      return notiContent
  }
  
  private func getDateComponent(date: Date?, day: Days) -> DateComponents {
      guard let date else { return DateComponents() }
      
      var component = Calendar.current.dateComponents([.hour, .minute], from: date)
      
      component.weekday = day.rawValue
      
      return component
  }
  
  func deleteAllNotifications() {
      UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
          for request in requests { print(request) }
      }
      UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
  
  func saveNoti() {
    let content = UNMutableNotificationContent()
    content.title = "Notification title."
    content.subtitle = "Notification content."
    content.sound = UNNotificationSound.default
    
    
    // show this notification five seconds from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    
    // choose a random identifier
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    // add our notification request
    UNUserNotificationCenter.current().add(request)
  }
  
  private func checkNoti() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
      if success {
        print("Permission approved!")
      } else if let error  {
        print(error.localizedDescription)
      }
    }
  }
}

struct NotiInfo: Codable, Equatable {
  var useNoti: Bool = false
  var selectedDay: Set<Days> = [.current]
  var notiTime: Date = .now
}
