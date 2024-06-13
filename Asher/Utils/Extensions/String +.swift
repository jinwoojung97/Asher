//
//  String +.swift
//  Core
//
//  Created by chuchu on 12/27/23.
//

import Foundation

public extension String {
    var localized: String { NSLocalizedString(self, comment: "") }
    
    func replace(of target: String, with replacement: String) -> String {
        let targetString = "#\(target)#"
        return self.replacingOccurrences(of: targetString, with: replacement)
    }
    
    var isKorean: Bool { self == "ko" }
    
    var isUs: Bool { self == "us" }
    
    var isJapan: Bool { self == "ja" }
    
    var forceCharWrapping: String { map({ String($0) }).joined(separator: "\u{200B}") }
}
