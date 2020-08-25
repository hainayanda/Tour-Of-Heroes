//
//  File.swift
//  TourOfHeroesTests
//
//  Created by Nayanda Haberty (ID) on 25/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import TourOfHeroes

fileprivate var heroAttributes: [String] = ["agi", "str", "int"]

func getRandomAttribute() -> String {
    heroAttributes[Int.random(in: 0..<3)]
}

func generateHeroes(
    count: Int = Int.random(in: 1..<100),
    attribute: [String] = [getRandomAttribute()]) -> [Hero] {
    createArray(
        count: count,
        creator: generateHero(with: attribute[Int.random(in: 0..<attribute.count)])
    )
}

func generateHero(with attribute: String = getRandomAttribute(), with rolesCount: Int = Int.random(in: 1..<10)) -> Hero {
    let hero = Hero()
    hero.id = Int.random(in: 0..<1000000)
    hero.name = .randomString()
    hero.localizedName = .randomString()
    hero.primaryAttr = attribute
    hero.attackType = .randomString()
    hero.roles.append(objectsIn: createArray(count: rolesCount, creator: .randomString()))
    hero.icon = .randomString()
    hero.baseHealth = Int.random(in: 0..<100)
    hero.baseHealthRegen = Float.random(in: 0..<1)
    hero.baseMana = Int.random(in: 0..<100)
    hero.baseManaRegen = Int.random(in: 0..<100)
    hero.baseArmor = Float.random(in: 0..<1)
    hero.baseMr = Int.random(in: 0..<100)
    hero.baseAttackMin = Int.random(in: 0..<100)
    hero.baseAttackMax = Int.random(in: 0..<100)
    hero.baseStr = Int.random(in: 0..<100)
    hero.baseAgi = Int.random(in: 0..<100)
    hero.baseInt = Int.random(in: 0..<100)
    hero.strGain = Float.random(in: 0..<1)
    hero.agiGain = Int.random(in: 0..<100)
    hero.intGain = Float.random(in: 0..<1)
    hero.attackRange = Int.random(in: 0..<100)
    hero.projectileSpeed = Int.random(in: 0..<100)
    hero.attackRate = Float.random(in: 0..<1)
    hero.moveSpeed = Int.random(in: 0..<100)
    hero.turnRate = Float.random(in: 0..<1)
    hero.cmEnabled = Bool.random()
    hero.legs = Int.random(in: 0..<100)
    hero.proBan = Int.random(in: 0..<100)
    hero.heroId = Int.random(in: 0..<100)
    hero.proWin = Int.random(in: 0..<100)
    hero.proPick = Int.random(in: 0..<100)
    hero.onePick = Int.random(in: 0..<100)
    hero.oneWin = Int.random(in: 0..<100)
    hero.twoPick = Int.random(in: 0..<100)
    hero.twoWin = Int.random(in: 0..<100)
    hero.threePick = Int.random(in: 0..<100)
    hero.threeWin = Int.random(in: 0..<100)
    hero.fourPick = Int.random(in: 0..<100)
    hero.fourWin = Int.random(in: 0..<100)
    hero.fivePick = Int.random(in: 0..<100)
    hero.fiveWin = Int.random(in: 0..<100)
    hero.sixPick = Int.random(in: 0..<100)
    hero.sixWin = Int.random(in: 0..<100)
    hero.sevenPick = Int.random(in: 0..<100)
    hero.sevenWin = Int.random(in: 0..<100)
    hero.eightPick = Int.random(in: 0..<100)
    hero.eightWin = Int.random(in: 0..<100)
    hero.nullPick = Int.random(in: 0..<100)
    hero.nullWin = Int.random(in: 0..<100)
    return hero
}

func createArray<Element>(count: Int, creator: @autoclosure () -> Element) -> [Element] {
    var result: [Element] = []
    for _ in 0 ..< count {
        result.append(creator())
    }
    return result
}
