//
//  Array +.swift
//  Core
//
//  Created by chuchu on 2023/07/03.
//

import Foundation

public extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
