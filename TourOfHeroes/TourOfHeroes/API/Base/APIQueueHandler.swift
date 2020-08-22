//
//  APIQueueHandler.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Alamofire

open class APIQueueHandler: Dropable {
    
    public static var instance: APIQueueHandler = .init()
    
    typealias Observer = (Any) -> Void
    private lazy var operationQueue: OperationQueue = .init()
    @Atomic var requestQueue: [DataRequestComparable: [Observer]] = [:]
    
    public init(maxConcurentCount: Int = 2) {
        let max: Int
        if maxConcurentCount <= 0 {
            max = 1
            return
        } else {
            max = maxConcurentCount
        }
        operationQueue.name = UUID().uuidString
        operationQueue.maxConcurrentOperationCount = max
        operationQueue.qualityOfService = .utility
    }
    
    open func drop() {
        operationQueue.cancelAllOperations()
        requestQueue = [:]
    }
    
    open func dispatch<Result>(request: inout DataRequest, then: @escaping (APIResult<Result>) -> Void, whenFailed: @escaping (Error) -> Void) {
        let observer = intoObserver(thenClosure: then, failClosure: whenFailed)
        guard let onGoingRequest = self.onGoingRequest(for: request) else {
            addToQueue(for: .init(dataRequest: request), observer)
            addOperation(for: request, resultType: Result.self)
            return
        }
        request = onGoingRequest.dataRequest
        addToQueue(for: onGoingRequest, observer)
        return
    }
    
    private func intoObserver<Result>(thenClosure: @escaping (Result) -> Void, failClosure: @escaping (Error) -> Void) -> Observer {
        return { result in
            guard let parsedResult = result as? Result else {
                let error = result as? Error ?? APIError(description: "Unknown Error")
                failClosure(error)
                return
            }
            thenClosure(parsedResult)
        }
    }
    
    private func addToQueue(for request: DataRequestComparable, _ runner: @escaping Observer) {
        guard let queue = requestQueue[request] else {
            requestQueue[request] = [runner]
            return
        }
        var mutableQueue = queue
        mutableQueue.append(runner)
        requestQueue[request] = mutableQueue
    }
    
    private func getAndRemoveAllQueue(for request: DataRequest) -> [Observer] {
        guard let requestComparable = onGoingRequest(for: request),
            let observers = requestQueue[requestComparable] else { return [] }
        requestQueue.removeValue(forKey: requestComparable)
        return observers
    }
    
    private func sameRequest(for request: DataRequest) -> DataRequestComparable? {
        let requestComparable = DataRequestComparable(dataRequest: request)
        let sameRequest = requestQueue.first { $0.key == requestComparable }
        return sameRequest?.key
    }
    
    private func onGoingRequest(for request: DataRequest) -> DataRequestComparable? {
        guard let sameRequest = sameRequest(for: request) else {
            return nil
        }
        guard !sameRequest.dataRequest.isCancelled else {
            requestQueue.removeValue(forKey: sameRequest)
            return nil
        }
        return sameRequest
    }
    
    private func addOperation<Result>(for request: DataRequest, resultType: Result.Type) {
        operationQueue.addOperation {
            request.validate(statusCode: 200..<300).responseData { [weak self] response in
                guard let self = self else { return }
                let observers = self.getAndRemoveAllQueue(for: request)
                dispatchOnMainThread {
                    let result: Any = response.error ?? APIResult<Result>(raw: response)
                    observers.forEach { completion in
                        completion(result)
                    }
                }
            }
        }
    }
    
    public class DataRequestComparable: Hashable {
        var dataRequest: DataRequest
        
        init(dataRequest: DataRequest) {
            self.dataRequest = dataRequest
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(dataRequest.request?.url)
            hasher.combine(dataRequest.request?.allHTTPHeaderFields)
            hasher.combine(dataRequest.request?.httpBody)
        }
        
        public static func == (lhs: APIQueueHandler.DataRequestComparable, rhs: APIQueueHandler.DataRequestComparable) -> Bool {
            lhs.dataRequest.request?.url == rhs.dataRequest.request?.url
                && lhs.dataRequest.request?.allHTTPHeaderFields == rhs.dataRequest.request?.allHTTPHeaderFields
                && lhs.dataRequest.request?.httpBody == rhs.dataRequest.request?.httpBody
        }
        
        
    }
}
