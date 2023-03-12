//
//  RequestLoggingPlugin.swift
//  Common
//
//  Created by 유지호 on 2023/03/12.
//

import Moya

final class LoggingPlugin: PluginType {

    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("⚠️ Invalid Request")
            return
        }
        
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"

        print("------------------------------------------------------------")
        print("🛰️ Request [\(method)]")
        print("------------------------------------------------------------")
        print("API: \(target)")
        print("\(url)")
        
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            print("\(bodyString)\n")
        }

        print("🛰️ Request End")
        print("------------------------------------------------------------")
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSuccess(response, target: target, isFromError: false)
        case let .failure(error):
            onFail(error, target: target)
        }
    }
    
    func onSuccess(_ response: Response, target: TargetType, isFromError: Bool) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        
        print("------------------------------------------------------------")
        print("✅ Response [\(statusCode)]")
        print("------------------------------------------------------------")
        print("API: \(target)")
        
        response.response?.allHeaderFields.forEach {
            print("\($0): \($1)")
        }
        
        print("------------------------------------------------------------")
        print(response.data.prettyPrintedJSONString as String? ?? "nil")
        print("✅ Response End (\(response.data.count)-byte body)")
        print("------------------------------------------------------------")
    }
    
    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSuccess(response, target: target, isFromError: true)
            return
        }
        
        print("------------------------------------------------------------")
        print("⚠️ Error Code [\(error.errorCode)]")
        print("------------------------------------------------------------")
        print("API: \(target)")
        
        print("\(error.failureReason ?? error.errorDescription ?? "unknown error")")
        print("⚠️ Error End")
        print("------------------------------------------------------------")
    }
    
}
