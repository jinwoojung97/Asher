//
//  NavigationManager.swift
//  Asher
//
//  Created by chuchu on 6/26/24.
//

import SwiftUI
import Combine

final class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    
    @Published var currentView: AnyView? = nil
    @Published var selectedTab: Int?
    
    private init() {}
    
    func push<V: View>(_ view: V) { currentView = AnyView(view) }
    
    func pop() { currentView = nil }
    
    func select(_ tab: CustomTabBar.Tab) { selectedTab = tab.index }
}
