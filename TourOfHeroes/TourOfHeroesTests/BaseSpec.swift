//
//  BaseSpec.swift
//  TourOfHeroesTests
//
//  Created by Nayanda Haberty (ID) on 09/09/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Quick
import NamadaInject
import TourOfHeroes

class BaseSpec: QuickSpec {
    override func spec() {
        NamadaInjector.provide(for: HeroRouter.self, HeroRouterMock())
        NamadaInjector.provide(for: HeroRepositoryManager.self, HeroRepositoryMock())
    }
}
