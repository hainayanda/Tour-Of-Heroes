//
//  APIPromise.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Alamofire

public class APIPromise<ResultType>: Promise {
    
    public typealias Result = APIResult<ResultType>
    public typealias CancelableRequest = DataRequest?
    
    var request: DataRequest
    var queueHandler: APIQueueHandler = .instance
    
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    init(request: DataRequest) {
        self.request = request
    }
    
    @discardableResult
    public func then(run closure: @escaping (Result) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> DataRequest? {
        guard isConnectedToInternet else {
            defer {
                runOnMainThread {
                    failClosure(APIError(description: "No Internet"))
                }
            }
            return nil
        }
        queueHandler.dispatch(request: &request, then: closure, whenFailed: failClosure)
        return request
    }
    
    @discardableResult
    public func then(run closure: @escaping (Result) -> Void) -> DataRequest? {
        guard isConnectedToInternet else {
            return nil
        }
        queueHandler.dispatch(request: &request, then: closure, whenFailed: { _ in })
        return request
    }
    
}
