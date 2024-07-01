//
//  DatabaseManager.swift
//  Asher
//
//  Created by chuchu on 7/1/24.
//

import Foundation
import SwiftUI

import SwiftData
import Dependencies


final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    func fetchAllItems() -> [Item] {
        do {
            return try DependencyValues._current.swiftData.fetchAll()
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    func fetchItems(with descriptor: FetchDescriptor<Item>) -> [Item] {
        do {
            return try DependencyValues._current.swiftData.fetch(descriptor)
        } catch {
            print("Error fetching items with descriptor: \(error)")
            return []
        }
    }
    
    func addItem(_ item: Item) {
        do {
            try DependencyValues._current.swiftData.add(item)
        } catch {
            print("Error adding item: \(error)")
        }
    }
    
    func deleteItem(_ item: Item) {
        do {
            try DependencyValues._current.swiftData.delete(item)
        } catch {
            print("Error deleting item: \(error)")
        }
    }
}
