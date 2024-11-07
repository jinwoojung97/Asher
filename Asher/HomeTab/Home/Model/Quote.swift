//
//  Quote.swift
//  Asher
//
//  Created by chuchu on 6/19/24.
//

import Foundation

struct Quote: Identifiable {
  var id = UUID()
  var title: String
  var artist: String
  var isFavorite: Bool
}
