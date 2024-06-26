//
//  DependencyValues.swift
//  Asher
//
//  Created by chuchu on 6/21/24.
//

import SwiftUI
import SwiftData

import ComposableArchitecture

// Global Swift Data Dependency
extension DependencyValues {
    var databaseService: Database {
        get { self[Database.self] }
        set { self[Database.self] = newValue }
    }
}

struct Database {
    var context: () throws -> ModelContext
}


extension Database: DependencyKey {
    @MainActor
    public static let liveValue = Self(
        context: { appContext }
    )
}

@MainActor
let appContext: ModelContext = {
    let container = SwiftDataModelConfigurationProvider.shared.container
    let context = ModelContext(container)
    return context
}()

public class SwiftDataModelConfigurationProvider {
    // Singleton instance for configuration
    public static let shared = SwiftDataModelConfigurationProvider(isStoredInMemoryOnly: false, autosaveEnabled: true)
    
    // Properties to manage configuration options
    private var isStoredInMemoryOnly: Bool
    private var autosaveEnabled: Bool
    
    // Private initializer to enforce singleton pattern
    private init(isStoredInMemoryOnly: Bool, autosaveEnabled: Bool) {
        self.isStoredInMemoryOnly = isStoredInMemoryOnly
        self.autosaveEnabled = autosaveEnabled
    }
    
    // Lazy initialization of ModelContainer
    @MainActor
    public lazy var container: ModelContainer = {
        // Define schema and configuration
        let schema = Schema(
            [Item.self]
        )
        let configuration = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        
        // Create ModelContainer with schema and configuration
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        container.mainContext.autosaveEnabled = autosaveEnabled
        return container
    }()
}

extension DependencyValues {
    var swiftData: ItemDatabase {
        get { self[ItemDatabase.self] }
        set { self[ItemDatabase.self] = newValue }
    }
}

struct ItemDatabase {
    var fetchAll: @Sendable () throws -> [Item]
    var fetch: @Sendable (FetchDescriptor<Item>) throws -> [Item]
    var add: @Sendable (Item) throws -> Void
    var delete: @Sendable (Item) throws -> Void
    
    enum ItemError: Error {
        case add
        case delete
    }
}

extension ItemDatabase: DependencyKey {
    public static let liveValue = Self(
        fetchAll: {
            do {
                @Dependency(\.databaseService.context) var context
                let movieContext = try context()
                
                let descriptor = FetchDescriptor<Item>()
                return try movieContext.fetch(descriptor)
            } catch {
                return []
            }
        },
        fetch: { descriptor in
            do {
                @Dependency(\.databaseService.context) var context
                let movieContext = try context()
                return try movieContext.fetch(descriptor)
            } catch {
                return []
            }
        },
        add: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let movieContext = try context()
                
                movieContext.insert(model)
            } catch {
                throw ItemError.add
            }
        },
        delete: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let movieContext = try context()
                
                let modelToBeDelete = model
                movieContext.delete(modelToBeDelete)
            } catch {
                throw ItemError.delete
            }
        }
    )
}

extension ItemDatabase: TestDependencyKey {
    public static var previewValue = Self.noop
    
    public static let testValue = Self(
        fetchAll: unimplemented("\(Self.self).fetch"),
        fetch: unimplemented("\(Self.self).fetchDescriptor"),
        add: unimplemented("\(Self.self).add"),
        delete: unimplemented("\(Self.self).delete")
    )
    
    static let noop = Self(
        fetchAll: { [] },
        fetch: { _ in [] },
        add: { _ in },
        delete: { _ in }
    )
}
