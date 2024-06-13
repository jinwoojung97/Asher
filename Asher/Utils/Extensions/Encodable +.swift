//
//  Encodable +.swift
//  Core
//
//  Created by chuchu on 11/7/23.
//

import Foundation

public extension Encodable {
    var json: [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return [:] }
        
        return json
    }
}
