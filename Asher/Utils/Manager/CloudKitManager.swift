//
//  CloudKitManager.swift
//  Core
//
//  Created by chuchu on 2023/08/09.
//

import CloudKit

public struct CloudKitManager {
    let container: CKContainer
    let privateDatabase: CKDatabase
    let publicDatabase: CKDatabase
    let recordType: String = "Link"

    public init(containerIdentifier: String? = "iCloud.LinkTest") {
        if let identifier = containerIdentifier {
            container = CKContainer(identifier: identifier)
        } else {
            container = CKContainer.default()
        }
        privateDatabase = container.privateCloudDatabase
        publicDatabase = container.publicCloudDatabase
    }
    
    public func save(record: CKRecord,
              in databaseType: DatabaseType = .private,
              completion: @escaping (CKRecord?, Error?) -> Void) {
        let database: CKDatabase = databaseType == .private ? privateDatabase : publicDatabase
        
        database.save(record) { completion($0, $1) }
    }
    
    public func save(record: CKRecord,
                     in databaseType: DatabaseType = .private) async throws -> CKRecord {
        let database: CKDatabase = databaseType == .private ? privateDatabase : publicDatabase
        
        return try await withCheckedThrowingContinuation { continuation in
            database.save(record) { savedRecord, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let savedRecord = savedRecord {
                    continuation.resume(returning: savedRecord)
                } else {
                    continuation.resume(throwing: DatabaseError.unknown)
                }
            }
        }
    }

    public func fetch(recordID: CKRecord.ID,
               in databaseType: DatabaseType = .private,
               completion: @escaping (CKRecord?, Error?) -> Void) {
        let database: CKDatabase = databaseType == .private ? privateDatabase : publicDatabase

        database.fetch(withRecordID: recordID) { completion($0, $1) }
    }
    
    public func fetch(recordID: CKRecord.ID,
                      in databaseType: DatabaseType = .private) async throws -> CKRecord {
        let database: CKDatabase = databaseType == .private ? privateDatabase : publicDatabase
        
        return try await withCheckedThrowingContinuation { continuation in
            database.fetch(withRecordID: recordID) { fetchedRecord, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let fetchedRecord = fetchedRecord {
                    continuation.resume(returning: fetchedRecord)
                } else {
                    continuation.resume(throwing: DatabaseError.unknown)
                }
            }
        }
    }

    
    public func fetchAll(completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        let database = privateDatabase
        let query = createQuery()
        let queryOperation = CKQueryOperation(query: query)
        var resultRecords: [CKRecord] = []
        
        queryOperation.recordFetchedBlock = { resultRecords.append($0) }

        queryOperation.queryCompletionBlock = { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(resultRecords))
            }
        }

        database.add(queryOperation)
    }
    
    public func delete(recordID: CKRecord.ID,
                       in databaseType: DatabaseType = .private,
                       completion: @escaping (CKRecord.ID?, Error?) -> Void) {
        let database: CKDatabase = databaseType == .private ? privateDatabase : publicDatabase
        
        database.delete(withRecordID: recordID) { completion($0, $1) }
    }
    
    public func deleteAll() {
        let query = createQuery()
        let database = privateDatabase

        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching records: \(error)")
                return
            }
            
            guard let records = records else { return }
            
            let deleteOperations = records.map { CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [$0.recordID]) }
            
            for operation in deleteOperations {
                operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
                    if let error = error {
                        print("Error deleting record: \(error)")
                    } else {
                        print("Successfully deleted record with ID: \(String(describing: deletedRecordIDs?.first))")
                    }
                }
                database.add(operation)
            }
        }
    }
    
    private func createQuery() -> CKQuery {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        return query
    }

    public enum DatabaseType {
        case `public`
        case `private`
    }
    
    public enum DatabaseError: Error {
        case unknown
    }
}
