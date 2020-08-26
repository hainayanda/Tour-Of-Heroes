//
//  Hero.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on two1/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import RealmSwift

public class Hero: Object, Codable, ParseableFromJSON {
    @objc public dynamic var id: Int = 0
    @objc public dynamic var name: String = ""
    @objc public dynamic var localizedName: String = ""
    @objc public dynamic var primaryAttr: String = ""
    @objc public dynamic var attackType: String = ""
    public var roles: List<String> = .init()
    @objc public dynamic var img: String = ""
    @objc public dynamic var icon: String = ""
    @objc public dynamic var baseHealth: Int = 0
    @objc public dynamic var baseHealthRegen: Float = 0
    @objc public dynamic var baseMana: Int = 0
    @objc public dynamic var baseManaRegen: Int = 0
    @objc public dynamic var baseArmor: Float = 0
    @objc public dynamic var baseMr: Int = 0
    @objc public dynamic var baseAttackMin: Int = 0
    @objc public dynamic var baseAttackMax: Int = 0
    @objc public dynamic var baseStr: Int = 0
    @objc public dynamic var baseAgi: Int = 0
    @objc public dynamic var baseInt: Int = 0
    @objc public dynamic var strGain: Float = 0
    @objc public dynamic var agiGain: Int = 0
    @objc public dynamic var intGain: Float = 0
    @objc public dynamic var attackRange: Int = 0
    @objc public dynamic var projectileSpeed: Int = 0
    @objc public dynamic var attackRate: Float = 0
    @objc public dynamic var moveSpeed: Int = 0
    @objc public dynamic var turnRate: Float = 0
    @objc public dynamic var cmEnabled: Bool = false
    @objc public dynamic var legs: Int = 0
    @objc public dynamic var proBan: Int = 0
    @objc public dynamic var heroId: Int = 0
    @objc public dynamic var proWin: Int = 0
    @objc public dynamic var proPick: Int = 0
    @objc public dynamic var onePick: Int = 0
    @objc public dynamic var oneWin: Int = 0
    @objc public dynamic var twoPick: Int = 0
    @objc public dynamic var twoWin: Int = 0
    @objc public dynamic var threePick: Int = 0
    @objc public dynamic var threeWin: Int = 0
    @objc public dynamic var fourPick: Int = 0
    @objc public dynamic var fourWin: Int = 0
    @objc public dynamic var fivePick: Int = 0
    @objc public dynamic var fiveWin: Int = 0
    @objc public dynamic var sixPick: Int = 0
    @objc public dynamic var sixWin: Int = 0
    @objc public dynamic var sevenPick: Int = 0
    @objc public dynamic var sevenWin: Int = 0
    @objc public dynamic var eightPick: Int = 0
    @objc public dynamic var eightWin: Int = 0
    @objc public dynamic var nullPick: Int = 0
    @objc public dynamic var nullWin: Int = 0
    
    public override class func primaryKey() -> String? {
        return CodingKeys.id.rawValue
    }
    
