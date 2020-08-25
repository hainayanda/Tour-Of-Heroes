//
//  HeroRepositoryMock.swift
//  TourOfHeroesTests
//
//  Created by Nayanda Haberty (ID) on 25/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
@testable import TourOfHeroes

class HeroRepositoryMock: HeroRepositoryManager {
    var heroResult: PromiseResult<Hero> = .error(APIError())
    var heroDelay: TimeInterval = 0
    func getHero(withId identifier: Int) -> RepositoryPromise<Hero> {
        return RepositoryPromiseMockable(mock: heroResult, delayed: heroDelay)
    }
    
    var allHeroMockResult: PromiseResult<[Hero]> = .error(APIError())
    var allHeroDelay: TimeInterval = 0
    func getAllHero() -> RepositoryPromise<[Hero]> {
        return RepositoryPromiseMockable(mock: allHeroMockResult, delayed: allHeroDelay)
    }
    
}

class RepositoryPromiseMockable<Result>: RepositoryPromise<Result> {
    var dropped: Bool = false
    var mockResult: PromiseResult<Result>
    var delayed: TimeInterval
    
    init(mock: PromiseResult<Result> = .error(APIError()), delayed: TimeInterval = 0) {
        self.mockResult = mock
        self.delayed = delayed
    }
    
    @discardableResult
    open override func then(run: @escaping (Result) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> RepositoryPromise<Result> {
        dropped = false
        let result = self.mockResult
        let retainedPromise = self
        let runner: () -> Void = {
            defer {
                retainedPromise.dropped = false
            }
            guard !retainedPromise.dropped else { return }
            switch result {
            case .success(let result):
                run(result)
            case .error(let error):
                failClosure(error)
            }
        }
        if delayed <= 0 {
            runner()
            return self
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delayed, execute: runner)
        return self
    }
    
    open override func drop() {
        dropped = true
    }
}

enum PromiseResult<Result> {
    case success(Result)
    case error(Error)
}
