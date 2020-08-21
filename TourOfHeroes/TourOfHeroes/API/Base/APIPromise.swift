//
//  APIPromise.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Alamofire

public protocol Promise {
    associatedtype Result
    @discardableResult
    func then(run closure: @escaping (Result) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> DataRequest?
    
    @discardableResult
    func then(run closure: @escaping (Result) -> Void) -> DataRequest?
}

public class APIPromise<ResultType>: Promise {
    
    public typealias Result = APIResult<ResultType>
    
    var request: DataRequest?
    
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    init(request: DataRequest?) {
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
        guard let request = request else {
            defer {
                runOnMainThread {
                    failClosure(APIError(description: "No Request"))
                }
            }
            return nil
        }
        defer {
            request.validate(statusCode: 200..<300).responseData { response in
                dispatchOnMainThread {
                    if let error = response.error {
                        failClosure(error)
                    } else {
                        closure(APIResult(raw: response))
                    }
                }
            }
        }
        return request
    }
    
    @discardableResult
    public func then(run closure: @escaping (Result) -> Void) -> DataRequest? {
        guard isConnectedToInternet, let request = request else {
            return nil
        }
        defer {
            request.validate(statusCode: 200..<300).responseData { response in
                dispatchOnMainThread {
                    closure(APIResult(raw: response))
                }
            }
        }
        return request
    }
    
}

public class APIAggregator<R1, R2> {
    var firstPromise: APIPromise<R1>
    var secondPromise: APIPromise<R2>
    
    public init(aggregate promise: APIPromise<R1>, with otherPromise: APIPromise<R2>) {
        firstPromise = promise
        secondPromise = otherPromise
    }
    
    public func then(run closure: @escaping (APIResult<R1>, APIResult<R2>) -> Void, whenFailed failClosure: @escaping (CapturedResult) -> Void) {
        var captured: CapturedResult = .init()
        let firstRequest = firstPromise.request
        let secondRequest = secondPromise.request
        firstPromise.then(run: { result in
            captured.firstCapturedResult = result
            if let secondCapturedResult = captured.secondCapturedResult {
                closure(result, secondCapturedResult)
            } else if captured.secondCapturedError != nil {
                secondRequest?.cancel()
                failClosure(captured)
            }
        }, whenFailed: { error in
            captured.firstCapturedError = error
            secondRequest?.cancel()
            failClosure(captured)
        })
        secondPromise.then(run: { result in
            captured.secondCapturedResult = result
            if let firstCapturedResult = captured.firstCapturedResult {
                closure(firstCapturedResult, result)
            } else if captured.firstCapturedError != nil {
                firstRequest?.cancel()
                failClosure(captured)
            }
        }, whenFailed: { error in
            captured.secondCapturedError = error
            firstRequest?.cancel()
            failClosure(captured)
        })
    }
    
    public func then(run closure: @escaping (APIResult<R1>, APIResult<R2>) -> Void) {
        then(run: closure, whenFailed: { _ in })
    }
    
    
    public struct CapturedResult {
        public var firstCapturedResult: APIResult<R1>?
        public var secondCapturedResult: APIResult<R2>?
        public var firstCapturedError: Error?
        public var secondCapturedError: Error?
    }
}
