//
//  HeroAPI.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public protocol HeroAPIManager: APIManager {
    func getAllHeroes() -> APIPromise<[Hero]>
    func getAllHeroStats() -> APIPromise<[HeroStat]>
}

public class HeroAPI: HeroAPIManager {
    public static var instance: HeroAPIManager = HeroAPI()
    var baseUrl: String = "https://api.opendota.com/api"
    
    public func getAllHeroes() -> APIPromise<[Hero]> {
        request(build {
            $0.url = "\(baseUrl)/heroes"
            $0.method = .get
        })
    }
    
    public func getAllHeroStats() -> APIPromise<[HeroStat]> {
        request(build {
            $0.url = "\(baseUrl)/heroStats"
            $0.method = .get
        })
    }
}
