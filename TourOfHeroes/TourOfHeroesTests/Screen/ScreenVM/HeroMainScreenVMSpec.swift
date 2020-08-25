//
//  HeroMainScreenVMSpec.swift
//  TourOfHeroesTests
//
//  Created by Nayanda Haberty (ID) on 25/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import TourOfHeroes

class HeroMainScreenVMSpec: QuickSpec {
    override func spec() {
        var testableVM: HeroMainScreenVM!
        var mockScreen: HeroMainScreen!
        var repoMock: HeroRepositoryMock!
        var routerMock: HeroRouterMock!
        describe("view model behaviour") {
            beforeEach {
                testableVM = .init()
                mockScreen = .init()
                repoMock = .init()
                routerMock = .init()
                repoMock.allHeroDelay = 0.5
                testableVM.heroRepository = repoMock
                testableVM.heroRouter = routerMock
                testableVM.bind(with: mockScreen)
            }
            context("positive case") {
                var mockedHeroes: [Hero]!
                beforeEach {
                    mockedHeroes = generateHeroes()
                    repoMock.allHeroMockResult = .success(mockedHeroes)
                }
                it("should do loading and remove it after success request") {
                    testableVM.loading = false
                    testableVM.reloadHeroes()
                    expect(testableVM.loading).to(beTrue())
                    expect(testableVM.loading).toEventually(beFalse())
                }
                it("should group heroes by its attributes") {
                    let grouped = testableVM.group(heroes: mockedHeroes)
                    var count: Int = 0
                    for group in grouped {
                        let attributes = group.primaryAttribute
                        for hero in group.heroes {
                            count += 1
                            expect(hero.primaryAttributes).to(equal(attributes))
                        }
                    }
                    expect(count).to(equal(mockedHeroes.count))
                }
                it("should construct cell correctly") {
                    let grouped = testableVM.group(heroes: mockedHeroes)
                    let selected = grouped[Int.random(in: 0..<grouped.count)]
                    let section = testableVM.constructCell(from: grouped, selectedAttribute: selected.primaryAttribute)
                    expect(section.count).to(equal(2))
                    let attrSection = section[0]
                    expect(attrSection.cells.count).to(equal(grouped.count))
                    for cell in attrSection.cells {
                        guard let attrCell = cell as? HeroAttributeCellVM else {
                            fail("Cell type is wrong, it should be HeroAttributeCellVM")
                            return
                        }
                        expect(
                            grouped.contains(where: {
                                $0.primaryAttribute == attrCell.primaryAttr
                            })
                        ).to(beTrue())
                        expect(attrCell.selected).to(equal(attrCell.primaryAttr == selected.primaryAttribute))
                    }
                    guard let selectedSection = section[1] as? UICollectionView.SupplementedSection else {
                        fail("Section type is wrong, it should be SupplementedSection")
                        return
                    }
                    guard let header = selectedSection.header as? NavigatableTitledHeader.Model else {
                        fail("Header Section type is wrong, it should be NavigatableTitledHeader")
                        return
                    }
                    expect(header.title).to(equal(selected.primaryAttribute))
                    expect(header.desc).to(equal(selected.attributeDescription))
                    expect(selectedSection.cellCount).to(equal(min(selected.heroes.count, 16)))
                    for cell in selectedSection.cells {
                        guard let heroCell = cell as? HeroCellVM else {
                            fail("Cell type is wrong, it should be HeroCellVM")
                            return
                        }
                        expect(selected.heroes.contains(heroCell.hero)).to(beTrue())
                    }
                }
                it("should reload heroes, group it and and select first attributes") {
                    testableVM.reloadHeroes()
                    let grouped = testableVM.group(heroes: mockedHeroes)
                    let selected = grouped.first!
                    expect(testableVM.heroes).toEventually(equal(grouped))
                    expect(testableVM.selectedAttrIndex).toEventually(equal(0))
                    expect(testableVM.selectedHeroes).toEventually(equal(selected.heroes))
                    expect(testableVM.selectedAttribute).toEventually(equal(selected.primaryAttribute))
                }
                context("cell selection") {
                    var grouped: [HeroCollection]!
                    beforeEach {
                        repoMock.allHeroDelay = 0
                        grouped = testableVM.group(heroes: mockedHeroes)
                        testableVM.heroes = grouped
                    }
                    it("should go to page when hero selected with its similar hero") {
                        testableVM.selectedAttrIndex = 0
                        let selectedGroup = grouped[0]
                        let randomSelect = Int.random(in: 0..<testableVM.selectedHeroes.count)
                        let selectedHero = selectedGroup.heroes[randomSelect]
                        routerMock.onRouteToHeroDetail = { screen, hero, heroes in
                            expect(screen).to(equal(mockScreen))
                            expect(hero).to(equal(selectedHero))
                            expect(heroes).to(equal(selectedGroup.heroes))
                        }
                        testableVM.heroMainScreen(mockScreen, didTapCellAt: .init(row: randomSelect, section: 1))
                    }
                    it("should select hero and reload content when attribute selected") {
                        let randomSelect = Int.random(in: 0..<grouped.count)
                        let selectedGroup = grouped[randomSelect]
                        testableVM.heroMainScreen(mockScreen, didTapCellAt: .init(row: randomSelect, section: 0))
                        expect(testableVM.selectedAttrIndex).to(equal(randomSelect))
                        expect(testableVM.selectedHeroes).to(equal(selectedGroup.heroes))
                    }
                }
            }
            context("negative case") {
                beforeEach {
                    repoMock.allHeroMockResult = .error(APIError(description: "expected error"))
                }
                it("should do loading and remove it after failed request") {
                    testableVM.loading = false
                    testableVM.reloadHeroes()
                    expect(testableVM.loading).to(beTrue())
                    expect(testableVM.loading).toEventually(beFalse())
                }
                it("should show error after failed request") {
                    testableVM.error = nil
                    testableVM.reloadHeroes()
                    expect(testableVM.error?.localizedDescription).toEventually(equal("expected error"))
                }
            }
        }
    }
}
