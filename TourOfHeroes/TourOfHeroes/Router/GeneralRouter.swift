//
//  GeneralRouter.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

public protocol HeroRouter {
    func routeToHeroDetail(from screen: UIViewController, for hero: Hero, and similar: [Hero])
    func routeToHeroCollection(from screen: UIViewController, for heroes: HeroCollection)
}

public class ConcreteHeroRouter: HeroRouter {
    
    public init() { }
    
    public func routeToHeroDetail(from screen: UIViewController, for hero: Hero, and similar: [Hero]) {
        let heroDetail = HeroDetailScreen()
        let heroDetailVM: HeroDetailScreenVM = build {
            $0.hero = hero
            $0.similarHeroes = similar
        }
        heroDetailVM.bind(with: heroDetail)
        let navigation = screen as? UINavigationController ?? screen.navigationController
        guard let navigationVC = navigation else {
            screen.showToast(message: "Failed to open Hero Detail")
            return
        }
        navigationVC.pushViewController(heroDetail, animated: true)
    }
    
    public func routeToHeroCollection(from screen: UIViewController, for heroes: HeroCollection) {
        let heroCollection = HeroCollectionScreen()
        let heroCollectionVM: HeroCollectionScreenVM = build {
            $0.heroes = heroes
        }
        heroCollectionVM.bind(with: heroCollection)
        let navigation = screen as? UINavigationController ?? screen.navigationController
        guard let navigationVC = navigation else {
            screen.showToast(message: "Failed to open Hero Detail")
            return
        }
        navigationVC.pushViewController(heroCollection, animated: true)
    }
}
