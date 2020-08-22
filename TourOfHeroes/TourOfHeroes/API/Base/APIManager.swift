//
//  APIManager.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Alamofire

public protocol APIManager: RequestInterceptor {
    var timeOut: TimeInterval { get }
    func request<ResultType: Codable>(_ request: APIRequest) -> APIPromise<ResultType>
}

public extension APIManager {
    func request<ResultType: Codable>(_ request: APIRequest) -> APIPromise<ResultType> {
        let dataRequest = AF.request(
            request.urlWithParam,
            method: request.method,
            parameters: request.params,
            encoding: request.encoding,
            headers: request.headers,
            interceptor: self
        )
        return APIPromise(request: dataRequest)
    }
}

extension APIManager {
    public func retry(_ request: Request,
                      for session: Session,
                      dueTo error: Error,
                      completion: @escaping (RetryResult) -> Void) {
        guard error.localizedDescription != "cancelled" else {
            completion(.doNotRetry)
            return
        }
        let retryCount = request.retryCount
        guard retryCount > 0 else {
            completion(.doNotRetryWithError(error))
            return
        }
        completion(.retry)
    }
}
