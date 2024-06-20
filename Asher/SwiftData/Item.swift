//
//  Item.swift
//  Asher
//
//  Created by chuchu on 6/7/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var date: String
    var mood: Mood?
    
    init(date: String, mood: Mood?) {
        self.date = date
        self.mood = mood
    }
}
