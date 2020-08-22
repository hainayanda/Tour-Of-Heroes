//
//  Promise.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Alamofire

public protocol Promise {
    associatedtype Result
    associatedtype DropableRequest: Dropable
    
    @discardableResult
    func then(run closure: @escaping (Result) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> DropableRequest
    
    @discardableResult
    func then(run closure: @escaping (Result) -> Void) -> DropableRequest
}


public protocol Dropable {
    func drop()
}

extension DataRequest: Dropable {
    public func drop() {
        self.cancel()
    }
}

extension Optional: Dropable where Wrapped: Dropable {
    public func drop() {
        guard let wrapped = self else { return }
        wrapped.drop()
    }
}
