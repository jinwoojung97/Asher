//
//  UserDefaultManager.swift
//  Asher
//
//  Created by chuchu on 7/23/24.
//

import Foundation

public struct UserDefaultsManager {
    fileprivate enum Key {
        static let nickname = "nickname"
        static let usePassword = "usePassword"
        static let password = "password"
        static let useBiometricsAuth = "useBiometricsAuth"
        static let isFirstBioAuth = "isFirstBioAuth"
        static let isAllowedNotification = "isAllowedNotification"
        static let useNotification = "useNotification"
        static let notiSetting = "notiSetting"
        static let sharedMetaData = "sharedMetaData"
        static let inquiryDic = "inquiryCount"
        static let contactUrl = "contactUrl"
        static let widgetLink = "widgetLink"
    }
    
    public static var shared = UserDefaultsManager()
    
    public let userDefaults = UserDefaults(suiteName: "group.com.chuchu.Asher")
    
    public var nickname: String {
        get {
            guard let nickname = userDefaults?.value(forKey: Key.nickname) as? String
            else { return "" }
            
            return nickname
        }
        
        set {
            userDefaults?.set(newValue, forKey: Key.nickname)
        }
    }
    
    public var usePassword: Bool {
        get {
            guard let usePassword = userDefaults?.value(forKey: Key.usePassword) as? Bool
            else { return false }
            
            return usePassword
        }
        set {
            userDefaults?.set(newValue, forKey: Key.usePassword)
        }
    }
    
    public var password: String {
        get {
            guard let password = userDefaults?.value(forKey: Key.password) as? String
            else { return "" }
            
            return password
        }
        set {
            userDefaults?.set(newValue, forKey: Key.password)
        }
    }
    
    public var useBiometricsAuth: Bool {
        get {
            guard let useBiometricsAuth = userDefaults?
                .value(forKey: Key.useBiometricsAuth) as? Bool
            else { return false }
            
            return useBiometricsAuth
        }
        set {
            userDefaults?.set(newValue, forKey: Key.useBiometricsAuth)
        }
    }
    
    public var isFirstBioAuth: Bool {
        get {
            guard let isFirstBioAuth = UserDefaults
                .standard
                .value(forKey: Key.isFirstBioAuth) as? Bool
            else { return false }
            
            return isFirstBioAuth
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isFirstBioAuth)
        }
    }
    
    public var isAllowedNotification: Bool {
        get {
            guard let isAllowedNotification = UserDefaults
                .standard
                .value(forKey: Key.isAllowedNotification) as? Bool
            else { return false }
            
            return isAllowedNotification
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isAllowedNotification)
        }
    }
    
    public var useNotification: Bool {
        get {
            guard let useNotification = UserDefaults
                .standard
                .value(forKey: Key.useNotification) as? Bool
            else { return false }
            
            return useNotification
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.useNotification)
        }
    }
    
    var notiSetting: NotiInfo {
        get {
            guard let notiSetting = UserDefaults.standard.value(forKey: Key.notiSetting) as? Data,
                  case let decoder = JSONDecoder(),
                  let noti = try? decoder.decode(NotiInfo.self, from: notiSetting)
            else { return  NotiInfo() }
            
            return noti
        }
        
        set {
            guard case let encoder = JSONEncoder(),
                  let encoded = try? encoder.encode(newValue)
            else { return }
            
            UserDefaults.standard.setValue(encoded, forKey: Key.notiSetting)
        }
    }
    
    public var limitInquiryDic: [Int: Int] {
        get {
            guard let inquiryData = UserDefaults.standard.value(forKey: Key.inquiryDic) as? Data,
                  case let decoder = JSONDecoder(),
                  let inquiryDic = try? decoder.decode([Int: Int].self, from: inquiryData)
            else { return [:] }
            
            return inquiryDic
        }
        
        set {
            guard case let encoder = JSONEncoder(),
                  let encoded = try? encoder.encode(newValue)
            else { return }
            
            UserDefaults.standard.setValue(encoded, forKey: Key.inquiryDic)
        }
    }
    
    public var contactUrl: String {
        get {
            guard let contactUrl = userDefaults?.value(forKey: Key.contactUrl) as? String
            else { return "" }
            
            return contactUrl
        }
        set { userDefaults?.set(newValue, forKey: Key.contactUrl) }
    }
    
//    public var widgetLink: Core.Link? {
//        get {
//            guard let widgetLink = userDefaults?.value(forKey: Key.widgetLink) as? Data,
//                  case let decoder = JSONDecoder(),
//                  let deocdedWidgetLink = try? decoder.decode(Link.self, from: widgetLink)
//            else { return  nil }
//            
//            return deocdedWidgetLink
//        }
//        
//        set {
//            guard case let encoder = JSONEncoder(),
//                  let encoded = try? encoder.encode(newValue)
//            else { return }
//            
//            userDefaults?.setValue(encoded, forKey: Key.widgetLink)
//        }
//    }
}
