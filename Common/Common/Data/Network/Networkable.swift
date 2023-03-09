//
//  Networkable.swift
//  Common
//
//  Created by 유지호 on 2023/03/06.
//

import Moya

protocol Networkable {
    associatedtype Target: TargetType
    
    static func makeProvider() -> MoyaProvider<Target>
}


extension Networkable {
    
    static func makeProvider() -> MoyaProvider<Target> {
        let loggerPlugin = NetworkLoggerPlugin()
    
        return MoyaProvider<Target>(plugins: [loggerPlugin])
    }
    
}
