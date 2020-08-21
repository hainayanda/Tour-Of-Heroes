//
//  Hero.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import RealmSwift

public class Hero: Object, Codable, ParseableFromJSON {
    public var id: Int = 0
    public var name: String = ""
    public var localizedName: String = ""
    public var primaryAttr: String = ""
    public var attackType: String = ""
    public var roles: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case attackType = "attack_type"
        case roles
    }
}
