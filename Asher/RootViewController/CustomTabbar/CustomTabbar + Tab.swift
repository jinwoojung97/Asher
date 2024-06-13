//
//  CustomTabbar + Tab.swift
//  Asher
//
//  Created by chuchu on 6/13/24.
//

import UIKit

extension CustomTabBar {
    enum Tab: CaseIterable {
        case home
        case chat
        case setting
        
        init(index: Int) {
            switch index {
            case 0: self = .home
            case 1: self = .chat
            case 2: self = .setting
            default: self = .home
            }
        }
        
        var title: String {
            switch self {
            case .home: "Home"
            case .chat: "Took Talk"
            case .setting: "Settings"
            }
        }
        
        var index: Int {
            switch self {
            case .home: 0
            case .chat: 1
            case .setting: 2
            }
        }
        
        var imageTag: Int {
            switch self {
            case .home: 10
            case .chat: 20
            case .setting: 30
            }
        }
        
        var labelTag: Int {
            switch self {
            case .home: 11
            case .chat: 21
            case .setting: 31
            }
        }
        
        var onImage: UIImage {
            switch self {
            case .home: UIImage(resource: .homeOn)
            case .chat: UIImage(resource: .chatOn)
            case .setting: UIImage(resource: .settingOn)
            }
        }
        
        var offImage: UIImage {
            switch self {
            case .home: UIImage(resource: .homeOff)
            case .chat: UIImage(resource: .chatOff)
            case .setting: UIImage(resource: .settingOff)
            }
        }
    }
}
