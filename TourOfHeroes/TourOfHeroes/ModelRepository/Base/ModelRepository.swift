//
//  ModelRepository.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

open class ModelRepository<Model, Param> {
    public typealias SuccessAction = (Model) -> Void
    public typealias FailedAction = (Error) -> Void
    
    var successAction: SuccessAction?
    var failedAction: FailedAction?
    
    open func getModel(byParam param: Param) { }
    
    public init() { }
    
    @discardableResult
    public func didGet(then: @escaping SuccessAction) -> Self {
        successAction = then
        return self
    }
    
    @discardableResult
    public func didFailedGet(then: @escaping FailedAction) -> Self {
        failedAction = then
        return self
    }
}

public extension ModelRepository where Param == Void {
    func getModel() {
        self.getModel(byParam: ())
    }
}
