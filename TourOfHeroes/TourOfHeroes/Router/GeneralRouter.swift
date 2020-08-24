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
}

public class ConcreteHeroRouter: HeroRouter {
    
    public static var shared: HeroRouter = ConcreteHeroRouter()
    
    private init() { }
    
    public func routeToHeroDetail(from screen: UIViewController, for hero: Hero, and similar: [Hero]) {
        let heroDetail = HeroDetailScreen()
        let heroDetailVM: HeroDetailScreenVM = build {
            $0.hero = hero
            $0.similarHeroes = similar
        }
        heroDetailVM.apply(to: heroDetail)
        let navigation = screen as? UINavigationController ?? screen.navigationController
        guard let navigationVC = navigation else {
            screen.showToast(message: "Failed to open Hero Detail")
            return
        }
        navigationVC.pushViewController(heroDetail, animated: true)
    }
}
