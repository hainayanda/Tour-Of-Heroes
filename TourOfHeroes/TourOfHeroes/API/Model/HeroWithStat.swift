//
//  HeroWithStat.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import RealmSwift

public class HeroWithStat: Object, Codable, ParseableFromJSON {
    public var id: Int = 0
    public var name: String = ""
    public var localizedName: String = ""
    public var primaryAttr: String = ""
    public var attackType: String = ""
    public var roles: [String] = []
    public var img: String = ""
    public var icon: String = ""
    public var proWin: Int = 0
    public var proPick: Int = 0
    public var heroId: Int = 0
    public var proBan: Int = 0
    public var onePick: Int = 0
    public var oneWin: Int = 0
    public var twoPick: Int = 0
    public var twoWin: Int = 0
    public var threePick: Int = 0
    public var threeWin: Int = 0
    public var fourPick: Int = 0
    public var fourWin: Int = 0
    public var fivePick: Int = 0
    public var fiveWin: Int = 0
    public var sixPick: Int = 0
    public var sixWin: Int = 0
    public var sevenPick: Int = 0
    public var sevenWin: Int = 0
    
    public init(hero: Hero, withStats stats: HeroStat) {
        id = hero.id
        name = hero.name
        localizedName = hero.localizedName
        primaryAttr = hero.primaryAttr
        attackType = hero.attackType
        roles = hero.roles
        img = stats.img
        icon = stats.icon
        proWin = stats.proWin
        proPick = stats.proPick
        heroId = stats.heroId
        proBan = stats.proBan
        onePick = stats.onePick
        oneWin = stats.oneWin
        twoPick = stats.twoPick
        twoWin = stats.twoWin
        threePick = stats.threePick
        threeWin = stats.threeWin
        fourPick = stats.fourPick
        fourWin = stats.fourWin
        fivePick = stats.fivePick
        fiveWin = stats.fiveWin
        sixPick = stats.sixPick
        sixWin = stats.sixWin
        sevenPick = stats.sevenPick
        sevenWin = stats.sevenWin
    }
    
    public required init() {
        super.init()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case localizedName = "localized_name"
        case img
        case icon
        case proWin = "pro_win"
        case proPick = "pro_pick"
        case heroId = "hero_id"
        case proBan = "pro_ban"
        case onePick = "1_pick"
        case oneWin = "1_win"
        case twoPick = "2_pick"
        case twoWin = "2_win"
        case threePick = "3_pick"
        case threeWin = "3_win"
        case fourPick = "4_pick"
        case fourWin = "4_win"
        case fivePick = "5_pick"
        case fiveWin = "5_win"
        case sixPick = "6_pick"
        case sixWin = "6_win"
        case sevenPick = "7_pick"
        case sevenWin = "7_win"
        case primaryAttr = "primary_attr"
        case attackType = "attack_type"
        case roles
    }
}
