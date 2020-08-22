//
//  RepositoryPromise.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

open class RepositoryPromise<Result>: Dropable {
    open func then(run: @escaping (Result) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> RepositoryPromise<Result> {
        return self
    }
    
    open func drop() { }
}

public protocol BasicErrorProtocol: LocalizedError {
    var errorDescription: String { get }
}

public class RepositoryError: NSError, BasicErrorProtocol {
    
    public var errorDescription: String
    init(description: String? = nil) {
        let desc: String = description ?? "Unknown Error"
        errorDescription = desc
        super.init(domain: "nayanda.tour_of_heroes", code: -1, userInfo: [NSLocalizedDescriptionKey: desc])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
