//
//  HeroRepository.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import RealmSwift

public class HeroRepository: ModelRepository<[HeroWithStat], Void> {
    
    var apiManager: HeroAPIManager = HeroAPI.instance
    
    open override func getModel(byParam param: Void) {
        getFromCache()
        getFromAPI()
    }
    
    func getFromCache() {
        if let realm = try? Realm() {
            let heroes = Array(realm.objects(HeroWithStat.self))
            if !heroes.isEmpty {
                successAction?(heroes)
            }
        }
    }
    
    func getFromAPI() {
        APIAggregator(aggregate: apiManager.getAllHeroes(), with: apiManager.getAllHeroStats())
            .then(
                run: { [weak self] heroResult, statResult in
                    guard let self = self else { return }
                    guard let heroes = heroResult.parsedResponse else {
                        self.failedAction?(APIError(description: "Failed to parse Heroes"))
                        return
                    }
                    guard let stats = statResult.parsedResponse else {
                        self.failedAction?(APIError(description: "Failed to parse Hero Statuses"))
                        return
                    }
                    let heroWithStats = self.combine(heroes: heroes, with: stats)
                    self.putToCache(heroWithStats)
                    self.successAction?(heroWithStats)
                }, whenFailed: { [weak self] captured in
                    guard let self = self else { return }
                    guard let error = captured.firstCapturedError ?? captured.secondCapturedError else {
                        self.failedAction?(APIError(description: "Unknown Error"))
                        return
                    }
                    self.failedAction?(error)
                }
        )
    }
    
    func putToCache(_ heroes: [HeroWithStat]) {
        guard let realm = try? Realm() else { return }
        do {
            try realm.write {
                realm.add(heroes)
            }
        } catch {
            print("Failed to store Heroes into Cache")
        }
    }
    
    func combine(heroes: [Hero], with stats: [HeroStat]) -> [HeroWithStat] {
        heroes.compactMap { hero in
            guard let stat = stats.first(where: { $0.id == hero.id }) else { return nil }
            return HeroWithStat(hero: hero, withStats: stat)
        }
    }
}
