//
//  APIAggregator.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Alamofire

public class APIAggregator<R1, R2>: Dropable {
    
    var firstPromise: APIPromise<R1>
    var secondPromise: APIPromise<R2>
    
    public init(aggregate promise: APIPromise<R1>, with otherPromise: APIPromise<R2>) {
        firstPromise = promise
        secondPromise = otherPromise
    }
    
    public func then(run closure: @escaping (APIResult<R1>, APIResult<R2>) -> Void, whenFailed failClosure: @escaping (CapturedResult) -> Void) -> Dropable {
        var retainCapture: CapturedResult = .init()
        var firstRequest: () -> DataRequest? = { [weak self] in
            self?.firstPromise.request
        }
        var secondRequest: () -> DataRequest? = { [weak self] in
            self?.secondPromise.request
        }
        defer {
            firstPromise.then(run: { result in
                retainCapture.firstCapturedResult = result
                if let secondCapturedResult = retainCapture.secondCapturedResult {
                    closure(result, secondCapturedResult)
                } else if retainCapture.secondCapturedError != nil {
                    secondRequest()?.cancel()
                    failClosure(retainCapture)
                }
            }, whenFailed: { error in
                retainCapture.firstCapturedError = error
                secondRequest()?.cancel()
                failClosure(retainCapture)
            })
            secondPromise.then(run: { result in
                retainCapture.secondCapturedResult = result
                if let firstCapturedResult = retainCapture.firstCapturedResult {
                    closure(firstCapturedResult, result)
                } else if retainCapture.firstCapturedError != nil {
                    firstRequest()?.cancel()
                    failClosure(retainCapture)
                }
            }, whenFailed: { error in
                retainCapture.secondCapturedError = error
                firstRequest()?.cancel()
                failClosure(retainCapture)
            })
        }
        return self
    }
    
    public func then(run closure: @escaping (APIResult<R1>, APIResult<R2>) -> Void) -> Dropable {
        then(run: closure, whenFailed: { _ in })
    }
    
    public func drop() {
        firstPromise.request.cancel()
        secondPromise.request.cancel()
    }
    
    public struct CapturedResult {
        public var firstCapturedResult: APIResult<R1>?
        public var secondCapturedResult: APIResult<R2>?
        public var firstCapturedError: Error?
        public var secondCapturedError: Error?
    }
}

public extension APIPromise {
    func aggregate<R>(with promise: APIPromise<R>) -> APIAggregator<ResultType, R> {
        APIAggregator(aggregate: self, with: promise)
    }
}
