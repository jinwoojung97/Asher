//
//  UserNotiManager.swift
//  Core
//
//  Created by chuchu on 2023/07/24.
//

import Foundation
import UIKit

//public class UserNotiManager {
//    public static let shared = UserNotiManager()
//    
//    public func saveNoti(noti: NotificationSetting = UserDefaultsManager.shared.notiSetting,
//                         completion: (((Bool) -> ())?) = nil) {
//        var result: [Bool] = []
//        let notiContent = getContent()
//        
//        deleteAllNotifications()
//
//        for info in noti.info where info.selected {
//            let component = getDateComponent(date: noti.time, day: info.days)
//            let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
//            let request = UNNotificationRequest(
//                identifier: UUID().uuidString,
//                content: notiContent,
//                trigger: trigger
//            )
//            
//            UNUserNotificationCenter.current().add(request) { error in
//                result.append(error == nil)
//            }
//        }
//        
//        completion?(result.reduce(true) { $0 || $1 })
//    }
//    
//    public func deleteAllNotifications() {
//        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
//            for request in requests {
//                print(request)
//            }
//        }
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//    }
//    
//    private func getContent() -> UNMutableNotificationContent {
//        let notiContent = UNMutableNotificationContent()
//        
//        notiContent.title = I18N.notiContentTitle
//        notiContent.body = I18N.notiContentMessage
//        notiContent.userInfo = ["targetScene": "splash"] // 푸시 받을때 오는 데이터
//        
//        return notiContent
//    }
//    
//    private func getDateComponent(date: Date?, day: Days) -> DateComponents {
//        guard let date else { return DateComponents() }
//        
//        var component = Calendar.current.dateComponents([.hour, .minute], from: date)
//        
//        component.weekday = day.rawValue
//        
//        return component
//    }
//}
