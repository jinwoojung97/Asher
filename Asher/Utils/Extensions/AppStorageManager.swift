//
//  AppStorageManager.swift
//  Asher
//
//  Created by chuchu on 6/19/24.
//

import SwiftUI
import Combine

final class AppStorageManager: ObservableObject {
    static let shared = AppStorageManager()

    private let defaults = UserDefaults.standard

    private init() {}

    // Generic method to save any Codable object
    func save<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            defaults.set(encoded, forKey: key)
            objectWillChange.send()
        }
    }

    // Generic method to load any Codable object
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = defaults.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            }
        }
        return nil
    }

    // Method to remove an object for a given key
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
        objectWillChange.send()
    }
    
    // ObservableObject publisher to notify changes
    let objectWillChange = ObservableObjectPublisher()
}
