//
//  HeroRepository.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

public protocol HeroRepositoryManager {
    func getHero(withId identifier: Int) -> RepositoryPromise<Hero>
    func getAllHero() -> RepositoryPromise<[Hero]>
}

public class HeroRepository: HeroRepositoryManager {
    public func getHero(withId identifier: Int) -> RepositoryPromise<Hero> {
        return IdentifiedHeroRequest(identifier: identifier, ignoreAPIWhenPresent: true)
    }
    public func getAllHero() -> RepositoryPromise<[Hero]> {
        return AllHeroesRequest()
    }
}

protocol HeroWithStatsAPIGetter {
    var apiManager: HeroAPIManager { get }
    func getHeroes(then : @escaping ([Hero]) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> Dropable
}

extension HeroWithStatsAPIGetter {
    public func getHeroes(then successClosure: @escaping ([Hero]) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> Dropable {
        apiManager.getAllHeroes()
            .then(run: { result in
                guard let heroes = result.parsedResponse else {
                    failClosure(APIError(description: "Failed to parse Heroes"))
                    return
                }
                successClosure(heroes)
            }, whenFailed: failClosure
        )
    }
}

protocol HeroWithStatsCache {
    static func getCachedHeroes(then run: @escaping ([Hero]?) -> Void) -> DispatchWorkItem
    static func putToCache(_ heroes: [Hero])
}

extension HeroWithStatsCache {
    static func getCachedHeroes(then run: @escaping ([Hero]?) -> Void) -> DispatchWorkItem {
        let worker = DispatchWorkItem {
            guard let realm = try? Realm() else {
                run(nil)
                return
            }
            let result = Array(realm.objects(Hero.self))
            let copiedResult: [Hero] = result.compactMap {
                $0.copy() as? Hero
            }
            dispatchOnMainThread {
                run(copiedResult)
            }
        }
        defer {
            DispatchQueue.main.async(execute: worker)
        }
        return worker
    }
    
    static func putToCache(_ heroes: [Hero]) {
        guard let realm = try? Realm() else { return }
        do {
            try realm.write {
                realm.delete(realm.objects(Hero.self))
                realm.add(heroes)
            }
        } catch {
            print("Failed to store Heroes into Cache")
        }
    }
}

public class AllHeroesRequest: RepositoryPromise<[Hero]>, HeroWithStatsAPIGetter, HeroWithStatsCache {
    var apiManager: HeroAPIManager = HeroAPI.instance
    private var dropableRequest: Dropable?
    private var worker: DispatchWorkItem?
    
    public override func drop() {
        dropableRequest?.drop()
        worker?.cancel()
    }
    
    public override func then(run: @escaping ([Hero]) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> Self {
        defer {
            let worker = Self.getCachedHeroes { heroes in
                guard let heroes = heroes else {
                    return
                }
                run(heroes)
            }
            let dropableRequest = getHeroes(then: { heroes in
                worker.cancel()
                AllHeroesRequest.putToCache(heroes)
                run(heroes)
            }, whenFailed: { error in
                failClosure(error)
            })
            self.worker = worker
            self.dropableRequest = dropableRequest
        }
        return self
    }
}

public class IdentifiedHeroRequest: RepositoryPromise<Hero>, HeroWithStatsAPIGetter, HeroWithStatsCache {
    var apiManager: HeroAPIManager = HeroAPI.instance
    public let identifier: Int
    public let ignoreAPIWhenPresent: Bool
    private var dropableRequest: Dropable?
    private var worker: DispatchWorkItem?
    
    init(identifier: Int, ignoreAPIWhenPresent: Bool = true) {
        self.identifier = identifier
        self.ignoreAPIWhenPresent = ignoreAPIWhenPresent
    }
    
    public override func drop() {
        dropableRequest?.drop()
        worker?.cancel()
    }
    
    public override func then(run: @escaping (Hero) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> Self {
        let retainedId: Int = self.identifier
        let ignoreAPIWhenPresent = self.ignoreAPIWhenPresent
        defer {
            var dropableRequest: Dropable?
            var worker: DispatchWorkItem?
            dropableRequest = getHeroes(then: { heroes in
                guard let hero = heroes.first(where: { $0.id == retainedId }) else {
                    failClosure(APIError(description: "Hero with id \(retainedId) did not exist"))
                    return
                }
                worker?.cancel()
                run(hero)
            }, whenFailed: { error in
                failClosure(error)
            })
            worker = getCachedHero { hero in
                guard let hero = hero else {
                    return
                }
                if ignoreAPIWhenPresent { dropableRequest?.drop() }
                run(hero)
            }
            self.worker = worker
            self.dropableRequest = dropableRequest
        }
        return self
    }
    
    func getCachedHero(then run: @escaping (Hero?) -> Void) -> DispatchWorkItem {
        let retainedId: Int = self.identifier
        let worker = DispatchWorkItem {
            guard let realm = try? Realm() else {
                run(nil)
                return
            }
            let result = realm.objects(Hero.self).filter("id == \(retainedId)").first
            run(result)
        }
        defer {
            DispatchQueue.global().async(execute: worker)
        }
        return worker
    }
    
}
