//
//  HeroRouter.swift
//  TourOfHeroesTests
//
//  Created by Nayanda Haberty (ID) on 25/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
@testable import TourOfHeroes

class HeroRouterMock: HeroRouter {
    var onRouteToHeroDetail: ((UIViewController, Hero, [Hero]) -> Void)?
    func routeToHeroDetail(from screen: UIViewController, for hero: Hero, and similar: [Hero]) {
        onRouteToHeroDetail?(screen, hero, similar)
    }
}
