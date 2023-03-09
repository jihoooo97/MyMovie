//
//  Encodable+extension.swift
//  Common
//
//  Created by 유지호 on 2023/03/06.
//

import Moya

extension Encodable {
    
    func toDictionary() -> [String: Any] {
        do {
            let jsonEncoder = JSONEncoder()
            let encodedData = try jsonEncoder.encode(self)
            
            let dictionaryData = try JSONSerialization.jsonObject(
                with: encodedData,
                options: .allowFragments
            ) as? [String: Any]
            return dictionaryData ?? [:]
        } catch {
            return [:]
        }
    }
    
}
