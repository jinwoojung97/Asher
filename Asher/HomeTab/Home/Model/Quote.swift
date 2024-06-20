//
//  Quote.swift
//  Asher
//
//  Created by chuchu on 6/19/24.
//

import Foundation

struct Quote: Identifiable {
  var id = UUID()
  var content: String
  var author: String
  var isFavorite: Bool
  
  var quote: String { "\"\(content)\"" }
}
