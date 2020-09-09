//
//  HeroCollectionScreenVMSpec.swift
//  TourOfHeroesTests
//
//  Created by Nayanda Haberty (ID) on 09/09/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Quick
import Nimble
import NamadaInject

@testable import TourOfHeroes

class HeroCollectionScreenVMSpec: BaseSpec {
    override func spec() {
        super.spec()
        var testableVM: HeroCollectionScreenVM!
        var mockScreen: HeroCollectionScreen!
        var routerMock: HeroRouterMock!
        describe("view model behaviour") {
            beforeEach {
                testableVM = .init()
                mockScreen = .init()
                routerMock = inject(of: HeroRouter.self) as? HeroRouterMock
                testableVM.bind(with: mockScreen)
            }
            context("positive test") {
                var attribute: String!
                var mockedHeroes: [Hero]!
                var heroCollection: HeroCollection!
                beforeEach {
                    attribute = getRandomAttribute()
                    mockedHeroes = generateHeroes(count: Int.random(in: 3..<100), attribute: [attribute])
                    heroCollection = .init(attribute: attribute, description: .randomString())
                    heroCollection.heroes = mockedHeroes
                    testableVM.heroes = heroCollection
                }
                it("should construct correct cells") {
                    let section = testableVM.constructCell(from: heroCollection)
                    expect(section.count).to(equal(1))
                    let cells = section.first?.cells ?? []
                    expect(cells.isEmpty).to(beFalse())
                    expect(cells.count).to(equal(mockedHeroes.count))
                    for (index, cell) in cells.enumerated() {
                        guard let heroCell = cell as? HeroCellVM else {
                            fail("cell type is wrong")
                            return
                        }
                        expect(heroCell.hero).to(equal(mockedHeroes[index]))
                    }
                }
                it("should navigate to right hero detail when selected") {
                    let selected: Int = .random(in: 0 ..< mockedHeroes.count)
                    var routed: Bool = false
                    routerMock.onRouteToHeroDetail = { screen, hero, heroes in
                        expect(screen).to(equal(mockScreen))
                        expect(hero).to(equal(mockedHeroes[selected]))
                        expect(heroes).to(equal(mockedHeroes))
                        routed = true
                    }
                    testableVM.heroCollectionScreen(mockScreen, didTapCellAt: .init(row: selected, section: 0))
                    expect(routed).to(beTrue())
                }
            }
        }
    }
}
