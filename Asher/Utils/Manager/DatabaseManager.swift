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
    
    func fetchChartItems() -> [ChartInfo] {
        let items = fetchAllItems()
        var groupedItems: [String: [Item]] = [:]
        var result: [ChartInfo] = []
        var index: Double = 0
        items.forEach { groupedItems[$0.date, default: []].append($0) }
        let sortedItems = groupedItems.sorted { $0.key < $1.key }
        sortedItems.forEach { key, value in
            if !value.isEmpty {
                index += 1
                let test = value.compactMap { $0.mood?.score }.reduce(0, +) / Double(value.count)
                result.append(ChartInfo(date: key, score: test, moods: value.compactMap(\.mood), index: index))
            }
        }
        
        return result
    }
    
    private func getScore(item: [Item]) -> Double {
        if item.count == 1 { item.first?.mood?.score ?? 0 }
        else { item.compactMap { $0.mood?.score }.reduce(0, +) / Double(item.count) }
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
    
    func deleteAll() {
        do {
            try DependencyValues._current.swiftData.deleteAll()
        } catch {
            print("Error deleting item: \(error)")
        }
    }
}

extension DatabaseManager {
    struct ChartInfo {
        let date: String
        let score: Double
        let moods: [Mood]
        
        var index: Double = 0
        
        var day: String { date.toDate }
    }
}
