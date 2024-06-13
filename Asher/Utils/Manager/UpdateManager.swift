//
//  UpdateManager.swift
//  CoreInterface
//
//  Created by chuchu on 12/1/23.
//

import UIKit

public struct UpdateManager {
    
    public init() { }
    
    public static let shared = UpdateManager()

    public let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    public let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
    let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/6457201380"
    
    public var lastVersion: String? {
        let appleID = 6457201380
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)&country=kr"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[safe: 0]?["version"] as? String else {
            return nil
        }
        return appStoreVersion
    }
    
    public var shouldUpdate: Bool {
        guard let marketVersion = lastVersion,
              let appVersion = appVersion else { return false }
        
        let splitMarketVersion = marketVersion.split(separator: ".")
        let splitAppVersion = appVersion.split(separator: ".")
        
        guard let appMainNumber = splitAppVersion[safe: 0],
              let marketMainNumber = splitMarketVersion[safe: 0],
              let appMinorNumber = splitAppVersion[safe: 1],
              let marketMinorNumber = splitMarketVersion[safe: 1] else { return false }
        
        return (appMainNumber < marketMainNumber) || (appMinorNumber < marketMinorNumber)
    }
    
    public func openAppStore() {
        guard let url = URL(string: appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