    public required init() {
        super.init()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case attackType = "attack_type"
        case roles
        case img
        case icon
        case baseHealth = "base_health"
        case baseHealthRegen = "base_health_regen"
        case baseMana = "base_mana"
        case baseManaRegen = "base_mana_regen"
        case baseArmor = "base_armor"
        case baseMr = "base_mr"
        case baseAttackMin = "base_attack_min"
        case baseAttackMax = "base_attack_max"
        case baseStr = "base_str"
        case baseAgi = "base_agi"
        case baseInt = "base_int"
        case strGain = "str_gain"
        case agiGain = "agi_gain"
        case intGain = "int_gain"
        case attackRange = "attack_range"
        case projectileSpeed = "projectile_speed"
        case attackRate = "attack_rate"
        case moveSpeed = "move_speed"
        case turnRate = "turn_rate"
        case cmEnabled = "cm_enabled"
        case legs
        case proBan = "pro_ban"
        case heroId = "hero_id"
        case proWin = "pro_win"
        case proPick = "pro_pick"
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
        case eightPick = "8_pick"
        case eightWin = "8_win"
        case nullPick = "null_pick"
        case nullWin = "null_win"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = values.safeDecode(.id)
        name = values.safeDecode(.name)
        localizedName = values.safeDecode(.localizedName)
        primaryAttr = values.safeDecode(.primaryAttr)
        attackType = values.safeDecode(.attackType)
        let roles: [String] = values.safeDecode(.roles)
        self.roles.append(objectsIn: roles)
        img = values.safeDecode(.img)
        icon = values.safeDecode(.icon)
        baseHealth = values.safeDecode(.baseHealth)
        baseHealthRegen = values.safeDecode(.baseHealthRegen)
        baseMana = values.safeDecode(.baseMana)
        baseManaRegen = values.safeDecode(.baseManaRegen)
        baseArmor = values.safeDecode(.baseArmor)
        baseMr = values.safeDecode(.baseMr)
        baseAttackMin = values.safeDecode(.baseAttackMin)
        baseAttackMax = values.safeDecode(.baseAttackMax)
        baseStr = values.safeDecode(.baseStr)
        baseAgi = values.safeDecode(.baseAgi)
        baseInt = values.safeDecode(.baseInt)
        strGain = values.safeDecode(.strGain)
        agiGain = values.safeDecode(.agiGain)
        intGain = values.safeDecode(.intGain)
        attackRange = values.safeDecode(.attackRange)
        projectileSpeed = values.safeDecode(.projectileSpeed)
        attackRate = values.safeDecode(.attackRate)
        moveSpeed = values.safeDecode(.moveSpeed)
        turnRate = values.safeDecode(.turnRate)
        cmEnabled = values.safeDecode(.cmEnabled)
        legs = values.safeDecode(.legs)
        proBan = values.safeDecode(.proBan)
        heroId = values.safeDecode(.heroId)
        proWin = values.safeDecode(.proWin)
        proPick = values.safeDecode(.proPick)
        onePick = values.safeDecode(.onePick)
        oneWin = values.safeDecode(.oneWin)
        twoPick = values.safeDecode(.twoPick)
        twoWin = values.safeDecode(.twoWin)
        threePick = values.safeDecode(.threePick)
        threeWin = values.safeDecode(.threeWin)
        fourPick = values.safeDecode(.fourPick)
        fourWin = values.safeDecode(.fourWin)
        fivePick = values.safeDecode(.fivePick)
        fiveWin = values.safeDecode(.fiveWin)
        sixPick = values.safeDecode(.sixPick)
        sixPick = values.safeDecode(.sixPick)
        sevenPick = values.safeDecode(.sevenPick)
        sevenWin = values.safeDecode(.sevenWin)
        eightPick = values.safeDecode(.eightPick)
        eightWin = values.safeDecode(.eightWin)
        nullPick = values.safeDecode(.nullPick)
        nullWin = values.safeDecode(.nullWin)
    }
    
    public override func copy() -> Any {
        guard let selfJson = try? JSONEncoder().encode(self),
            let copied = try? JSONDecoder().decode(Hero.self, from: selfJson) else { return Hero() }
        return copied
    }
    
}

extension Hero {
    // Dummy since the back-end did not provide any of this
    private static let mappedAttributes: [String: String] = [
        "agi": "Agility",
        "str": "Strength",
        "int": "Inteligence",
    ]
    private static let mappedAttributesDescription: [String: String] = [
        "agi": """
        Heroes with agility as their primary attribute tend to be more dependent on their physical attacks and items, and are usually capable of falling back on their abilities in a pinch. Agility heroes often take carry and Gank roles.
        """,
        "str": """
        Heroes with strength as their primary attribute can be hard to kill, so they often take initiator and tank roles, initiating fights and taking most of the damage from enemy attacks.
        """,
        "int": """
        Heroes with intelligence as their primary attribute tend to rely on their abilities to deal damage or help others. Intelligence heroes often take support, gank, and pusher roles.
        """
    ]
    public var primaryAttributes: String {
        guard !self.isInvalidated else { return "" }
        return Hero.mappedAttributes[primaryAttr] ?? primaryAttr
    }
    
    public var primaryAttributesDescription: String {
        guard !self.isInvalidated else { return "" }
        return Hero.mappedAttributesDescription[primaryAttr] ?? "Unknown Attribute"
    }
    
    public var imageURL: String {
        guard !self.isInvalidated else { return "" }
        return "https://steamcdn-a.akamaihd.net/\(img)"
    }
}
