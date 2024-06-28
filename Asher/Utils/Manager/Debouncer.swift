//
//  Debouncer.swift
//  Asher
//
//  Created by chuchu on 6/28/24.
//

import SwiftUI
import Combine

class Debouncer: ObservableObject {
  @Published var trigger = PassthroughSubject<Void, Never>()
  var handleTrigger: (() -> ())?
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    trigger
      .debounce(for: .seconds(1), scheduler: RunLoop.main)
      .sink { $0 }
      .store(in: &cancellables)
  }
}
