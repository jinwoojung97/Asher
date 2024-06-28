//
//  Throttler.swift
//  Asher
//
//  Created by chuchu on 6/28/24.
//

import SwiftUI
import Combine

class Throttler: ObservableObject {
  @Published var trigger = PassthroughSubject<Void, Never>()
  var handleTrigger: (() -> ())?
  private var cancellables = Set<AnyCancellable>()
  
  init(for time: RunLoop.SchedulerTimeType.Stride) {
    trigger
      .throttle(for: time, scheduler: RunLoop.main, latest: false)
      .sink { [weak self] _ in self?.handleTrigger?() }
      .store(in: &cancellables)
  }
  
  deinit { print("Throttler deinit") }
}
