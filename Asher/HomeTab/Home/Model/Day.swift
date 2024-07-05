//
//  Day.swift
//  Asher
//
//  Created by chuchu on 6/19/24.
//

import Foundation

struct Day: Identifiable, Equatable {
  var id = UUID()
  var shortSymbol: String
  var date: Date
  var ignored: Bool = false
  var mood: [Mood]?
}
