//
//  HeroDetailScreenVMSpec.swift
//  TourOfHeroesTests
//
//  Created by Nayanda Haberty (ID) on 25/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Quick
import Nimble
import NamadaInject

@testable import TourOfHeroes

class HeroDetailScreenVMSpec: BaseSpec {
    override func spec() {
        super.spec()
        var testableVM: HeroDetailScreenVM!
        var mockScreen: HeroDetailScreen!
        var routerMock: HeroRouterMock!
        describe("view model behaviour") {
            beforeEach {
                testableVM = .init()
                mockScreen = .init()
                routerMock = inject(of: HeroRouter.self) as? HeroRouterMock
                testableVM.bind(with: mockScreen)
            }
            context("positive case") {
                var attribute: String!
                var mockedHero: Hero!
                var mockedSimilar: [Hero]!
                beforeEach {
                    attribute = getRandomAttribute()
                    mockedSimilar = generateHeroes(count: Int.random(in: 3..<100), attribute: [attribute])
                    mockedHero = generateHero(with: attribute)
                    testableVM.hero = mockedHero
                    testableVM.similarHeroes = mockedSimilar
                }
                it("should construct correct cells") {
                    let sections = testableVM.constructCells(from: mockedHero, andSimilar: mockedSimilar)
                    expect(sections.count).to(equal(1))
                    let section = sections[0]
                    expect(section.cellCount).to(equal(4))
                    guard let header = section.cells[0] as? HeroHeaderCell.Model else {
                        fail("Detail header type is wrong")
                        return
                    }
                    expect(header.hero).to(equal(mockedHero))
                    guard let stats = section.cells[1] as? HeroStatusCell.Model else {
                        fail("Detail stats type is wrong")
                        return
                    }
                    expect(stats.hero).to(equal(mockedHero))
                    guard let role = section.cells[2] as? RoleCell.Model else {
                        fail("Detail role type is wrong")
                        return
                    }
                    expect(role.roles).to(equal(Array(mockedHero.roles)))
                    guard let similar = section.cells[3] as? SimilarHeroCell.Model else {
                        fail("Detail similar type is wrong")
                        return
                    }
                    expect(similar.hero1).to(equal(mockedSimilar[0]))
                    expect(similar.hero2).to(equal(mockedSimilar[1]))
                    expect(similar.hero3).to(equal(mockedSimilar[2]))
                }
                it("should go to next screen if similar is selected") {
                    routerMock.onRouteToHeroDetail = { screen, hero, similar in
                        expect(screen).to(equal(mockScreen))
                        expect(hero).to(equal(mockedHero))
                        expect(similar).to(equal(mockedSimilar))
                    }
                    testableVM.didTap(hero: mockedHero)
                    
                }
            }
        }
    }
}
