//
//  Networkable.swift
//  Common
//
//  Created by 유지호 on 2023/03/06.
//

import Moya
import RxSwift

class Network<API: TargetType>: MoyaProvider<API> {
    
    init(plugins: [PluginType] = []) {
        let session = MoyaProvider<API>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        
        super.init(session: session, plugins: plugins)
    }
    
    func request(_ api: API) -> Single<Response> {
        return self.rx.request(api)
            .filterSuccessfulStatusCodes()
    }
    
}


extension Network {
    
    func requestWithoutMapping(_ api: API) -> Single<Void> {
        return request(api)
            .map { _ in }
    }
    
    func requestObject<T: Codable>(_ api: API, type: T.Type) -> Single<T> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return request(api)
            .map(T.self, using: decoder)
    }
    
    func requestArray<T: Codable>(_ api: API, type: T.Type) -> Single<[T]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return request(api)
            .map([T].self, using: decoder)
    }
    
}
