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

protocol HeroRepositoryManager {
    func getHero(withId identifier: Int) -> RepositoryPromise<HeroWithStat>
    func getAllHero() -> RepositoryPromise<[HeroWithStat]>
}

public class HeroRepository: HeroRepositoryManager {
    func getHero(withId identifier: Int) -> RepositoryPromise<HeroWithStat> {
        return IdentifiedHeroRequest(identifier: identifier, ignoreAPIWhenPresent: true)
    }
    func getAllHero() -> RepositoryPromise<[HeroWithStat]> {
        return AllHeroesRequest()
    }
}

protocol HeroWithStatsAggregator {
    var apiManager: HeroAPIManager { get }
    func getHeroes(then : @escaping ([HeroWithStat]) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> Dropable
}

extension HeroWithStatsAggregator {
    public func getHeroes(then successClosure: @escaping ([HeroWithStat]) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> Dropable {
        apiManager.getAllHeroes().aggregate(with: apiManager.getAllHeroStats())
            .then(run: { heroResult, heroesStatResults in
                guard let heroes = heroResult.parsedResponse, let heroStats = heroesStatResults.parsedResponse else {
                    failClosure(APIError(description: "Failed to parse Heroes"))
                    return
                }
                successClosure(
                    heroes.compactMap { hero in
                        guard let stat = heroStats.first(where: { $0.id == hero.id }) else { return nil }
                        return HeroWithStat(hero: hero, withStats: stat)
                    }
                )
            }, whenFailed: { captured in
                guard let error = captured.firstCapturedError ?? captured.secondCapturedError else {
                    failClosure(APIError(description: "Unknown Error"))
                    return
                }
                failClosure(error)
            }
        )
    }
}

protocol HeroWithStatsCache {
    static func getCachedHeroes(then run: @escaping ([HeroWithStat]?) -> Void) -> DispatchWorkItem
    static func putToCache(_ heroes: [HeroWithStat])
}

extension HeroWithStatsCache {
    static func getCachedHeroes(then run: @escaping ([HeroWithStat]?) -> Void) -> DispatchWorkItem {
        let worker = DispatchWorkItem {
            guard let realm = try? Realm() else {
                run(nil)
                return
            }
            let result = Array(realm.objects(HeroWithStat.self))
            dispatchOnMainThread {
                run(result)
            }
        }
        defer {
            DispatchQueue.global().async(execute: worker)
        }
        return worker
    }
    
    static func putToCache(_ heroes: [HeroWithStat]) {
        guard let realm = try? Realm() else { return }
        do {
            try realm.write {
                realm.add(heroes)
            }
        } catch {
            print("Failed to store Heroes into Cache")
        }
    }
}

public class AllHeroesRequest: RepositoryPromise<[HeroWithStat]>, HeroWithStatsAggregator, HeroWithStatsCache {
    var apiManager: HeroAPIManager = HeroAPI.instance
    private var dropableRequest: Dropable?
    private var worker: DispatchWorkItem?
    
    public override func drop() {
        dropableRequest?.drop()
        worker?.cancel()
    }
    
    public override func then(run: @escaping ([HeroWithStat]) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> Self {
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

public class IdentifiedHeroRequest: RepositoryPromise<HeroWithStat>, HeroWithStatsAggregator, HeroWithStatsCache {
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
    
    public override func then(run: @escaping (HeroWithStat) -> Void, whenFailed failClosure: @escaping (Error) -> Void) -> Self {
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
    
    func getCachedHero(then run: @escaping (HeroWithStat?) -> Void) -> DispatchWorkItem {
        let retainedId: Int = self.identifier
        let worker = DispatchWorkItem {
            guard let realm = try? Realm() else {
                run(nil)
                return
            }
            let result = realm.objects(HeroWithStat.self).filter("id == \(retainedId)").first
            run(result)
        }
        defer {
            DispatchQueue.global().async(execute: worker)
        }
        return worker
    }
    
}
